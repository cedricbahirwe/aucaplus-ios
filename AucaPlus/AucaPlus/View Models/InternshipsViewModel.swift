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
            internship.id = UUID().uuidString
            internship.postedDate = Date(timeIntervalSinceNow: -Double.random(in: 1000...10_0000))
            return internship
        }        
    }
}

struct Internship: Hashable, Codifiable {
    
    var id: String
    let link: InternshipLink
    
    var verified: Bool
    var source: InternshipSource
    
    var title: String?
    var description: String?
    var postedDate: Date
    var updatedDate: Date?
    
    var location: Location
    
}

#if DEBUG
extension Internship {
    static let example = Internship(
        id: "123",
        link: InternshipLink(url: URL(string: "https://example.com/internship1")!),
        verified: Bool.random(),
        source: .company("TechCo"),
        title: "Software Engineering Intern",
        description: "Work on exciting projects in a fast-paced environment.",
        postedDate: Date(timeIntervalSinceNow: -234125),
        updatedDate: nil,
        location: Location(city: "San Francisco")
    )
    
    static let examples = [
        example,
        Internship(
            id: "456",
            link: InternshipLink(url: URL(string: "https://example.com/internship2")!),
            verified: false,
            source: .other,
            title: "Marketing Intern",
            description: "Assist in creating and implementing marketing campaigns.",
            postedDate: Date(timeIntervalSinceNow: -23523),
            updatedDate: Date(timeIntervalSinceNow: -234125),
            location: Location(city: "New York")
        )
    ]
}
#endif

struct InternshipLink: Hashable, Codable {
    let url: URL
}

struct Location: Codable, Hashable {
    var city: String
    
    static let `default` = "Remote"
}

enum InternshipSource: Codable, Hashable {
    case aucaplus
    case company(String)
    case other
    
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
