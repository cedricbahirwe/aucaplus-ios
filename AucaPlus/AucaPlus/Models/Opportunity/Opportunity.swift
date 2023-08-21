//
//  Opportunity.swift
//  AucaPlus
//
//  Created by Cédric Bahirwe on 21/08/2023.
//

import Foundation

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
