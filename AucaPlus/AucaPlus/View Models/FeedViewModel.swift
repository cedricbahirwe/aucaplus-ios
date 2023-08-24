//
//  FeedViewModel.swift
//  AucaPlus
//
//  Created by Cédric Bahirwe on 15/04/2023.
//

import Foundation
import Combine

final class FeedStore: ObservableObject {
    @Published private var items: [FeedItem] = Array(repeating: News.news1, count: 5)
    var sortedItems: [FeedItem] {
        items.sorted { $0.createdDate > $1.createdDate }
    }
    @Published var filter: FeedFilter = .all
    
    private var cancellables = Set<AnyCancellable>()

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
    
    func getFeed(for filter: FeedFilter) {
        let announcements = Announcement.example.replicate(2)
        let resources = RemoteResource.example.replicate(2)
        let news = News.news1.replicate(4)
        
        var result = [FeedItem] ()
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
        
        items = news
    }
    
    public enum FeedFilter: String, CaseIterable {
        case all
        case news
        case announcements
        case resources
    }
}
