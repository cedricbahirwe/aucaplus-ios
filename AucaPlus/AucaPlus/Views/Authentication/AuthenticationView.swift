//
//  AuthenticationView.swift
//  AucaPlus
//
//  Created by Cédric Bahirwe on 31/03/2023.
//

import SwiftUI

struct AuthenticationView: View {
    enum FocusedField {
        case countryCode, phone
        case email, password
    }
    @State private var authModel = AuthModel()
    @State private var showingConfirmationAlert = false
    @State private var showingValidationAlert = false
    @State private var goToOTPView = false
    @FocusState private var focusedField: FocusedField?
    
    var alertMessage: String {
        authModel.signingUpWithEmail ?
        "Please check your email and/or password." :
        "Please enter your phone number."
    }
    
    var body: some View {
        VStack {
            titleView
            VStack(spacing: 20) {
                
                Text("AUCA+ will need to verify your phone number.")
                    .multilineTextAlignment(.center)
                    .fixedSize()

                if authModel.signingUpWithEmail {
                    VStack(spacing: 50) {
                        TextField("email", text: $authModel.email)
                            .focused($focusedField, equals: .email)
                            .keyboardType(.emailAddress)
                            .textContentType(.emailAddress)
g                            .textInputAutocapitalization(.none)
                            .padding(.bottom)
                            .overlay(alignment: .bottom) {
                                Color.accentColor.frame(height: 1)
                            }
                        
                        SecureField("password", text: $authModel.password)
                            .focused($focusedField, equals: .password)
                            .textContentType(.newPassword)
                            .padding(.bottom)
                            .overlay(alignment: .bottom) {
                                Color.accentColor.frame(height: 1)
                            }
                    }
                } else {
                    HStack {
                        HStack {
                            Text("+")
                            
                            TextField("250", text: $authModel.countryCode)
                                .focused($focusedField, equals: .countryCode)
                                .frame(width: 40)
                                .keyboardType(.numberPad)
                        }
                        .padding(.bottom, 5)
                        .overlay(alignment: .bottom) {
                            Color.accentColor.frame(height: 1)
                        }
                        
                        TextField("phone number", text: $authModel.phone)
                            .focused($focusedField, equals: .phone)
                            .keyboardType(.numberPad)
                            .textContentType(.telephoneNumber)
                            .padding(.bottom, 5)
                            .overlay(alignment: .bottom) {
                                Color.accentColor.frame(height: 1)
                            }
                    }
                    .padding(.horizontal, 40)
                    Text("Carrier charges may apply")
                        .foregroundColor(.secondary)
                }
                Button {
                    
                    withAnimation(.spring()) {
                        authModel.signingUpWithEmail.toggle()
                    }
                } label: {
                    Text("Use \(authModel.signingUpWithEmail ? "phone number" : "email") instead")
                        .underline()
                }
                
            }
            .onSubmit {
                switch focusedField {
                case .countryCode:
                    focusedField = .phone
                case .email:
                    focusedField = .password
                default:
                    focusedField = nil
                }
            }
            
            
            VStack {
                
                Spacer()
                
                Button {
                    if authModel.isValid() {
                        showingConfirmationAlert.toggle()
                    } else {
                        showingValidationAlert.toggle()
                    }
                } label: {
                    Text("Next")
                        .bold()
                        .padding(.horizontal)
                        .padding(.vertical, 8)
                }
                .buttonStyle(.borderedProminent)
                .buttonBorderShape(.capsule)
                .alert(alertMessage, isPresented: $showingValidationAlert, actions: { })
                
            }
        }
        .padding(25)
        .background(
            Color(.systemBackground)
                .onTapGesture {
                    focusedField = nil
                }
        )
        .alert("You entered the phone number:", isPresented: $showingConfirmationAlert, actions: {
            Button("Edit") { }
            Button("OK") {
                goToOTPView.toggle()
            }
        }, message: {
            Text("**\(authModel.formattedPhone())** \n Is this OK, or would you like to edit the number?")
        })
        .navigationDestination(isPresented: $goToOTPView) {
            OTPVerificationView(phoneNumber: authModel.formattedPhone())
        }
        .toolbar {
            ToolbarItem(placement: .keyboard) {
                Button("OK") {
                    focusedField = nil
                }
            }
        }
    }

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

extension AuthenticationView {
    var titleView: some View {
        Text("Enter your phone number")
            .frame(maxWidth: .infinity)
            .overlay(alignment: .trailing) {
                NavigationLink {
                    AuthHelpView()
                } label: {
                    Image(systemName: "questionmark.circle")
                        .contentShape(Rectangle())
                }
            }
            .font(.title2)
            .fontWeight(.bold)
            .foregroundColor(.accentColor)
            .padding(.vertical)
    }
    
    struct AuthHelpView: View {
        var body: some View  {
            Text("Auth Help")
        }
    }
}
struct AuthenticationView_Previews: PreviewProvider {
    static var previews: some View {
        AuthenticationView()
    }
}
