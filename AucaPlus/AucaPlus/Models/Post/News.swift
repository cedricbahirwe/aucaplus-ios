//
//  News.swift
//  AucaPlus
//
//  Created by Cédric Bahirwe on 24/04/2023.
//

import Foundation

struct News: Identifiable, Codable {
    var id: String { UUID().uuidString }
    
    var imageURL: String
    
    var schoolName: String
    
    var schoolSubtitle: String
    
    var description: AttributedString
    
    var images: [String]
    
    var postedDate: String
    
    var isVerified: Bool = true
    
    var likes: Int
    
    var views: Int
    
    mutating func like() {
        likes += 1
    }
    
    mutating func dislike() {
        likes -= 1
    }
}

extension News {
    static let example = News(imageURL: "auca.logo",
                              schoolName: "AUCA",
                              schoolSubtitle: "Adventist University of Central Africa",
                              description: News.description1,
                              images: ["auca1"],
                              postedDate: "1d",
                              likes: 21,
                              views: 104)
    
    static var description1: AttributedString = {
        var str = AttributedString("@Bridge2Rwanda")
        str.link = URL(string: "https://github.com/AUCA-DEVELOPERS")
        str.foregroundColor = .accentColor
        
        return "Today, AUCA & " + str + "'s Bridge Talent Services, signed a MoU in areas of career devpt for students/graduates. The partnership will enhance education-to-employment approach, thus enabling students to learn, apply skills to build career mobility via job readiness workshops."
    }()
}
