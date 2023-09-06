//
//  AucaUser.swift
//  AucaPlus
//
//  Created by Cédric Bahirwe on 15/04/2023.
//

import Foundation

protocol AucaUser: Identifiable, Codable, Equatable {
    var id: UUID? { get set }
    
    var firstName: String { get set }
    
    var lastName: String { get set }
    
    var phoneNumber: String { get set }
    
    var email: String { get set }
    
    var type: AucaUserType { get set }
    
    var about: String? { get set }
    
    var picture: URL? { get set }
    
    var createdAt: Date { get set }
    
    var updatedAt: Date { get set }
    
}

extension AucaUser {
    var createdAt: Date { .now }
    
    var updatedAt: Date { .now }
}

extension AucaUser {
    func completeName() -> String {
        "\(firstName) \(lastName)"
    }
}
