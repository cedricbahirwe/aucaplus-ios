//
//  InternshipsViewModel.swift
//  AucaPlus
//
//  Created by Cédric Bahirwe on 17/08/2023.
//

import Foundation
import Supabase

enum DBTable {
    static let internships = "Internships"
}

@MainActor
final class InternshipsViewModel: ObservableObject {
    @Published private var internships: [Internship] = []
    
    @Published private(set) var isAuthenticated = false
    
    var sortedInternships: [Internship] {
        internships.sorted { $0.postedDate > $1.postedDate }
    }
    
    let supabaseClient = SupabaseClient(supabaseURL: AppSecrets.projectURL,
                                        supabaseKey: AppSecrets.apiKey)
    
    // MARK: - Database
    func fetchInternships() async throws {
//        self.internships = Bundle.main.decode([Internship].self, from: "csvjson.json")
        
        let internships: [Internship] = try await supabaseClient.database
            .from(DBTable.internships)
            .select()
            .order(column: "posted_at", ascending: false)
            .execute()
            .value
        
        self.internships = internships
    }
    
    func createInternship() async throws {
        let user = try await supabaseClient.auth.session.user
        
        var internship = Internship.example
        internship.id = nil
        internship.postedDate = .now
        internship.updatedDate = .now
        internship.userID = user.id
        
        try await supabaseClient.database
            .from(DBTable.internships)
            .insert(values: internship)
            .execute()
    }
    
    func loadInternships() {
        let items =  Array(repeating: Internship.example, count: 10)
        
        self.internships = items.map {
            var internship = $0
            internship.id = Int.random(in: 1...10_000)
            internship.postedDate = Date(timeIntervalSinceNow: -Double.random(in: 1000...10_0000))
            return internship
        }
    }
}


// MARK: - Authentication
extension InternshipsViewModel {
    func signUp() async throws {
        let response = try await supabaseClient.auth.signUp(email: "cedric1@test.com", password: "password")
        
    }
    
    func signIn() async throws {
        let session = try await supabaseClient.auth.signIn(email: "cedric@test.com", password: "password")
        
        
    }
    
    func isUserAuthenticated() async {
        do {
            _ = try await supabaseClient.auth.session.user
            print("isAuthenticated")
            isAuthenticated = true
        } catch {
            isAuthenticated = false
            print("isNotAuthenticated")
        }
    }
    
    func signOut() async throws {
        try await supabaseClient.auth.signOut()
        print("isNotAuthenticated")
        isAuthenticated = false
    }

}
