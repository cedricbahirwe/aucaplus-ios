//
//  Date+Extensions.swift
//  AucaPlus
//
//  Created by Cédric Bahirwe on 17/08/2023.
//

import Foundation


extension Date {
    var timeAgo: String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .full
        
        return formatter.localizedString(for: self, relativeTo: Date.now)        
    }
}
