//
//  SocialFeed.swift
//  AucaPlus
//
//  Created by Cédric Bahirwe on 30/08/2023.
//

import Foundation

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
