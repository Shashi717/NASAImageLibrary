//
//  MediaDetailViewModel.swift
//  NASAImageLibrary
//
//  Created by Shashi Liyanage on 2/24/24.
//

import Foundation
import UIKit

protocol MediaDetailViewModelDelegate: AnyObject {
    func didUpdate()
}

class MediaDetailViewModel {
    private let apiClient: APIClient
    private let mediaData: MediaData

    init(apiClient: APIClient, mediaData: MediaData) {
        self.apiClient = apiClient
        self.mediaData = mediaData
    }

    var title: String {
        mediaData.title
    }
    var description: String? {
        mediaData.description
    }
    var thumbnail: UIImage?
    var fullImage: UIImage?
    var photographer: String? {
        guard let photographer = mediaData.photographer else {
            return nil
        }
        return "Photographer: \(photographer)"
    }
    var location: String? {
        guard let location = mediaData.location else {
            return nil
        }
        return "Location: \(location)"
    }
    var thumnailURLString: String?
    var fullImageURLString: String?

    weak var delegate: MediaDetailViewModelDelegate?

    func loadFullImage() {
        guard let url = fullImageURLString else {
            return
        }
        Task {
            do {
                fullImage = try await apiClient.fetchImage(url)
                delegate?.didUpdate()
            } catch {
                // log error
                NSLog("Error loading full image for media id: \(mediaData.id), error: \(error)")
            }
        }
    }

    private func loadThumbnail() async throws {
        guard let url = thumnailURLString else {
            return
        }
        do {
            thumbnail = try await apiClient.fetchImage(url)
            delegate?.didUpdate()
        } catch {
            // log error
            NSLog("Error loading thumbnail image for media id: \(mediaData.id), error: \(error.localizedDescription)")
        }
    }

    func loadMediaDetail() async throws {
        let mediaDetail = try await apiClient.fetchMediaDetail(mediaData.id)
        guard mediaDetail.collection.items.count > 0 else {
            return
        }
        let assetItems = mediaDetail.collection.items
        // find the url that contains thumbnail
        thumnailURLString = assetItems.first(where: { link in
            link.href.contains("~thumb")
        })?.href
        // find the url that contains original image
        fullImageURLString = assetItems.first(where: { link in
            link.href.contains("~orig")
        })?.href
        // load thumbnail
        try await loadThumbnail()
    }
}
