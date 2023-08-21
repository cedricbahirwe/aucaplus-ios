//
//  NewsItemViewModel.swift
//  AucaPlus
//
//  Created by Cédric Bahirwe on 26/04/2023.
//

import Foundation

final class NewsItemViewModel: ObservableObject {
    @Published var item: News
    
    init(_ item: News) {
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
}
