//
//  FeedViewModel.swift
//  AucaPlus
//
//  Created by Cédric Bahirwe on 15/04/2023.
//

import Foundation
import Combine

@MainActor
final class FeedStore: ObservableObject {
    @Published private var items: [any FeedItem] = []
    var sortedItems: [any FeedItem] {
        items.sorted { $0.postedDate > $1.postedDate }
    }
    
    @Published private(set) var isFetchingNews = false
        
    private let newsClient = FeedClient<News>()
    private let authClient: AuthClient = AuthClient.shared
    
    init() {
        
//        let news: [News] = TemporaryStorage.shared.retrieve(forKey: "news")
//        items = news
    }
    
    func fetchNews() async {
        if items.isEmpty {
            isFetchingNews = true
        }
        do {
            let news = try await newsClient.fetchAll()
            isFetchingNews = false
            TemporaryStorage.shared.save(object: news, forKey: "news")
            self.items = news
        } catch {
            Log.error("Fetching news", error)
            isFetchingNews = false
        }
    }
    
    func createNews() async {
        do {
            let user = try await authClient.auth.session.user

            var newNews: News = items.last! as! News
            newNews.id = nil
            newNews.postedDate = .now
            newNews.updatedDate = .now
            newNews.userID = user.id
            newNews.content = News.description3
            
            try await newsClient.create(newNews)
        } catch {
            Log.error("Creating news", error)
        }
    }
    
    func deleteNews() async {
        do {
            let aNews = items[0] as! News
            try await newsClient.delete(with: aNews.id)// delete(with: aNews.id)
        } catch {
            Log.error("Deleting news", error)
        }
    }
    
    enum FeedFilter: String, CaseIterable {
        case all
        case news
        case announcements
        case resources
    }
}
