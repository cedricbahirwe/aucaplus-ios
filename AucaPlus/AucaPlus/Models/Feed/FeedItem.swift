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
}

enum FeedType: String, Codable {
    case news, resource, announcement
}

protocol FeedItem {
    associatedtype FeedContent: Codable
    var id: Int? { get set }
    var userID: UUID { get set }
    var title: String { get set }
    var subtitle: String? { get set }
    
    var link: URL? { get set }
    
    var source: FeedSource? { get set }
    var type: FeedType { get }
    
    var content: FeedContent { get set }

    var postedDate: Date { get set }
    var updatedDate: Date? { get }
    
    var views: Int { get }
    var bookmarks: Int { get }
}
