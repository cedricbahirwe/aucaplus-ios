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
    
    private let internshipClient = FeedClient<Internship>()
    
    private let authClient: AuthClient = AuthClient.shared

    init() {
        internships = TemporaryStorage.shared.retrieve(forKey: "internships")
    }
    
}

// MARK: - Database
extension InternshipsViewModel {
    
    func fetchInternships() async {
        if internships.isEmpty {
            isFetchingInternships = true
        }
        
        do {
            let internships = try await internshipClient.fetchAll()
            isFetchingInternships = false
            TemporaryStorage.shared.save(object: internships, forKey: "internships")
            self.internships = internships
            
        } catch {
            Log.error("Fetching internships", error)
            isFetchingInternships = false
        }
    }
    
//    func createInternship() async {
//        do {
//            let user = try await authClient.auth.session.user
//            
//            var internship = Internship.example
//            internship.id = nil
//            internship.postedDate = .now
//            internship.updatedDate = .now
//            internship.userID = user.id
//            
//            try await internshipClient.create(internship)
//            await fetchInternships()
//        } catch {
//            Log.error("Creating Internship", error)
//        }
//    }
    
    func deleteInternship(withID id: News.ID) async {
        do {
            try await internshipClient.delete(with: id)
        } catch {
            Log.error("Deleting internship", error)
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
