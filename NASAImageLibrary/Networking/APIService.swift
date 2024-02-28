//
//  APIService.swift
//  NASAImageLibrary
//
//  Created by Shashi Liyanage on 2/24/24.
//

import Foundation

protocol APIServiceProtocol {
    func fetchData(_ url: URL) async throws -> Data
}

class APIService: APIServiceProtocol {
    func fetchData(_ url: URL) async throws -> Data {
        let request = URLRequest(url: url)
        let (data, response) = try await URLSession.shared.data(for: request)

        guard let response = response as? HTTPURLResponse,
              response.statusCode == 200 else {
            throw APIError.networkError
        }
        return data
    }
}

enum APIError: Error {
    case invalidURL
    case networkError
    case decodingError
    case encodingError
}
