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

class FeedClient<T: Sociable>: APIClient {}

extension APIClient: InternshipClient {
    func createInternship(_ newBalue: Internship) async throws {
        try await client.database
            .from(DVTable.internships)
            .insert(values: newBalue)
            .execute()
    }
    
    func fetchInternships() async throws -> [Internship] {
        try await client.database
            .from(DVTable.internships)
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
            .from(DVTable.internships)
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
            .from(DVTable.internships)
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
            .from(DVTable.internships)
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
            .from(DVTable.internships)
            .delete()
            .eq(column: "id", value: id)
            .execute()
    }
}


class SocialFeed<T: Sociable>: FeedClient<T> {
    @discardableResult
    func view(_ itemID: T.ID) async throws -> T {
        var toUpdate = try await fetch(with: itemID)
        toUpdate.views += 1
        
        return try await update(with: itemID,
                                ["views": .number(Double(toUpdate.views))])
    }
    
    @discardableResult
    func bookmark(_ itemID: T.ID) async throws -> T {
        var toUpdate = try await fetch(with: itemID)
        toUpdate.bookmarks += 1
        
        return try await update(with: itemID,
                                ["bookmarks": .number(Double(toUpdate.bookmarks))])
    }
    
    @discardableResult
    func unBookmark(_ itemID: T.ID) async throws -> T {
        var toUpdate = try await fetch(with: itemID)
        toUpdate.bookmarks -= 1
        
        return try await update(with: itemID,
                                ["bookmarks": .number(Double(toUpdate.bookmarks))])
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

protocol FeedCRUD<T> {
    associatedtype T: Sociable

    func fetchAll() async throws -> [T]
    func fetch(with id: T.ID) async throws -> T
    func create(_ value: T) async throws
    @discardableResult
    func update(with id: T.ID,_ newValue: T) async throws -> T
    @discardableResult
    func update(with id: T.ID,_ newValue: [String: AnyJSON]) async throws -> T
    func delete(with id: T.ID) async throws
}


extension FeedClient: FeedCRUD {
    func fetchAll() async throws -> [T] {
        try await client.database
            .from(T.database.rawValue)
            .select()
            .order(column: "posted_at", ascending: false)
            .execute()
            .value
    }
    
    func create(_ value: T) async throws {
        try await client.database
            .from(T.database.rawValue)
            .insert(values: value)
            .execute()
    }
    
    func fetch(with id: T.ID) async throws -> T {
        guard let id = id as? URLQueryRepresentable else {
            throw APIError.invalidID
        }

        return try await client.database
            .from(T.database.rawValue)
            .select()
            .eq(column: "id", value: id)
            .single()
            .execute()
            .value
    }
    
    func update(with id: T.ID, _ newValue: T) async throws -> T {
        guard let id = id as? URLQueryRepresentable else {
            throw APIError.invalidID
        }
        
        return try await client.database
            .from(T.database.rawValue)
            .update(values: newValue, returning: .representation)
            .eq(column: "id", value: id)
            .single()
            .execute()
            .value
    }

    func update(with id: T.ID, _ newValue: [String : GoTrue.AnyJSON]) async throws -> T {
        guard let id = id as? URLQueryRepresentable else {
            throw APIError.invalidID
        }
        
        return try await client.database
            .from(T.database.rawValue)
            .update(values: newValue, returning: .representation)
            .eq(column: "id", value: id)
            .single()
            .execute()
            .value
    }
    
    func delete(with id: T.ID) async throws {
        guard let id = id as? URLQueryRepresentable else {
            throw APIError.invalidID
        }
        
        try await client.database
            .from(T.database.rawValue)
            .delete()
            .eq(column: "id", value: id)
            .execute()
    }
    
}



//protocol SocialClient<T> {
//    associatedtype T: Sociable
////    @discardableResult
//    func view(_ itemID: T.ID) async throws -> T
////    @discardableResult
////    func bookmarkInternship(_ internship: Internship.ID) async throws -> Internship
////    @discardableResult
////    func unBookmarkIntership(_ internship: Internship.ID) async throws -> Internship
////
////    @discardableResult
////    func viewNews(_ news: News.ID) async throws -> News
//    @discardableResult
//    func bookmark(_ news: T.ID) async throws -> T
//    @discardableResult
//    func unBookmark(_ news: T.ID) async throws -> T
//}

enum DVTable {
    static let internships = "internships"
    static let aucaUsers = "aucausers"
    static let news = "news"
    static let announcements = "announcements"
}

enum DBTable: String {
    case news, internships, aucaUsers
    case jobs, announcements, resources
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
                print("Json Found is", json)
            } else {
                print("❌No Json Found")
            }
        } catch {
            print("❌Error found during json printing:", error)
        }
    }
}
#endif
