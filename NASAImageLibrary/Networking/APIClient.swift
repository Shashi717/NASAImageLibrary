//
//  APIClient.swift
//  NASAImageLibrary
//
//  Created by Shashi Liyanage on 2/24/24.
//

import Foundation
import UIKit

class APIClient {
    private let apiService: APIServiceProtocol

    init(apiService: APIServiceProtocol) {
        self.apiService = apiService
    }

    func fetchMediaCollectionNextPage(_ urlString: String) async throws -> MediaCollection {
        guard let url = URL(string: urlString) else {
            throw APIError.invalidURL
        }
        return try await fetchMediaCollection(url)
    }

    func fetchMediaCollection(for query: String) async throws -> MediaCollection {
        guard let url = APIEndpoints.mediaCollectionURL(for: query) else {
            throw APIError.invalidURL
        }
        return try await fetchMediaCollection(url)
    }

    func fetchMediaDetail(_ id: String) async throws -> MediaDetail {
        guard let url = APIEndpoints.mediaAssetURL(for: id) else {
            throw APIError.invalidURL
        }
        return try await fetch(url)
    }

    func fetchImage(_ urlString: String) async throws -> UIImage {
        guard let url = URL(string: urlString) else {
            throw APIError.invalidURL
        }

        let data = try await apiService.fetchData(url)
        guard let image = UIImage(data: data) else {
            throw APIError.decodingError
        }
        return image
    }

    private func fetchMediaCollection(_ url: URL) async throws -> MediaCollection {
        let response: MediaResponse = try await fetch(url)
        return response.collection
    }

    private func fetch<T: Codable>(_ url: URL?) async throws -> T {
        guard let url = url else {
            throw APIError.invalidURL
        }
        let data = try await apiService.fetchData(url)
        guard let response = try? JSONDecoder().decode(T.self, from: data) else {
            throw APIError.decodingError
        }
        return response
    }
}
