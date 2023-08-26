//
//  FeedViewModel.swift
//  AucaPlus
//
//  Created by Cédric Bahirwe on 15/04/2023.
//

import Foundation
import Combine

final class FeedStore: ObservableObject {
    @Published private var items: [any FeedItem] = []
    var sortedItems: [any FeedItem] {
        items.sorted { $0.postedDate > $1.postedDate }
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
        
        items = result
        
        items = news
    }
    
    enum FeedFilter: String, CaseIterable {
        case all
        case news
        case announcements
        case resources
    }
}


#if DEBUG
class TemporaryStorage {
    static let shared = TemporaryStorage()
    
    private let userDefaults = UserDefaults.standard
    
    private init() { }
    
    func save<T: Codable>(object: T, forKey key: String) {
        do {
            let encodedData = try JSONEncoder().encode(object)
            userDefaults.set(encodedData, forKey: key)
        } catch {
            print("Error encoding and saving object: \(error)")
        }
    }
    
    func retrieve<T: Codable>(forKey key: String) -> T? {
        guard let encodedData = userDefaults.data(forKey: key) else {
            return nil
        }
        do {
            let decodedObject = try JSONDecoder().decode(T.self, from: encodedData)
            return decodedObject
        } catch {
            print("Error decoding object: \(error)")
            return nil
        }
    }
    
    func retrieve<T: Codable>(forKey key: String) -> [T] {
        guard let encodedData = userDefaults.data(forKey: key) else {
            print("Not data objects found")
            return []
        }
        
        do {
            let decodedObjects = try JSONDecoder().decode([T].self, from: encodedData)
            return decodedObjects
        } catch {
            print("Error decoding objects: \(error)")
            return  []
        }

    }
    
    func remove(forKey key: String) {
        userDefaults.removeObject(forKey: key)
    }
}
#endif
