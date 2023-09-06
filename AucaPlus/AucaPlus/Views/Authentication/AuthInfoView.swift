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
        case userName
        case email, about
    }
    
    @State private var showingValidationAlert = false
    @FocusState private var focusedField: FocusedField?
        
    var body: some View {
        ZStack {
            
            VStack(spacing: 0) {
                AuthenticationView.TitleView(title: "Almost there!")
                
                VStack(spacing: 20) {
                    Text("Fill in the form below to get in!")
                        .multilineTextAlignment(.center)
                        .fixedSize()
                        .padding(.vertical)
                    
                    HStack(spacing: 15) {
                        
                        ZFieldStack("First Name", text: $authVM.regModel.firstName)
                            .textContentType(.givenName)
                            .focused($focusedField, equals: .firstName)
                        
                        ZFieldStack("Last Name", text: $authVM.regModel.lastName)
                            .textContentType(.familyName)
                            .focused($focusedField, equals: .lastName)
                    }
                    .submitLabel(.next)
                    
                    ZFieldStack("Username", text: $authVM.regModel.username)
                        .focused($focusedField, equals: .userName)
                    
                    ZFieldStack("Email(Optional)", text: $authVM.regModel.email)
                        .textContentType(.emailAddress)
                        .keyboardType(.emailAddress)
                        .textInputAutocapitalization(.never)
                        .focused($focusedField, equals: .email)
                        .submitLabel(.next)
                    
                    ZFieldStack("Intro(Optional)",
                                axis: .vertical(maxHeight: 80, lines: 5),
                                text: $authVM.regModel.about)
                    .focused($focusedField, equals: .about)
                    .submitLabel(.next)
                    
                    VStack(alignment: .leading, spacing: 0) {
                        HStack {
                            Text("Choose Account Type:")
                            Spacer()
                            Picker("",
                                   selection: $authVM.regModel.type) {
                                ForEach(AucaUserType.allCases, id: \.self) { type in
                                    Text(type.rawValue.capitalized)
                                }
                            }
                                   .pickerStyle(.menu)
                                   .background(.regularMaterial)
                                   .cornerRadius(5)
                            
                        }
                        Text(authVM.regModel.type.description)
                            .font(.caption)
                            .fontDesign(.rounded)
                            .foregroundColor(.secondary)
                    }
                }
                .onSubmit(handleSubmission)
                
                VStack {
                    Spacer()
                    
                    Button {
                        guard fieldsValid() else { return }
                        Task {
                            await authVM.saveUserInfo()
                        }
                    } label: {
                        Text("Finish")
                            .bold()
                            .padding(.horizontal)
                            .padding(.vertical, 8)
                    }
                    .buttonStyle(.borderedProminent)
                    .buttonBorderShape(.capsule)
                }
            }
            .padding(.horizontal, 25)
            
            if authVM.isSavingUserInfo {
                SpinnerView()
            }
        }
        .toolbar(.hidden)
        .background(
            Color(.systemBackground)
                .onTapGesture {
                    focusedField = nil
                }
        )
        .alert("Validation Error",
               isPresented: $showingValidationAlert,
               presenting: authVM.alertItem, actions: { item in
            Button("Got It!") {
                
            }
        }, message: { item in
            Text(item.message)
        })
        .onAppear() {
            DispatchQueue.main.asyncAfter(deadline: OnboardingConstants.authFieldFocusTime) {
                focusedField = .firstName
            }
        }
        .toolbar {
            ToolbarItem(placement: .keyboard) {
                Button("OK") {
                    focusedField = nil
                }
            }
        }
    }
    
    private func fieldsValid() -> Bool {
        do {
            return try authVM.regModel.isValid()
        } catch {
            self.authVM.alertItem = AlertItem(message: error.localizedDescription)
            self.showingValidationAlert = true
            return false
        }
    }
}

private extension AuthInfoView {
    func handleSubmission() {
        switch focusedField {
        case .firstName:
            focusedField = .lastName
        case .lastName:
            focusedField = .userName
        case .userName:
            focusedField = .email
        case .email:
            focusedField = .about
        case .about:
            focusedField = nil
        case .none: break;
        }
    }
}

#if DEBUG
struct AuthInfoView_Previews: PreviewProvider {
    static var previews: some View {
        AuthInfoView(authVM: AuthenticationViewModel())
    }
}
#endif
