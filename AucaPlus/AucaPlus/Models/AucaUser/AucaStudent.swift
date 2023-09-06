//
//  AucaStudent.swift
//  AucaPlus
//
//  Created by Cédric Bahirwe on 15/04/2023.
//

import Foundation

struct AucaStudent: AucaUser {
    var id: UUID?
    var firstName: String
    var lastName: String
    var phoneNumber: String
    
    var email: String
    
    var type: AucaUserType
    var about: String?
    var picture: URL?
    
    var createdAt: Date = .now
    
    var updatedAt: Date = .now
}

extension AucaStudent {
    static let example = AucaStudent(id: .init(), firstName: "Cédric", lastName: "Bahirwe", phoneNumber: "+250788123450", email : "", type: .student, about: "Software Engineering student at AUCA.", picture: URL(string: "https://picsum.photos/200"))

    static let example1 = AucaStudent(id: .init(), firstName: "Grace", lastName: "Uwase", phoneNumber: "+250788123456", email : "", type: .student, about: "I'm a software engineering student at AUCA.", picture: URL(string: "https://picsum.photos/200"))
}
