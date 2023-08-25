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
    
    func getInternship(with id: Internship.ID) async throws -> Internship {
        guard let id else {
            throw APIError.invalidID
        }
        
        return try await client.database
            .from(DBTable.internships)
            .select()
            .eq(column: "id", value: id)
            .single()
            .execute()
            .value
    }
    
    func updateInternship(with id: Internship.ID, with newValue: Internship) async throws -> Internship {
        guard let id else {
            throw APIError.invalidID
        }

        return try await client.database
            .from(DBTable.internships)
            .update(values: newValue, returning: .representation)
            .eq(column: "id", value: id)
            .single()
            .execute()
            .value
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


extension APIClient: BookmarkClient {
    func viewInternship(_ internship: Internship.ID) async throws -> Internship  {
        guard let internship else {
            throw APIError.invalidID
        }
        
        var toUpdate = try await getInternship(with: internship)
        toUpdate.views += 1
        
        return try await updateInternship(with: internship, with: toUpdate)
    }
    
    @discardableResult
    func bookmarkInternship(_ internship: Internship.ID) async throws -> Internship {
        guard let internship else {
            throw APIError.invalidID
        }
        
        var toUpdate = try await getInternship(with: internship)
        toUpdate.bookmarks += 1
        
        return try await updateInternship(with: internship, with: toUpdate)
    }
    
    func unBookmarkIntership(_ internship: Internship.ID) async throws -> Internship {
        guard let internship else {
            throw APIError.invalidID
        }
        
        var toUpdate = try await getInternship(with: internship)
        toUpdate.bookmarks -= 1
        
        return try await updateInternship(with: internship, with: toUpdate)
    }
}

protocol InternshipClient {
    func fetchInternships() async throws -> [Internship]
    func getInternship(with id: Internship.ID) async throws -> Internship
    func createInternship(_ value: Internship) async throws
    
    func updateInternship(with id: Internship.ID, with newValue: Internship) async throws -> Internship
    func deleteInternship(with id: Internship.ID) async throws
    
}

protocol BookmarkClient {
    @discardableResult
    func viewInternship(_ internship: Internship.ID) async throws -> Internship
    @discardableResult
    func bookmarkInternship(_ internship: Internship.ID) async throws -> Internship
    @discardableResult
    func unBookmarkIntership(_ internship: Internship.ID) async throws -> Internship
}

fileprivate enum DBTable {
    static let internships = "internships"
    static let aucaUsers = "aucausers"
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
        fatalError()
    }
    
    func signOut() async throws {
        try await auth.signOut()
        await isUserAuthenticated()
    }
}



extension Supabase.User {
    func toAucaStudent() -> AucaStudent {
        AucaStudent(id: id,
                    firstName: userMetadata["first_name"]?.value as? String ?? "",
                    lastName: userMetadata["last_name"]?.value as? String ?? "",
                    phoneNumber: phone ?? "",
                    email: email ?? "",
                    type: .init(rawValue: userMetadata["account_type"]?.value as? String ?? "") ?? .visitor,
                    about: userMetadata["about"]?.value as? String,
                    picture: userMetadata["picture"]?.value as? URL,
                    createdAt: createdAt,
                    updatedAt: updatedAt)
    }
}
