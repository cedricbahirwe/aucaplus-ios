//
//  InternshipsViewModel.swift
//  AucaPlus
//
//  Created by Cédric Bahirwe on 17/08/2023.
//

import Foundation

@MainActor
final class InternshipsViewModel: ObservableObject {
    @Published private var internships: [Internship] = []
    
    @Published private(set) var isAuthenticated = false
    
    @Published private(set) var isFetchingInternships = false
    
    var sortedInternships: [Internship] {
        internships.sorted { $0.postedDate > $1.postedDate }
    }
    
    private let internshipClient: InternshipClient = APIClient()

    private let authClient: AuthClient = AuthClient.shared

    // MARK: - Database
    func fetchInternships() async throws {
        if internships.isEmpty {
            isFetchingInternships = true
        }
        let internships = try await internshipClient.fetchInternships()
        isFetchingInternships = false
        self.internships = internships
    }
    
    func createInternship() async throws {
        let user = try await authClient.auth.session.user
        
        var internship = Internship.example
        internship.id = nil
        internship.postedDate = .now
        internship.updatedDate = .now
        internship.userID = user.id
        
        try await internshipClient.createInternship(internship)
    }
    
    func update(_ old: Internship, with new: Internship) async {
        guard let id = old.id else {
            print("❌Can not update \(old)")
            return
        }
        
        var toUpdate = old
        toUpdate = new
        toUpdate.postedDate = old.postedDate
        toUpdate.updatedDate = .now
        
        do {
            try await internshipClient.updateInternship(with: id, with: toUpdate)
        } catch {
            print("❌Error: \(error)")
        }
    }
    
    func deleteInternship(withID id: Int) async {
        do {
            try await internshipClient.deleteInternship(with: id)
        } catch {
            print("❌Error: \(error)")
        }
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
        let response = try await authClient.auth.signUp(email: "cedric1@test.com", password: "password")
    }
    
    func signIn() async throws {
        let session = try await authClient.auth.signIn(email: "cedric@test.com", password: "password")
    }
    
    func isUserAuthenticated() async {
        do {
            _ = try await authClient.auth.session.user
            print("isAuthenticated")
            isAuthenticated = true
        } catch {
            isAuthenticated = false
            print("isNotAuthenticated")
        }
    }
    
    func signOut() async throws {
        try await authClient.auth.signOut()
        print("isNotAuthenticated")
        isAuthenticated = false
    }
}
