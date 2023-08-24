//
//  Internship.swift
//  AucaPlus
//
//  Created by Cédric Bahirwe on 21/08/2023.
//

import Foundation

struct Internship: Hashable, Opportunity {
    
    var id: Int?
    
    var link: URL
    
    var verified: Bool
    
    var userID: UUID
    var source: InternshipSource
    
    var title: String
    var description: String?
    var postedDate: Date
    var updatedDate: Date?
    
    var location: String
    
    var views: Int = 100
    var bookmarks: Int = 12
}

extension Internship {
    enum CodingKeys: String, CodingKey {
        case id
        case link = "link_url"
        case verified
        case source
        case title
        case description
        case postedDate = "posted_at"
        case updatedDate = "updated_at"
        case location
        case views
        case bookmarks
        case userID = "user_id"
    }
}

enum InternshipSource: Codable, Hashable {
    case aucaplus
    case company(String)
    case other
    
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let sourceString = try container.decode(String.self)

        switch sourceString {
        case "aucaplus":
            self = .aucaplus
        case "other":
            self = .other
        default:
            self = .company(sourceString)
        }
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()

        switch self {
        case .aucaplus:
            try container.encode("aucaplus")
        case .company(let companyName):
            try container.encode(companyName)
        case .other:
            try container.encode("other")
        }
    }
    
    var name: String {
        switch self {
        case .aucaplus:
            return "AucaPlus"
        case .company(let companyName):
            return companyName
        case .other:
            return "Unknown"
        }
    }
}

#if DEBUG
extension Internship {
    static let urls = [
        "https://developer.apple.com/news/?id=8sntwknb",
        "https://github.com/appcoda/LinkPresentationDemo",
        "https://www.youtube.com/watch?v=TOmxDvCz7e4&ab_channel=MikeMikina",
        "https://form.jotform.com/232037292556558"
    ].compactMap(URL.init(string:))
    
    static let example = Internship(
        id: Int.random(in: 1...1000),
        link: URL(string: "https://developer.apple.com/news/?id=8sntwknb")!,
        verified: Bool.random(), userID: UUID(),
        source: .company("TechCo"),
        title: "Software Engineering Intern",
        description: "Work on exciting projects in a fast-paced environment.",
        postedDate: Date(timeIntervalSinceNow: -234125),
        updatedDate: nil,
        location: "Kigali",
        views: Int.random(in: 1...1000),
        bookmarks: 100
    )
    
    static let examples = [
        example,
        Internship(
            id: 456,
            link: urls.randomElement()!,
            verified: false, userID: UUID(),
            source: .other,
            title: "Marketing Intern",
            description: "Assist in creating and implementing marketing campaigns.",
            postedDate: Date(timeIntervalSinceNow: -23523),
            updatedDate: Date(timeIntervalSinceNow: -234125),
            location: "New York",
            views: Int.random(in: 1...1000),
            bookmarks: 100
        )
    ]
}
#endif
