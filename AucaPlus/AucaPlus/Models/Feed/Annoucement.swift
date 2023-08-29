//
//  Annoucement.swift
//  AucaPlus
//
//  Created by Cédric Bahirwe on 28/08/2023.
//

import Foundation

struct Announcement: FeedItem {
    static var database: DBTable = .announcements
    var id: Int?
    var title: String
    var subtitle: String?
    var link: URL?
    var userID: UUID
    var source: FeedSource?
    var type: FeedType
    var postedDate: Date
    var updatedDate: Date?
    var content: AttributedString?
    var priority: AnnouncementPriority
    
    var bookmarks: Int
    var views: Int
    
    enum CodingKeys: String, CodingKey {
        case id
        case title, subtitle, link
        case type
        case postedDate = "posted_at"
        case updatedDate = "updated_at"
        case content
        case bookmarks
        case views
        case userID = "user_id"
        case priority
    }
    
    init(id: Int? = nil, title: String, subtitle: String? = nil, link: URL? = nil, userID: UUID, source: FeedSource? = nil, type: FeedType = .announcement, postedDate: Date, updatedDate: Date? = nil, content: AttributedString? = nil, priority: AnnouncementPriority = .medium, bookmarks: Int = 0, views: Int = 0) {
        self.id = id
        self.title = title
        self.subtitle = subtitle
        self.link = link
        self.userID = userID
        self.source = source
        self.type = type
        self.postedDate = postedDate
        self.updatedDate = updatedDate
        self.content = content
        self.priority = priority
        self.bookmarks = bookmarks
        self.views = views
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decodeIfPresent(Int.self, forKey: .id)
        self.title = try container.decode(String.self, forKey: .title)
        self.subtitle = try container.decodeIfPresent(String.self, forKey: .subtitle)
        self.link = try container.decodeIfPresent(URL.self, forKey: .link)
        self.type = try container.decode(FeedType.self, forKey: .type)
        self.postedDate = try container.decode(Date.self, forKey: .postedDate)
        self.source = try FeedSource(from: decoder)
        self.updatedDate = try container.decodeIfPresent(Date.self, forKey: .updatedDate)

        if let contentData = try container.decodeIfPresent(Data.self, forKey: .content) {
            self.content = try JSONDecoder().decode(AttributedString.self, from: contentData)
        } else if let stringData = try container.decodeIfPresent(AttributedString.self, forKey: .content) {
            self.content = stringData
        }

        self.bookmarks = try container.decode(Int.self, forKey: .bookmarks)
        self.views = try container.decode(Int.self, forKey: .views)
        self.userID = try container.decode(UUID.self, forKey: .userID)
        self.priority = try container.decode(Announcement.AnnouncementPriority.self, forKey: .priority)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(self.id, forKey: .id)
        try container.encode(self.title, forKey: .title)
        try container.encodeIfPresent(self.subtitle, forKey: .subtitle)
        try container.encodeIfPresent(self.link, forKey: .link)
        try container.encode(self.type, forKey: .type)
        try container.encode(self.postedDate, forKey: .postedDate)
        try container.encodeIfPresent(self.updatedDate, forKey: .updatedDate)
        try container.encode(self.bookmarks, forKey: .bookmarks)
        try container.encode(self.views, forKey: .views)


        try source?.encode(to: encoder)

        let jData = try JSONEncoder().encode(content)
        try container.encode(jData, forKey: .content)

        try container.encode(self.userID, forKey: .userID)
        try container.encode(self.priority, forKey: .priority)
    }
    
    enum AnnouncementPriority: String, Codable {
        case low, medium, high
    }
}
