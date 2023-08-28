//
//  Annoucement.swift
//  AucaPlus
//
//  Created by Cédric Bahirwe on 28/08/2023.
//

import Foundation

struct Announcement: FeedItem, Codifiable {
    var id: Int?
    var title: String
    var subtitle: String?
    var link: URL?
    var userID: UUID
    var source: FeedSource?
    var type: FeedType = .announcement
    var postedDate: Date
    var updatedDate: Date?
    
    var content: AttributedString
    
    var bookmarks: Int = 0
    var views: Int = 0
    
    enum CodingKeys: String, CodingKey {
        case id
        case title, subtitle, link
        case source, type
        case postedDate = "posted_at"
        case updatedDate = "updated_at"
        case content
        case bookmarks
        case views
        case userID = "user_id"
    }
}
