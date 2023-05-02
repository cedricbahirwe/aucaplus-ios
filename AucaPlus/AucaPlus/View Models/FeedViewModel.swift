//
//  FeedViewModel.swift
//  AucaPlus
//
//  Created by Cédric Bahirwe on 15/04/2023.
//

import Foundation
import Combine

final class FeedStore: ObservableObject {
    @Published var items: [FeedItem] = Array(repeating: News.news1, count: 5)
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
        let announcements = Array(repeating: Announcement.example, count: 2)
        let resources = Array(repeating: RemoteResource.example, count: 2)
        let news = Array(repeating: News.news1, count: 4)
        
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
        items = result.shuffled()
    }
    
    public enum FeedFilter: String, CaseIterable {
        case all
        case news
        case announcements
        case resources
    }
}
