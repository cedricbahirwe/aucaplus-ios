//
//  RemoteResource.swift
//  AucaPlus
//
//  Created by Cédric Bahirwe on 28/08/2023.
//

import Foundation

struct RemoteResource: FeedItem, Codifiable {
    var id: Int?
    var title: String
    var subtitle: String?
    var userID: UUID
    var link: URL?
    var source: FeedSource?
    var type: FeedType = .resource
    var postedDate: Date
    var updatedDate: Date?
    var content: RemoteResource.Metadata
    var keywords: [String]?
    var bookmarks: Int = 0
    var views: Int = 0

    enum CodingKeys: String, CodingKey {
        case id
        case title, subtitle, link
        case source, type
        case postedDate = "posted_at"
        case updatedDate = "updated_at"
        case content
        case keywords
        case bookmarks
        case views
        case userID = "user_id"
    }

    struct Metadata: Codable {
        let type: ResourceFileType
        let size: Int?
        let owner: String?
    }

    enum ResourceFileType: String, Codable {
        case pdf
        case jpg
        case other
    }
}
