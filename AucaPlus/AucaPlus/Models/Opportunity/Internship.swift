//
//  Internship.swift
//  AucaPlus
//
//  Created by Cédric Bahirwe on 21/08/2023.
//

import Foundation

struct Internship: Hashable, Opportunity, Sociable {
    static var database: DBTable { .internships }
    
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
    
    var views: Int = 1

    var bookmarks: Int = 1
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

