//
//  News.swift
//  AucaPlus
//
//  Created by Cédric Bahirwe on 24/04/2023.
//

import Foundation

typealias Codifiable = Codable & Identifiable

struct FeedSource: Codable {
    var name: String
    var headline: String?
    var profile: URL?
}

enum FeedType: Codable {
    case news, resource, announcement
}

protocol FeedItem {
    associatedtype FeedContent: Codable
    var id: Int? { get set }
    var title: String { get set }
    var subtitle: String? { get set }
    
    var link: URL? { get set }
    
    var source: FeedSource? { get set }
    var type: FeedType { get }
    
    var content: FeedContent { get set }

    var postedDate: Date { get set }
    var updatedDate: Date? { get }
}

struct News: FeedItem, Codifiable {
    var id: Int?
    
    var title: String
    
    var subtitle: String?
    
    var link: URL?
    
    var source: FeedSource?
    
    var type: FeedType = .news
    
    var postedDate: Date
    
    var updatedDate: Date?
    
    var content: AttributedString

    // Extras
    var images: [URL]
    var tags: [String]?
    var views: Int = 0
    
    enum CodingKeys: String, CodingKey {
        case id
        case title, subtitle, link
        case source, type
        case postedDate = "posted_at"
        case updatedDate = "updated_at"
        case content
        case images = "images_url"
        case tags, views
    }
}

struct RemoteResource: FeedItem, Codifiable {
    
    var id: Int?
    
    var title: String
    
    var subtitle: String?
    
    var link: URL?
    
    var source: FeedSource?
    
    var type: FeedType = .resource
    
    var postedDate: Date
    
    var updatedDate: Date?
    
    var content: ResourceMetadata
    
    var keywords: [String]?
    
    enum CodingKeys: String, CodingKey {
        case id
        case title, subtitle, link
        case source, type
        case postedDate = "posted_at"
        case updatedDate = "updated_at"
        case content
        case keywords
    }
    
    struct ResourceMetadata: Codable {
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

struct Announcement<T: Codable>: FeedItem, Codifiable {
    var id: Int?
    
    var title: String
    
    var subtitle: String?
    
    var link: URL?
    
    var source: FeedSource?
    
    var type: FeedType = .announcement
    
    var postedDate: Date
    
    var updatedDate: Date?
    
    var content: T
}

//extension ResourceMetadata {
//    static let example = ResourceMetadata(type: .pdf,
//                                          size: 1024,
//                                          author: "John Doe",
//                                          keywords: ["remote", "resource", "internet"])
//
//    static let example2 = ResourceMetadata(type: .jpg, size: 2048, author: "Jane Doe", keywords: ["photo", "landscape", "mountain"])
//
//}


//extension RemoteResource {
//    static let example = RemoteResource(id: 1234,
//                                        name: "Remote Resource",
//                                        description: "This is a remote resource that can be accessed over the internet.", fileURL: URL(string: "https://example.com/remote-resource")!,
//                                        createdDate: Date(),
//                                        updatedDate: Date(),
//                                        metadata: .example)
//
//
//
//    static let example2 = RemoteResource(id: 5678,
//                                         name: "Mountain Photo",
//                                         description: "This is a beautiful photo of a mountain landscape.", fileURL: URL(string: "https://example.com/mountain-photo.jpg")!,
//                                         createdDate: Date(),
//                                         updatedDate: Date(),
//                                         metadata: .example2)
//}

extension News {
    static let news1 = News(
        id: 123,
        title: "Example news",
        source: FeedSource.person,
        postedDate: .now,
        content: News.description1,
        images: [URL(string: "https://example.com/image2.jpg")!],
        tags: ["football", "league", "fun"],
        views: 100
    )
    
    static var description1: AttributedString = {
        var str = AttributedString("@Bridge2Rwanda")
        str.link = URL(string: "https://github.com/aucaplus")
        str.foregroundColor = .accentColor
        
        return "Today, AUCA & " + str + "'s Bridge Talent Services, signed a MoU in areas of career devpt for students/graduates. The partnership will enhance education-to-employment approach, thus enabling students to learn, apply skills to build career mobility via job readiness workshops."
    }()
}

#if DEBUG
extension FeedItem {
    func replicate(_ count: Int) -> [Self] {
        guard count > 1 else { return [self] }
        
        var item = self

        return (0..<count).map { i in
            item.id = i
            return item
        }
    }
}

extension FeedSource {
    static let person = FeedSource(name: "Jane Do", profile: URL(string: "auca1"))
}
#endif
