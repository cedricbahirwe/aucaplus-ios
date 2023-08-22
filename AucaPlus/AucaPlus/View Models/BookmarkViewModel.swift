//
//  BookmarkViewModel.swift
//  AucaPlus
//
//  Created by Cédric Bahirwe on 22/08/2023.
//

import Foundation

final class BookmarkViewModel: ObservableObject {
    
    @Published private var bookmarks = [Bookmark]()
    
    var sortedBookmarks: [Bookmark] {
        bookmarks.sorted { $0.bookmarkDate > $1.bookmarkDate }
    }
}

extension BookmarkViewModel {
    
    func isEmpty() -> Bool {
        bookmarks.isEmpty
    }
    
    func clearAlls() {
        bookmarks = []
    }
    
    func isBookmarked(_ bookmark: Internship) -> Bool {
        bookmarks.contains { $0.id == bookmark.id }
    }
    
    func isBookmarked(_ news: News) -> Bool {
        bookmarks.contains { $0.id == news.id }
    }
    
    func isBookmarked(_ bookmark: Bookmark) -> Bool {
        bookmarks.contains(where: { $0.id == bookmark.id })
    }
    
    func toggleBookmarking(_ bookmark: Bookmark) {
        if isBookmarked(bookmark) {
            removeBookmark(bookmark)
        } else {
            addNewBookmark(bookmark)
        }
    }
    
    func addNewBookmark(_ bookmark: Bookmark) {
        self.bookmarks.append(bookmark)
    }
    
    func removeBookmark(_ bookmark: Bookmark) {
        if let index = bookmarks.firstIndex(of: bookmark) {
            bookmarks.remove(at: index)
        }
    }
    
    func getBookmarks(by type: BookmarkType) -> [Bookmark] {
        bookmarks.filter { $0.type == type }
    }
}

struct Bookmark: Equatable, Codifiable {
    var id: Int {
        switch type {
        case .internship(let item):
            return item.id!
        case .news(let item):
            return item.id
        }
    }
    
    let type: BookmarkType
    
    let bookmarkDate: Date
    
    init(type: BookmarkType, bookmarkDate: Date = .now) {
        self.type = type
        self.bookmarkDate = bookmarkDate
    }
    
    static func ==(lhs: Bookmark, rhs: Bookmark) -> Bool {
        lhs.id == rhs.id
    }
}

enum BookmarkType: Equatable, Codable {
    case news(News)
    case internship(Internship)
    
    static func ==(lhs: BookmarkType, rhs: BookmarkType) -> Bool {
        switch (lhs, rhs) {
        case (.news, .news), (.internship, .internship):
            return true
        default:
            return false
        }
    }
}
