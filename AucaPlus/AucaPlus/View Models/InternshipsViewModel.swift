//
//  InternshipsViewModel.swift
//  AucaPlus
//
//  Created by Cédric Bahirwe on 17/08/2023.
//

import Foundation

final class InternshipsViewModel: ObservableObject {
    @Published private var internships: [Internship] = []
    
    var sortedInternships: [Internship] {
        internships.sorted { $0.postedDate > $1.postedDate }
    }
    init() {
        loadInternships()
    }
    
    func loadInternships() {
        let items =  Array(repeating: Internship.example, count: 10)
        
        self.internships = items.map {
            var internship = $0
            internship.id = Int.random(in: 1...10_000)
            internship.postedDate = Date(timeIntervalSinceNow: -Double.random(in: 1000...10_0000))
            return internship
        }
        
        self.internships = Bundle.main.decode([Internship].self, from: "csvjson.json")

    }
}

protocol Opportunity: Identifiable, Codable {
    var id: Int? { get set }
    var verified: Bool { get set }
    var title: String { get set }
    var description: String? { get set }
    var link: URL { get set }
    var postedDate: Date { get set }
    var updatedDate: Date? { get set }

    
    var location: String { get set }

    var views: Int { get set }
    var bookmarks: Int { get set }
    
    var userID: UUID { get set }
}

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
    
    var views: Int = 0
    var bookmarks: Int = 0
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

#if DEBUG
extension Internship {
    static let example = Internship(
        id: 123,
        link: URL(string: "https://example.com/internship1")!,
        verified: Bool.random(), userID: UUID(),
        source: .company("TechCo"),
        title: "Software Engineering Intern",
        description: "Work on exciting projects in a fast-paced environment.",
        postedDate: Date(timeIntervalSinceNow: -234125),
        updatedDate: nil,
        location: "Kigali"
    )
    
    static let examples = [
        example,
        Internship(
            id: 456,
            link: URL(string: "https://example.com/internship2")!,
            verified: false, userID: UUID(),
            source: .other,
            title: "Marketing Intern",
            description: "Assist in creating and implementing marketing campaigns.",
            postedDate: Date(timeIntervalSinceNow: -23523),
            updatedDate: Date(timeIntervalSinceNow: -234125),
            location: "New York"
        )
    ]
}
#endif


extension String {
    init(city: String) {
        self = city
    }
    
    var city: String { self }
}


enum InternshipSource: Codable, Hashable {
    case aucaplus
    case company(String)
    case other
    
    enum CodingKeys: String, CodingKey {
        case source
    }
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
        var container = encoder.container(keyedBy: CodingKeys.self)

        switch self {
        case .aucaplus:
            try container.encode("aucaplus", forKey: .source)
        case .company(let companyName):
            try container.encode(companyName, forKey: .source)
        case .other:
            try container.encode("other", forKey: .source)
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
