//
//  AucaStaff.swift
//  AucaPlus
//
//  Created by Cédric Bahirwe on 15/04/2023.
//

import Foundation

struct AucaStaff: AucaUser {
    var id: UUID?
    var firstName: String
    var lastName: String
    var phoneNumber: String
    var email: String
    var type: AucaUserType
    var about: String?
    var picture: URL?
    
    var createdAt: Date
    
    var updatedAt: Date
}
