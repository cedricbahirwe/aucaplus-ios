//
//  FeedViewModel.swift
//  AucaPlus
//
//  Created by Cédric Bahirwe on 15/04/2023.
//

import Foundation

final class FeedStore: ObservableObject {
    @Published var items: [ FeedItem] = Array(repeating: News.news1, count: 5)
    
    
    init() {
        loadItems()
    }
    
    func loadItems() {
        let announcements = [Announcement.example]
        let resources = [RemoteResource.example]
        let news = Array(repeating: News.news1, count: 3)
        
        items = announcements + resources + news
    }
    
    
}
