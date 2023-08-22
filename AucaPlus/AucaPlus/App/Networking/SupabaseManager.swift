//
//  SupabaseManager.swift
//  AucaPlus
//
//  Created by Cédric Bahirwe on 22/08/2023.
//

import Foundation
import Supabase

class APIClient {
     fileprivate let client = SupabaseClient(
        supabaseURL: AppSecrets.projectURL,
        supabaseKey: AppSecrets.apiKey)
    
    enum APIError: Error {
        case invalidID
        
    }
}

extension APIClient: InternshipClient {
    func createInternship(_ newvalue: Internship) async throws {
        try await client.database
            .from(DBTable.internships)
            .insert(values: newvalue)
            .execute()
    }
    
    func fetchInternships() async throws -> [Internship] {
        try await client.database
            .from(DBTable.internships)
            .select()
            .order(column: "posted_at", ascending: false)
            .execute()
            .value
    }
    
    func updateInternship(with id: Internship.ID, with newValue: Internship) async throws {
        guard let id else {
            throw APIError.invalidID
        }
        
        try await client.database
            .from(DBTable.internships)
            .update(values: newValue)
            .eq(column: "id", value: id)
            .execute()
    }
    
    func deleteInternship(with id: Internship.ID) async throws {
        guard let id else {
            throw APIError.invalidID
        }
        
        try await client.database
            .from(DBTable.internships)
            .delete()
            .eq(column: "id", value: id)
            .execute()
    }
}

protocol InternshipClient {
    func fetchInternships() async throws -> [Internship]
    func createInternship(_ value: Internship) async throws
    func updateInternship(with id: Internship.ID, with newValue: Internship) async throws
    func deleteInternship(with id: Internship.ID) async throws
}

fileprivate enum DBTable {
    static let internships = "Internships"
}


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
    
    
    func deleteAccount() async {
    }
    
    func signOut() async throws {
        try await auth.signOut()
        await isUserAuthenticated()
    }
}

