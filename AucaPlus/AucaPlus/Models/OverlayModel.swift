//
//  OverlayModel.swift
//  AucaPlus
//
//  Created by Cédric Bahirwe on 17/08/2023.
//

import Foundation

struct OverlayModel<T>: Identifiable {
    var id: UUID { .init() }
    
    var isShown: Bool = false
    
    var data: T?
    
    mutating func present(_ newData: T) {
        data = newData
        isShown = true
    }
    
    mutating func dismiss() {
        isShown = false
        data = nil
    }
}
