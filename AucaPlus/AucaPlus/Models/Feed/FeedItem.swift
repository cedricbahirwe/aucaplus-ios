//
//  FeedItem.swift
//  AucaPlus
//
//  Created by Cédric Bahirwe on 28/08/2023.
//

import Foundation

typealias Codifiable = Codable & Identifiable

struct FeedSource: Codable {
    var name: String
    var headline: String?
    var profile: URL?
    
    enum CodingKeys: String, CodingKey {
        case sourceName = "source_name"
        case sourceHeadline = "source_headline"
        case sourceProfile = "source_profile"
    }
    
    init(name: String, headline: String? = nil, profile: URL? = nil) {
        self.name = name
        self.headline = headline
        self.profile = profile
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.name = try container.decode(String.self, forKey: .sourceName)
        self.headline = try container.decodeIfPresent(String.self, forKey: .sourceHeadline)
        self.profile = try container.decodeIfPresent(URL.self, forKey: .sourceProfile)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(name, forKey: .sourceName)
        try container.encodeIfPresent(headline, forKey: .sourceHeadline)
        try container.encodeIfPresent(profile, forKey: .sourceProfile)
    }
    
}

enum FeedType: String, Codable {
    case news, resource, announcement
}

protocol Sociable: Codifiable {
    var id: Int?  { get set }
    var bookmarks: Int { get set }
    var views: Int { get set }
    
    static var database: DBTable { get }
}

protocol FeedItem: Sociable {
    associatedtype FeedContent: Codable
    var userID: UUID { get set }
    var title: String { get set }
    var subtitle: String? { get set }
    
    var link: URL? { get set }
    
    var source: FeedSource? { get set }
    var type: FeedType { get }
    
    var content: FeedContent { get set }

    var postedDate: Date { get set }
    var updatedDate: Date? { get }
}
