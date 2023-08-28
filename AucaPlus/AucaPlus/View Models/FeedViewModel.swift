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
    @Published var filter: FeedFilter = .all
    
    @Published private(set) var isFetchingNews = false
    
    private var cancellables = Set<AnyCancellable>()
    
    private let newsClient: NewsClient = APIClient()
    private let authClient: AuthClient = AuthClient.shared
    
    init() {
        $filter.sink { [weak self] newFilter in
            guard let self = self else { return }
            self.getFeed(for: newFilter)
        }
        .store(in: &cancellables)
    }
    
    func setFilter(_ newFilter: FeedFilter) {
        guard filter != newFilter else { return }
        filter = newFilter
    }
    
    private func getFeed(for filter: FeedFilter) {
        let announcements = Announcement.example.replicate(2)
        let resources = RemoteResource.example.replicate(2)
        let news = News.news1.replicate(4)
        
        var result = [any FeedItem] ()
        switch filter {
        case .all:
            result = announcements + resources + news
        case .news:
            result = news
        case .resources:
            result = resources
        case .announcements:
            result = announcements
        }
        
//        items = result
        
//        items = news
    }
    
    func fetchNews() async {
        if items.isEmpty {
            isFetchingNews = true
        }
        do {
            let news = try await newsClient.getNews()
            self.items = news
            isFetchingNews = false
        } catch {
            print("❌Error", error.localizedDescription)
            isFetchingNews = false
        }
    }
    
    func createNews() async {
        do {
            let user = try await authClient.auth.session.user

            var newNews = News.news1
            newNews.id = nil
            newNews.postedDate = .now
            newNews.updatedDate = .now
            newNews.userID = user.id
            
            try await newsClient.createNews(newNews)
            print("Created")
        } catch {
            print("❌Error", error.localizedDescription)
        }
    }
    
    enum FeedFilter: String, CaseIterable {
        case all
        case news
        case announcements
        case resources
    }
}
