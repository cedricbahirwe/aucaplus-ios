//
//  AuthClient.swift
//  AucaPlus
//
//  Created by Cédric Bahirwe on 30/08/2023.
//

import Foundation
import Supabase

class AuthClient: APIClient, ObservableObject {
    static let shared = AuthClient()
    
    @Published private(set) var isAuthenticated = false
    
    var auth: GoTrueClient  {
        client.auth
    }
    
    private override init() {
        super.init()
        Task {
            await isUserAuthenticated()
        }
    }
    
    func isUserAuthenticated() async {
        do {
            _ = try await auth.session.user
            isAuthenticated = true
        } catch {
            isAuthenticated = false
        }
    }
    
    func signOut() async throws {
        try await auth.signOut()
        await isUserAuthenticated()
    }
}
