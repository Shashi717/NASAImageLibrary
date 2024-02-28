//
//  APIEndpoints.swift
//  NASAImageLibrary
//
//  Created by Shashi Liyanage on 2/24/24.
//

import Foundation

struct APIEndpoints {
    private static let apiRoot = "https://images-api.nasa.gov"

    static func mediaCollectionURL(for query: String) -> URL? {
        var urlComponents = URLComponents(string: "\(apiRoot)/search")
        urlComponents?.queryItems = [URLQueryItem(name: "q", value: query),
                                     URLQueryItem(name: "page_size", value: "50")
        ]
        return urlComponents?.url
    }

    static func mediaAssetURL(for id: String) -> URL? {
        let urlString = "\(apiRoot)/asset/\(id)"
        return URL(string: urlString)
    }
}
