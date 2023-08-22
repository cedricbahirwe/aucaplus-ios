//
//  SettingsViewModel.swift
//  AucaPlus
//
//  Created by Cédric Bahirwe on 15/04/2023.
//

import Foundation

final class SettingsStore: ObservableObject {
    @Published var currentUser: (any AucaUser)? = AucaStudent.example1
    
    func getUser() {
        
        Task {
            guard let user  = try? await AuthClient.shared.auth.session.user else { return }
            
            currentUser = AucaStudent(id: user.id,
                                      firstName: user.userMetadata["first_name"]?.value as? String ?? "",
                                      lastName: user.userMetadata["last_name"]?.value as? String ?? "",
                                      phoneNumber: user.phone ?? "",
                                      type: .init(rawValue: user.userMetadata["account_type"]?.value as? String ?? "") ?? .other,
                                      about: user.userMetadata["account_type"]?.value as? String,
                                      createdAt: user.createdAt,
                                      updatedAt: user.updatedAt)
        }
    }
    
}
