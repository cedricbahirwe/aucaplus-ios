//
//  FeedViewModel.swift
//  AucaPlus
//
//  Created by Cédric Bahirwe on 15/04/2023.
//

import Foundation

final class FeedStore: ObservableObject {
    @Published var news: [News] = Array(repeating: News.example, count: 5)
}
