//
//  MediaDetail.swift
//  NASAImageLibrary
//
//  Created by Shashi Liyanage on 2/24/24.
//

import Foundation

struct MediaDetail: Codable {
    var collection: MediaDetailItem
}

struct MediaDetailItem: Codable {
    var href: String
    var items: [AssetLink]
    var version: String
}

struct AssetLink: Codable {
    var href: String
}
