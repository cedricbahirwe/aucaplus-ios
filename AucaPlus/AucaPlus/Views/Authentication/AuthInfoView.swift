//
//  AuthInfoView.swift
//  AucaPlus
//
//  Created by Cédric Bahirwe on 30/04/2023.
//

import SwiftUI

struct AuthInfoView: View {
    @ObservedObject var authVM: AuthenticationViewModel
    
    enum FocusedField {
        case firstName, lastName
        case email, type
    }
    @State private var showingConfirmationAlert = false
    @State private var showingValidationAlert = false
    @State private var goToOTPView = false
    @FocusState private var focusedField: FocusedField?
    @State private var userModel = UIModel()
    
    @AppStorage("isLoggedIn")
    private var isLoggedIn: Bool = false
    
    var body: some View {
        VStack {
            AuthenticationView.TitleView(title: "Almost there!")
            
            VStack(spacing: 20) {
                Text("Fill in the form below to get in!.")
                    .multilineTextAlignment(.center)
                    .fixedSize()
                    .padding(.vertical)
                
                HStack(spacing: 15) {
                    
                    ZFieldStack("First Name", text: $userModel.firstName)
                        .textContentType(.givenName)
                        .focused($focusedField, equals: .firstName)
                        .submitLabel(.next)
                    
                    ZFieldStack("Last Name", text: $userModel.lastName)
                        .textContentType(.familyName)
                        .focused($focusedField, equals: .lastName)
                        .submitLabel(.next)
                }
                
                ZFieldStack("Email(Optional)", text: $userModel.email)
                    .textContentType(.emailAddress)
                    .keyboardType(.emailAddress)
                    .focused($focusedField, equals: .email)
                    .submitLabel(.next)
                
            }
            .onSubmit(handleSubmission)
            
            VStack {
                Spacer()
                
                Button {
                    isLoggedIn = true
                } label: {
                    Text("Finish")
                        .bold()
                        .padding(.horizontal)
                        .padding(.vertical, 8)
                }
                .buttonStyle(.borderedProminent)
                .buttonBorderShape(.capsule)
                .alert("Please enter your phone number.",
                       isPresented: $showingValidationAlert,
                       actions: { })
                
            }
        }
        .padding(.horizontal, 25)
        .toolbar(.hidden)
        .background(
            Color(.systemBackground)
                .onTapGesture {
                    focusedField = nil
                }
        )
        .alert("You entered the phone number:",
               isPresented: $showingConfirmationAlert,
               actions: {
            Button("Edit") { }
            Button("OK") {
                goToOTPView.toggle()
            }
        }, message: {
            Text("**\(authVM.authModel.formattedPhone())** \n Is this OK, or would you like to edit the number?")
        })
        .toolbar {
            ToolbarItem(placement: .keyboard) {
                Button("OK") {
                    focusedField = nil
                }
            }
        }
    }
}

private extension AuthInfoView {
    func handleSubmission() {
        switch focusedField {
        case .firstName:
            focusedField = .lastName
        case .lastName:
            focusedField = .email
         default:
            focusedField = nil
        }
    }
    
    private func handlePhoneChange(_ newValue: String) {
        authVM.authModel.phone = String.formattedCDIPhoneNumber(from: newValue)
    }
    
    struct UIModel {
        var firstName = ""
        var lastName = ""
        var email = ""
    }
}

#if DEBUG
struct AuthInfoView_Previews: PreviewProvider {
    static var previews: some View {
        AuthInfoView(authVM: AuthenticationViewModel())
    }
}
#endif

struct ZFieldStack: View {
    private let title: LocalizedStringKey
    private let placeholder: LocalizedStringKey
    @Binding var text: String
    
    init(_ title: LocalizedStringKey,
         _ placeholder: LocalizedStringKey = "",
         text: Binding<String>) {
        
        self.title = title
        self.placeholder = placeholder
        self._text = text
    }
    
    var body: some View {
        VStack {
            TextField("", text: $text)
                .padding(10)
                .frame(height: 45)
                .overlay(content: {
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.secondary, lineWidth: 1)
                })
                .overlay(alignment: .topLeading) {
                    Text(title)
                        .font(.caption)
                        .lineLimit(1)
                        .foregroundColor(.secondary)
                        .padding(.horizontal, 8)
                        .background(.background)
                        .offset(x: 0, y: -10)
                }
        }
    }
}
