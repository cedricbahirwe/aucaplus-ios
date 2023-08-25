//
//  InternshipsViewModel.swift
//  AucaPlus
//
//  Created by Cédric Bahirwe on 17/08/2023.
//

import Foundation

@MainActor
final class InternshipsViewModel: ObservableObject {
    @Published var internships: [Internship] = []
    
    @Published private(set) var isAuthenticated = false
    
    @Published private(set) var isFetchingInternships = false
    
    //    var sortedInternships: [Internship] {
    //        internships.sorted { $0.postedDate > $1.postedDate }
    //    }
    
    private let internshipClient: InternshipClient = APIClient()
    
    private let authClient: AuthClient = AuthClient.shared
    
    
}

// MARK: - Database
extension InternshipsViewModel {
    func fetchInternships() async {
        if internships.isEmpty {
            isFetchingInternships = true
        }
        
        do {
            let internships = try await internshipClient.fetchInternships()
            isFetchingInternships = false
            self.internships = internships
        } catch {
            print("❌\(error.localizedDescription)")
            isFetchingInternships = false
        }
    }
    
    func createInternship() async {
        do {
            let user = try await authClient.auth.session.user
            
            var internship = Internship.example
            internship.id = nil
            internship.postedDate = .now
            internship.updatedDate = .now
            internship.userID = user.id
            
            try await internshipClient.createInternship(internship)
            await fetchInternships()
            print("✅Created successfully")
        } catch {
            print("❌Error creating: \(error.localizedDescription)")
        }
    }
    
    func deleteInternship(withID id: Int) async {
        do {
            try await internshipClient.deleteInternship(with: id)
        } catch {
            print("❌Error: \(error)")
        }
    }
}


// MARK: - Authentication
extension InternshipsViewModel {
    
    func isUserAuthenticated() async {
        do {
            _ = try await authClient.auth.session.user
            isAuthenticated = true
        } catch {
            isAuthenticated = false
        }
    }
}
