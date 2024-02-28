//
//  MediaItemCollection.swift
//  NASAImageLibrary
//
//  Created by Shashi Liyanage on 2/24/24.
//

import Foundation

struct MediaCollection: Codable {
    var items: [MediaItem]
    var href: String
    var links: [Link]
    var metadata: MetaData
    var version: String
}

struct MetaData: Codable {
    var totalHits: Int

    enum CodingKeys: String, CodingKey {
        case totalHits = "total_hits"
    }
}

struct Link: Codable {
    var href: String
    var prompt: String
    var rel: String
}
