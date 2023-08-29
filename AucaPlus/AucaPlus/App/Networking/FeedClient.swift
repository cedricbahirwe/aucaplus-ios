//
//  FeedClient.swift
//  AucaPlus
//
//  Created by Cédric Bahirwe on 30/08/2023.
//

import Supabase

class FeedClient<T: Sociable>: APIClient {}

extension FeedClient: SociableCRUD {
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

protocol SociableCRUD {
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
