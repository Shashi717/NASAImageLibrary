//
//  MediaData.swift
//  NASAImageLibrary
//
//  Created by Shashi Liyanage on 2/24/24.
//

import Foundation

struct MediaData: Codable {
    var id: String
    var title: String
    var description: String
    var mediaType: String
    var photographer: String?
    var location: String?

    enum CodingKeys: String, CodingKey {
        case id = "nasa_id"
        case title
        case description
        case mediaType = "media_type"
        case photographer
        case location
    }
}
