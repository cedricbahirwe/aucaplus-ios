//
//  TemporaryStorage.swift
//  AucaPlus
//
//  Created by Cédric Bahirwe on 28/08/2023.
//

import Foundation

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
            return []
        }
        
        do {
            let decodedObjects = try JSONDecoder().decode([T].self, from: encodedData)
            return decodedObjects
        } catch {
            print("Error decoding objects: \(error)")
            remove(forKey: key)
            return []
        }

    }
    
    func remove(forKey key: String) {
        userDefaults.removeObject(forKey: key)
    }
}
#endif