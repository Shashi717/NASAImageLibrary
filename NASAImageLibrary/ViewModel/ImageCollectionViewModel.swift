//
//  ImageCollectionViewModel.swift
//  NASAImageLibrary
//
//  Created by Shashi Liyanage on 2/24/24.
//

import Foundation

protocol ImageCollectionViewModelDelegate: AnyObject {
    func didUpdate()
}

class ImageCollectionViewModel {
    private let apiClient: APIClient

    var items: [MediaDetailViewModel] = []
    var nextPage: String?

    weak var delegate: ImageCollectionViewModelDelegate?

    init(apiClient: APIClient) {
        self.apiClient = apiClient
    }

    private var currentTask: Task<Void, Error>?

    func loadMediaItems(_ query: String) {
        // if we are loading the items from a query, we can cancel the current running
        // task because it's a new search
        currentTask?.cancel()
        currentTask = Task {
            do {
                let mediaCollection = try await apiClient.fetchMediaCollection(for: query)
                let collectionItems = mediaCollection.items
                setNextPage(for: mediaCollection)
                // set the items if it's a new query
                self.items = await loadMediaItems(collectionItems)
                // set current task to nil if we have the media items
                currentTask = nil
                delegate?.didUpdate()
            } catch {
                // log error
                NSLog("Error loading media collection for query: \(query), error: \(error)")
                // cancel the current task and set to nil if there's an error
                currentTask?.cancel()
                currentTask = nil
            }
        }
    }

    func loadNextPage() {
        // don't load a new page if there's a task running already
        guard let nextPageURLString = nextPage,
              currentTask == nil else {
            return
        }

        currentTask = Task {
            do {
                let mediaCollection = try await apiClient.fetchMediaCollectionNextPage(nextPageURLString)
                let collectionItems = mediaCollection.items
                setNextPage(for: mediaCollection)
                // append to current items if we're loading items from next page
                self.items.append(contentsOf: await loadMediaItems(collectionItems))
                // set current task to nil if we have the media items
                currentTask = nil
                delegate?.didUpdate()
            } catch {
                // log error
                NSLog("Error loading next page for url: \(nextPageURLString), error: \(error)")
                // cancel the current task and set to nil if there's an error
                currentTask?.cancel()
                currentTask = nil
            }
        }
    }

    private func loadMediaItems(_ collectionItems: [MediaItem]) async -> [MediaDetailViewModel] {
        let items = collectionItems.compactMap { item in
            // item data comes in an array, so pick the first item
            // only display "image" types
            if !item.data.isEmpty,
               let mediaData = item.data.first, mediaData.mediaType == "image" {
                let mediaDetailVM = MediaDetailViewModel(apiClient: apiClient, mediaData: mediaData)
                Task {
                    try? await mediaDetailVM.loadMediaDetail()
                }
                return mediaDetailVM
            }
            return nil
        }
        return items
    }

    private func setNextPage(for mediaCollection: MediaCollection) {
        // find the url for the next page
        let link: Link? = mediaCollection.links.first(where: { link in
            link.rel == "next"
        })
        guard let currentNextPage = link?.href,
              nextPage != currentNextPage else {
            // set next page to nil if it's the same as previous next page
            nextPage = nil
            return
        }
        nextPage = link?.href
    }
}
