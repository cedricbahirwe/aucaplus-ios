//
//  SettingsViewModel.swift
//  AucaPlus
//
//  Created by Cédric Bahirwe on 15/04/2023.
//

import Foundation

@MainActor
final class SettingsStore: ObservableObject {
    @Published var currentUser = AucaStudent.example1
    
    private var fetchedUser: AucaStudent?
    
    var shouldUpdate: Bool {
        guard let fetchedUser else { return false }
        return fetchedUser != currentUser
    }
    
    func getUser() async {
        guard let user  = try? await AuthClient.shared.auth.session.user else { return }
        
        currentUser = AucaStudent(id: user.id,
                                  firstName: user.userMetadata["first_name"]?.value as? String ?? "",
                                  lastName: user.userMetadata["last_name"]?.value as? String ?? "",
                                  phoneNumber: user.phone ?? "",
                                  email: user.email ?? "",
                                  type: .init(rawValue: user.userMetadata["account_type"]?.value as? String ?? "") ?? .other,
                                  about: user.userMetadata["about"]?.value as? String,
                                  createdAt: user.createdAt,
                                  updatedAt: user.updatedAt)
        fetchedUser = currentUser
    }
}
