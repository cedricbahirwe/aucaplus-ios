//
//  BookmarkViewModel.swift
//  AucaPlus
//
//  Created by Cédric Bahirwe on 22/08/2023.
//

import Foundation

final class BookmarkViewModel: ObservableObject {
    
    @Published private var bookmarks: [Bookmark] = TemporaryStorage.shared.retrieve(forKey: "bookmarks")
    
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
            Task {
                await self.bookmark(news, isBookmarking: true)
            }
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
            Task {
                await self.bookmark(news, isBookmarking: false)
            }
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
    private func getBookmarker<Element: Sociable>(for item: Element) -> SocialFeed<Element> {
        return SocialFeed<Element>()
    }
    
    func view<T: Sociable>(_ item: T) async {
        guard item.id != nil else {
            Log.debug("Can not view \(item)")
            return
        }
        
        do {
            let bookmarker = getBookmarker(for: item)

            try await bookmarker.view(item.id)
        } catch {
            Log.error("Viewing Item", error)
        }
    }
    
    func bookmark<T: Sociable>(_ item: T, isBookmarking: Bool) async {
        guard item.id != nil else {
            Log.debug("Can not bookmark \(item)")
            return
        }
        
        let bookmarker = getBookmarker(for: item)
        
        do {
            if isBookmarking {
                try await bookmarker.bookmark(item.id)
            } else {
                try await bookmarker.unBookmark(item.id)
            }
        } catch {
            Log.error("Bookmarking Item", error)
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
        lhs.id == rhs.id && lhs.type == rhs.type
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

