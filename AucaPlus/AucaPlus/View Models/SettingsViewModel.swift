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
        
        currentUser = user.toAucaStudent()
        fetchedUser = currentUser
    }
}
