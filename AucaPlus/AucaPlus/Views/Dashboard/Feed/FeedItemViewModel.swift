//
//  FeedItemViewModel.swift
//  AucaPlus
//
//  Created by Cédric Bahirwe on 24/04/2023.
//

import Foundation

final class FeedItemViewModel: ObservableObject {
    @Published var item: News
    
    init(item: News) {
        self.item = item
    }
    
    func bookmark(_ isActive: Bool) {
        if isActive {
            item.bookmarks += 1
        } else {
            guard item.bookmarks != 0 else { return }
            item.bookmarks -= 1
        }
    }
    
    func view() {
        item.views += 0
    }
}
