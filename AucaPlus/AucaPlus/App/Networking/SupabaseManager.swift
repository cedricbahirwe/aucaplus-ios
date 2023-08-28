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
    func createInternship(_ newBalue: Internship) async throws {
        try await client.database
            .from(DBTable.internships)
            .insert(values: newBalue)
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
    
    func updateInternship(with id: Internship.ID, with newValue: [String: AnyJSON]) async throws -> Internship {
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
        
        return try await updateInternship(with: internship,
                                          with: ["views": .number(Double(toUpdate.views))])
    }
    
    @discardableResult
    func bookmarkInternship(_ internship: Internship.ID) async throws -> Internship {
        guard let internship else {
            throw APIError.invalidID
        }
        
        var toUpdate = try await getInternship(with: internship)
        toUpdate.bookmarks += 1
        
        return try await updateInternship(with: internship,
                                          with: ["bookmarks": .number(Double(toUpdate.bookmarks))])
    }
    
    func unBookmarkIntership(_ internship: Internship.ID) async throws -> Internship {
        guard let internship else {
            throw APIError.invalidID
        }
        
        var toUpdate = try await getInternship(with: internship)
        toUpdate.bookmarks -= 1
        
        return try await updateInternship(with: internship,
                                          with: ["bookmarks": .number(Double(toUpdate.bookmarks))])
//        return try await updateInternship(with: internship, with: toUpdate)
    }
}

extension APIClient: NewsClient {
    func getNews() async throws -> [News] {
        
        return try await client.database
            .from(DBTable.news)
            .select()
            .order(column: "posted_at", ascending: false)
            .execute()
            .value
    }
    
    func createNews(_ value: News) async throws {
        if let encoded = try? JSONEncoder().encode(value) {
            if let json = try? JSONSerialization.jsonObject(with: encoded) {
                print("Here is", json)
            } else {
                print("No Json Found")
            }
        }
        try await client.database
            .from(DBTable.news)
            .insert(values: value)
            .execute()
    }
}

protocol InternshipClient {
    func fetchInternships() async throws -> [Internship]
    func getInternship(with id: Internship.ID) async throws -> Internship
    func createInternship(_ value: Internship) async throws
    
    @discardableResult
    func updateInternship(with id: Internship.ID, with newValue: Internship) async throws -> Internship
    @discardableResult
    func updateInternship(with id: Internship.ID, with newValue: [String: AnyJSON]) async throws -> Internship
    func deleteInternship(with id: Internship.ID) async throws
    
}

protocol NewsClient {
    func getNews() async throws -> [News]
    func createNews(_ value: News) async throws
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
    static let news = "news"
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


#if DEBUG
extension APIClient {
    func printJson(from table: String) async {
        do {
            let data: Data = try await client.database
                .from(table)
                .select()
                .execute()
                .underlyingResponse.data
            
            if let json = try? JSONSerialization.jsonObject(with: data) {
                print("Here is", json)
            } else {
                print("No Json Found")
            }
        } catch {
            print("Error found during json printing:", error)
        }
    }
}
#endif
