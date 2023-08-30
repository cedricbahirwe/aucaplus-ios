//
//  Opportunity.swift
//  AucaPlus
//
//  Created by Cédric Bahirwe on 21/08/2023.
//

import Foundation

protocol Opportunity: Sociable {
    var verified: Bool { get set }
    
    var title: String { get set }
    
    var description: String? { get set }
    
    var link: URL { get set }
    
    var postedDate: Date { get set }
    
    var updatedDate: Date? { get set }
    
    var location: String { get set }
    
    var userID: UUID { get set }
}
