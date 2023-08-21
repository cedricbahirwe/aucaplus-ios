//
//  JobsViewModel.swift
//  AucaPlus
//
//  Created by Cédric Bahirwe on 15/04/2023.
//

import Foundation

final class JobsStore: ObservableObject {
    @Published var jobs: [Job] = Array(repeating: Job.example, count: 10)
}


struct Job: Opportunity {
    var id: String
    
    var verified: Bool
    
    var title: String
    
    var description: String?
    
    var link: OpportunityLink

    var postedDate: Date
    
    var updatedDate: Date?
    
    var location: Location
    
    var views: Int
    
    var bookmarks: Int
    
    let company: Company
    
}

extension Job {
    static let example = Job(id: "123456",
                             verified: Bool.random(),
                             title: "Software Engineer",
                             description: "Join our team as a software engineer and work on cutting-edge projects.",
                             link: OpportunityLink(url: URL(string: "https://example.com/job/software-engineer")!),
                             postedDate: Date(),
                             updatedDate: nil,
                             location: .init(city: "Kigali"),
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
