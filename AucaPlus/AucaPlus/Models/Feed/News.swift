//
//  News.swift
//  AucaPlus
//
//  Created by Cédric Bahirwe on 24/04/2023.
//

import Foundation

struct News: FeedItem, Codifiable {
    var id: Int?
    
    var title: String
    var subtitle: String?
    var userID: UUID
    
    var link: URL?
    
    var source: FeedSource?
    
    var type: FeedType
    
    var postedDate: Date
    
    var updatedDate: Date?
    
    var content: AttributedString?

    // Extras
    var images: [URL]
    var tags: [String]?
    
    var bookmarks: Int
    var views: Int
    
    enum CodingKeys: String, CodingKey {
        case id
        case title, subtitle, link
        case type
        case postedDate = "posted_at"
        case updatedDate = "updated_at"
        case content
        case images
        case tags, bookmarks, views
        
        case sourceName = "source_name"
        case sourceHeadline = "source_headline"
        case sourceProfile = "source_profile"
        case userID = "user_id"

    }
    
    init(id: Int? = nil, title: String, subtitle: String? = nil, userID: UUID, link: URL? = nil, source: FeedSource? = nil, postedDate: Date, updatedDate: Date? = nil, content: AttributedString, images: [URL], tags: [String]? = nil, bookmarks: Int = 0, views: Int = 0) {
        self.id = id
        self.title = title
        self.subtitle = subtitle
        self.link = link
        self.userID = userID
        self.source = source
        self.type = .news
        self.postedDate = postedDate
        self.updatedDate = updatedDate
        self.content = content
        self.images = images
        self.tags = tags
        self.bookmarks = bookmarks
        self.views = views
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decodeIfPresent(Int.self, forKey: .id)
        self.title = try container.decode(String.self, forKey: .title)
        self.subtitle = try container.decodeIfPresent(String.self, forKey: .subtitle)
        self.link = try container.decodeIfPresent(URL.self, forKey: .link)
        self.userID = try container.decode(UUID.self, forKey: .userID)
        
        if let sName = try container.decodeIfPresent(String.self, forKey: .sourceName) {
            let sHeadline = try container.decodeIfPresent(String.self, forKey: .sourceHeadline)
            let sProfile = try container.decodeIfPresent(URL.self, forKey: .sourceProfile)
            self.source = FeedSource(name: sName, headline: sHeadline, profile: sProfile)
        }

        self.type = try container.decode(FeedType.self, forKey: .type)
        self.postedDate = try container.decode(Date.self, forKey: .postedDate)
        self.updatedDate = try container.decodeIfPresent(Date.self, forKey: .updatedDate)

        if let contentData = try container.decodeIfPresent(Data.self, forKey: .content) {
            self.content = try JSONDecoder().decode(AttributedString.self, from: contentData)
        } else if let stringData = try container.decodeIfPresent(AttributedString.self, forKey: .content) {
            self.content = stringData
        }
        
        self.images = try container.decode([URL].self, forKey: .images)
        self.tags = try container.decodeIfPresent([String].self, forKey: .tags)
        self.bookmarks = try container.decode(Int.self, forKey: .bookmarks)
        self.views = try container.decode(Int.self, forKey: .views)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encodeIfPresent(id, forKey: .id)
        try container.encode(title, forKey: .title)
        try container.encodeIfPresent(subtitle, forKey: .subtitle)
        try container.encodeIfPresent(link, forKey: .link)
        try container.encode(userID, forKey: .userID)
        
        // Source Encoding
        try container.encodeIfPresent(source?.name, forKey: .sourceName)
        try container.encodeIfPresent(source?.headline, forKey: .sourceHeadline)
        try container.encodeIfPresent(source?.profile, forKey: .sourceProfile)
        
        try container.encode(type, forKey: .type)
        try container.encode(updatedDate, forKey: .postedDate)
        try container.encodeIfPresent(updatedDate, forKey: .updatedDate)
                
        let jData = try JSONEncoder().encode(content)
        try container.encode(jData, forKey: .content)
        
        try container.encode(images, forKey: .images)
        
        try container.encodeIfPresent(tags, forKey: .tags)
        try container.encodeIfPresent(bookmarks, forKey: .bookmarks)
        try container.encodeIfPresent(views, forKey: .views)
    }
}
