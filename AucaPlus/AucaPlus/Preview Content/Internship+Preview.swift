//
//  Internship+Preview.swift
//  AucaPlus
//
//  Created by Cédric Bahirwe on 16/01/2024.
//

import Foundation

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
