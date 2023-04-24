//
//  AuthenticationView.swift
//  AucaPlus
//
//  Created by Cédric Bahirwe on 31/03/2023.
//

import SwiftUI

struct AuthenticationView: View {
    @ObservedObject var authVM: AuthenticationViewModel
    
    enum FocusedField {
        case countryCode, phone
        case email, password
    }
    @State private var showingConfirmationAlert = false
    @State private var showingValidationAlert = false
    @State private var goToOTPView = false
    @FocusState private var focusedField: FocusedField?
    
    @AppStorage("isLoggedIn")
    private var isLoggedIn: Bool = false
    
    private var alertMessage: String {
        authVM.authModel.signingUpWithEmail ?
        "Please check your email and/or password." :
        "Please enter your phone number."
    }
    
    var body: some View {
        VStack {
            TitleView(title: "Enter your phone number")
            
            VStack(spacing: 20) {
                
                Text("AUCA+ will need to verify your phone number.")
                    .multilineTextAlignment(.center)
                    .fixedSize()

                if authVM.authModel.signingUpWithEmail {
                    VStack(spacing: 50) {
                        TextField(String("email@school.com"), text: $authVM.authModel.email)
                            .focused($focusedField, equals: .email)
                            .textInputAutocapitalization(.never)
                            .keyboardType(.emailAddress)
                            .textContentType(.emailAddress)
                            .padding(.bottom)
                            .overlay(alignment: .bottom) {
                                Color.accentColor.frame(height: 1)
                            }
                        
                        SecureField("password", text: $authVM.authModel.password)
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
                            
                            TextField("250", text: $authVM.authModel.countryCode)
                                .focused($focusedField, equals: .countryCode)
                                .frame(width: 40)
                                .keyboardType(.numberPad)
                        }
                        .padding(.bottom, 5)
                        .overlay(alignment: .bottom) {
                            Color.accentColor.frame(height: 1)
                        }
                        
                        TextField("phone number", text: $authVM.authModel.phone)
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
                        authVM.authModel.signingUpWithEmail.toggle()
                    }
                } label: {
                    Text("Use \(authVM.authModel.signingUpWithEmail ? "phone number" : "email") instead")
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
                    if authVM.authModel.isValid() {
                        if authVM.authModel.signingUpWithEmail {
                            isLoggedIn = true
                        } else {
                            showingConfirmationAlert.toggle()
                        }
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
            Text("**\(authVM.authModel.formattedPhone())** \n Is this OK, or would you like to edit the number?")
        })
        .navigationDestination(isPresented: $goToOTPView) {
            OTPVerificationView(authVM: authVM)
        }
        .toolbar {
            ToolbarItem(placement: .keyboard) {
                Button("OK") {
                    focusedField = nil
                }
            }
        }
    }
}

extension AuthenticationView {
    struct TitleView: View {
        let title: String
        init(title: String) {
            self.title = title
        }
        var body: some View {
            Text(title)
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
    }
    
    struct AuthHelpView: View {
        var body: some View  {
            Text("Auth Help")
        }
    }
}

#if DEBUG
struct AuthenticationView_Previews: PreviewProvider {
    static var previews: some View {
        AuthenticationView(authVM: AuthenticationViewModel())
    }
}
#endif
