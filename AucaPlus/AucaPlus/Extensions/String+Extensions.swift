//
//  String+Extensions.swift
//  AucaPlus
//
//  Created by Cédric Bahirwe on 02/04/2023.
//

import Foundation

extension String {
    func isValidEmail() -> Bool {
        // regular expression pattern for email validation
        let pattern = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        
        do {
            // create a regular expression object with the pattern
            let regex = try NSRegularExpression(pattern: pattern)
            
            // match the regular expression against the email string
            let matches = regex.matches(in: self, range: NSRange(location: 0, length: self.count))
            
            // if there is at least one match, the email is valid
            return matches.count > 0
        } catch {
            // if there is an error creating the regular expression, the email is not valid
            return false
        }
    }
}
