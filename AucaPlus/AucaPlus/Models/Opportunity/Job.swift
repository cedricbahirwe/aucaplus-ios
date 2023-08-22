//
//  Job.swift
//  AucaPlus
//
//  Created by Cédric Bahirwe on 22/08/2023.
//

import Foundation

struct Job: Opportunity {
    var id: Int?
    
    var userID: UUID
    
    var verified: Bool
    
    var title: String
    
    var description: String?
    
    var link: URL

    var postedDate: Date
    
    var updatedDate: Date?
    
    var location: String
    
    var views: Int
    
    var bookmarks: Int
    
    let company: Company
    
}

extension Job {
    static let example = Job(id: 123456,
                             userID: UUID(),
                             verified: Bool.random(),
                             title: "Software Engineer",
                             description: "Join our team as a software engineer and work on cutting-edge projects.",
                             link: URL(string: "https://example.com/job/software-engineer")!,
                             postedDate: Date(),
                             updatedDate: Date(),
                             location: "Kigali",
                             views: 1200,
                             bookmarks: 450,
                             company: .example)
}

struct Company: Codifiable {
    let id: Int
    let name: String
}

extension Company {
    static let example = Company(id: 1, name: "One Acre Fund")
}
