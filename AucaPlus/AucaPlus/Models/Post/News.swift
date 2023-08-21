//
//  News.swift
//  AucaPlus
//
//  Created by Cédric Bahirwe on 24/04/2023.
//

import Foundation

typealias Codifiable = Codable & Identifiable

protocol FeedItem {
    var id: Int { get set }
    var author: NewsAuthor? { get }
    var createdDate: Date { get }
}
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

extension FeedItem {
    var author: NewsAuthor? { nil }
}

struct News: FeedItem, Codifiable {
    var id: Int
    
    var imageURL: URL?
    var title: String
    var subtitle: String?
    var content: AttributedString
    
    var images: [String]
    var createdDate: Date
    var author: NewsAuthor
    var tags: [String]?
    
    var isVerified: Bool = true
    var bookmarks: Int
    var views: Int
}


struct NewsAuthor: Codable {
    let imageURL: URL?
    let name: String
    var headline: String?
    let type: NewsAuthorType
    
    enum NewsAuthorType: String, Codable {
        case `public`
        case personal
        case school
    }
}

extension NewsAuthor {
    static let school = NewsAuthor(imageURL: nil, name: "AUCA", headline: "Adventist University of Central Africa", type: .school)
    
    static let person = NewsAuthor(imageURL: nil, name: "Jane Doe", type: .public)
}

struct RemoteResource: FeedItem, Codifiable {
    var id: Int
    let name: String
    let description: String
    let fileURL: URL
    let createdDate: Date
    let updatedDate: Date?
    let metadata: ResourceMetadata
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case fileURL = "url"
        case description
        case createdDate = "created_at"
        case updatedDate = "updated_at"
        case metadata
    }
}

struct Announcement: FeedItem, Codifiable {
    var id: Int
    var author: NewsAuthor
    var createdDate: Date = .now
    var externalLink: URL?
}
extension Announcement {
    static let example = Announcement(id: 12345, author: .person)
}
struct ResourceMetadata: Codable {
    let type: ResourceFileType
    let size: Int
    let author: String
    let keywords: [String]
}

extension ResourceMetadata {
    static let example = ResourceMetadata(type: .pdf,
                                          size: 1024,
                                          author: "John Doe",
                                          keywords: ["remote", "resource", "internet"])
    
    static let example2 = ResourceMetadata(type: .jpg, size: 2048, author: "Jane Doe", keywords: ["photo", "landscape", "mountain"])
    
}

enum ResourceFileType: String, Codable {
    case pdf
    case jpg
    case other
}


extension RemoteResource {
    static let example = RemoteResource(id: 1234,
                                        name: "Remote Resource",
                                        description: "This is a remote resource that can be accessed over the internet.", fileURL: URL(string: "https://example.com/remote-resource")!,
                                        createdDate: Date(),
                                        updatedDate: Date(),
                                        metadata: .example)
    
    
    
    static let example2 = RemoteResource(id: 5678,
                                         name: "Mountain Photo",
                                         description: "This is a beautiful photo of a mountain landscape.", fileURL: URL(string: "https://example.com/mountain-photo.jpg")!,
                                         createdDate: Date(),
                                         updatedDate: Date(),
                                         metadata: .example2)
}

extension News {
    static let news1 = News(id: 1212,
                            imageURL: URL(string: "auca1"),
                            title: "Example News 1",
                            subtitle: "An example subtitle for News 1",
                            content: News.description1,
                            images: ["auca1", "https://example.com/image2.jpg"],
                            createdDate: Date.now,
                            author: .school,
                            tags: ["example", "news", "swift"],
                            bookmarks: 21,
                            views: 104)
    
    static let news2 = News(id: 1212,
                            imageURL: URL(string: "jpg"),
                            title: "Example News 2",
                            subtitle: nil,
                            content: AttributedString("This is some example content for News 2"),
                            images: ["auca1"],
                            createdDate: .now,
                            author: .person,
                            tags: nil,
                            bookmarks: 5,
                            views: 50)
    
    static let news3 = News(id: 234,
                            imageURL: nil,
                            title: "Example News 3",
                            subtitle: "An example subtitle for News 3",
                            content: AttributedString("This is some example content for News 3"),
                            images: [],
                            createdDate: .now,
                            author: NewsAuthor(imageURL: nil, name: "Bob Smith", type: .school),
                            tags: ["example"],
                            bookmarks: 2,
                            views: 20)
    
    static var description1: AttributedString = {
        var str = AttributedString("@Bridge2Rwanda")
        str.link = URL(string: "https://github.com/AUCA-DEVELOPERS")
        str.foregroundColor = .accentColor
        
        return "Today, AUCA & " + str + "'s Bridge Talent Services, signed a MoU in areas of career devpt for students/graduates. The partnership will enhance education-to-employment approach, thus enabling students to learn, apply skills to build career mobility via job readiness workshops."
    }()
}
