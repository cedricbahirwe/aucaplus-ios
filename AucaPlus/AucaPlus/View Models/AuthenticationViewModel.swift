//
//  AuthenticationViewModel.swift
//  AucaPlus
//
//  Created by Cédric Bahirwe on 24/04/2023.
//

import Foundation

final class AuthenticationViewModel: ObservableObject {
    @Published var authModel = AuthModel()
    

    
    struct AuthModel {
        var countryCode = "250"
        var phone = ""
        
        var email = ""
        var password = ""
        
        var signingUpWithEmail = true
        
        func formattedPhone() -> String {
            return "+\(countryCode) \(phone)"
        }
        
        func isValid() -> Bool {
            if signingUpWithEmail {
                let isEmailValid = email.isValidEmail()
                let isPasswordValid = password.trimmingCharacters(in: .whitespaces).count >= 6
                return isEmailValid && isPasswordValid
            } else {
                let isCountryValid = countryCode.trimmingCharacters(in: .whitespaces).count == 3
                let isPhoneValid = phone.trimmingCharacters(in: .whitespaces).count >= 5
                return isCountryValid && isPhoneValid
            }
        }
    }
}
