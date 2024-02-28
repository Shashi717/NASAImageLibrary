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

    func loadMediaItems(_ query: String) {
        Task {
            let mediaCollection = try await apiClient.fetchMediaCollection(for: query)
            let collectionItems = mediaCollection.items
            // find the url for the next page
            let link: Link? = mediaCollection.links.first(where: { link in
                link.rel == "next"
            })
            nextPage = link?.href
            // set the items if it's a new query
            self.items = await loadMediaItems(collectionItems)
            delegate?.didUpdate()
        }
    }

    func loadNextPage() {
        guard let nextPageURLString = nextPage else {
            return
        }
        Task {
            let mediaCollection = try await apiClient.fetchMediaCollectionNextPage(nextPageURLString)
            let collectionItems = mediaCollection.items
            // find the url for the next page
            let link: Link? = mediaCollection.links.first(where: { link in
                link.rel == "next"
            })
            nextPage = link?.href
            // append to current items if we're loading items from next page
            self.items.append(contentsOf: await loadMediaItems(collectionItems))
            delegate?.didUpdate()
        }
    }

    private func loadMediaItems(_ collectionItems: [MediaItem]) async -> [MediaDetailViewModel] {
        let items = await withTaskGroup(of: Void.self, returning: [MediaDetailViewModel].self) { group in
            collectionItems.compactMap { item in
                // item data comes in an array, so pick the first item
                // only display "image" types
                if !item.data.isEmpty,
                   let mediaData = item.data.first, mediaData.mediaType == "image" {
                    let mediaDetailVM = MediaDetailViewModel(apiClient: apiClient, mediaData: mediaData)
                    group.addTask {
                        try? await mediaDetailVM.loadMediaDetail()
                    }
                    return mediaDetailVM
                }
                return nil
            }
        }
        return items
    }
}
