//
//  AuthenticationViewModel.swift
//  AucaPlus
//
//  Created by Cédric Bahirwe on 24/04/2023.
//

import Foundation
import SwiftUI
import Supabase

@MainActor
final class AuthenticationViewModel: ObservableObject {
    
    @AppStorage(StorageKeys.isLoggedIn)
    private var isLoggedIn: Bool = false
    
    @Published var authModel = AuthModel()
    
    @Published var isSendingOTP = false
    
    @Published var isValidatingOTP = false
    
    @Published var goToOTPView = false
    
    @Published var goToUserDetails = false
    
    @Published var isSavingUserInfo = false

    
    @Published var regModel = RegisterModel()
    
    
    private let client = SupabaseClient(supabaseURL: AppSecrets.projectURL,
                                supabaseKey: AppSecrets.apiKey)
    
}


// MARK: - Authentication
extension AuthenticationViewModel {
    var phone: String {
        //250725317954
        authModel.formattedPhone().replacingOccurrences(of: " ", with: "")
    }
    
    func authorize() async {
        do {
            isSendingOTP = true
            try await client.auth.signInWithOTP(
                phone: phone)
            isSendingOTP = false
            goToOTPView = true
        } catch {
            print("✅ Sign Up Error: \(error)")
            isSendingOTP = false
        }
    }
    
    func verifyOTP(_ otp: String) async {
        do {
            isValidatingOTP = true
            try await client.auth.verifyOTP(
                phone: phone,
                token: otp,
                type: .sms)
            
            let session = try await client.auth.session
            print("✅Session Info: \(session)")
            isValidatingOTP = false
            goToUserDetails = true
        } catch {
            isValidatingOTP = false
            print("❌ Sign Up Error: \(error)")
        }
    }
    
    func saveUserInfo() async {
        do {
            #warning("should create steps to come back to in the auth flow")
            isSavingUserInfo = true
            _ = try await client.auth.session.user
            
            let metadata: [String : AnyJSON] = [
                "first_name" : .string(regModel.firstName),
                "last_name" : .string(regModel.lastName),
                "account_type" : .string(regModel.type.rawValue),
                "about": .string(regModel.about.trimmingCharacters(in: .whitespaces))
            ]
            
            let attributes = UserAttributes(
                email: regModel.email,
                data: metadata
            )
                        
            let user = try await client.auth.update(user: attributes)
            
            print("✅ Updated Info: \(user)")
            isSavingUserInfo = false
            isLoggedIn = true
        } catch {
            isSavingUserInfo = false
            print("❌ Sign Up Error: \(error)")
        }
    }
    
    func signOut() async throws {
        try await client.auth.signOut()
    }
}

extension AuthenticationViewModel {
    struct AuthModel {
        var countryCode = "250"
        var phone = ""
        
        var email = ""
                
        func formattedPhone() -> String {
            return "+\(countryCode) \(phone)"
        }
        
        func isValid() -> Bool {
            let isCountryValid = countryCode.trimmingCharacters(in: .whitespaces).count == 3
            let isPhoneValid = phone.trimmingCharacters(in: .whitespaces).count >= 5
            return isCountryValid && isPhoneValid
        }
    }
    
    struct RegisterModel {
        var firstName = ""
        var lastName = ""
        var type = AucaUserType.student
        var email = ""
        var about = ""
        
        func isValid() -> Bool {
            guard firstName.replacingOccurrences(of: " ", with: "").count > 3 else { return false }
            guard lastName.replacingOccurrences(of: " ", with: "").count > 3 else { return false }
            guard email.isValidEmail() else { return false }
            return true
        }
    }
}
