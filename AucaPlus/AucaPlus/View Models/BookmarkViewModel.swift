//
//  BookmarkViewModel.swift
//  AucaPlus
//
//  Created by Cédric Bahirwe on 22/08/2023.
//

import Foundation

final class BookmarkViewModel: ObservableObject {
    
    @Published private var bookmarks: [Bookmark] = TemporaryStorage.shared.retrieve(forKey: "bookmarks")
    
    private let bookmarkClient: BookmarkClient = AuthClient.shared
    
    var sortedBookmarks: [Bookmark] {
        bookmarks.sorted { $0.bookmarkDate > $1.bookmarkDate }
    }
    
    private func addNewBookmark(_ bookmark: Bookmark) {
        self.bookmarks.append(bookmark)
        TemporaryStorage.shared.save(object: bookmarks, forKey: "bookmarks")
    }
    
    private func removeBookmark(_ bookmark: Bookmark) {
        if let index = bookmarks.firstIndex(of: bookmark) {
            bookmarks.remove(at: index)
            TemporaryStorage.shared.save(object: bookmarks, forKey: "bookmarks")
        }
    }
}


extension BookmarkViewModel {
    
    func isEmpty() -> Bool {
        bookmarks.isEmpty
    }
    
    func clearAlls() {
        bookmarks = []
        TemporaryStorage.shared.remove(forKey: "bookmarks")
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
        fatalError()
    }
    
    func addToBookmarks(_ internship: Internship) {
        let bookmark = Bookmark(type: .internship(internship))
        addNewBookmark(bookmark)
        Task {
            await self.bookmark(internship, isBookmarking: true)
        }
    }
    
    func addToBookmarks<Item: FeedItem>(_ item: Item) {
        switch item {
        case let news as News:
            let bookmark = Bookmark(type: .news(news))
            addNewBookmark(bookmark)
            #warning("Need to add to bookmarks on the database side")
//            Task {
//                await self.bookmark(news, isBookmarking: true)
//            }
        default:
            break
        }
    }
    
    func removeFromBookmarks(_ internship: Internship) {
        let bookmark = Bookmark(type: .internship(internship))
        
        removeBookmark(bookmark)
        Task {
            await self.bookmark(internship, isBookmarking: false)
        }
    }
    
    func removeFromBookmarks<Item: FeedItem>(_ item: Item) {
        switch item {
        case let news as News:
            let bookmark = Bookmark(type: .news(news))
            removeBookmark(bookmark)
            #warning("Need to remove from bookmarks on the database side")
//            Task {
//                await self.bookmark(news, isBookmarking: false)
//            }
        default:
            break
        }
    }
    
    func getBookmarks(by type: BookmarkType) -> [Bookmark] {
        bookmarks.filter { $0.type == type }
    }
}

// MARK: - Bookmarking
extension BookmarkViewModel {
    func view(internship: Internship) async {
        guard let id = internship.id else {
            print("❌Can not update \(internship)")
            return
        }
        
        do {
            try await bookmarkClient.viewInternship(id)
        } catch {
            print("❌Error: \(error)")
        }
    }
    
    func bookmark(_ internship: Internship, isBookmarking: Bool) async {
        guard let id = internship.id else {
            print("❌Can not update \(internship)")
            return
        }
        
        do {
            if isBookmarking {
                try await bookmarkClient.bookmarkInternship(id)
            } else {
                try await bookmarkClient.unBookmarkIntership(id)
            }
        } catch {
            print("❌Error: \(error.localizedDescription)")
        }
    }
}

struct Bookmark: Equatable, Codifiable {
    var id: Int {
        switch type {
        case .internship(let item):
            return item.id!
        case .news(let item):
            return item.id!
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

