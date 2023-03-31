//
//  AuthenticationView.swift
//  AucaPlus
//
//  Created by Cédric Bahirwe on 31/03/2023.
//

import SwiftUI

struct AuthenticationView: View {
    @State private var authModel = AuthModel(countryCode: "250", phone: "")
    @State private var showingAlert = false
    
    var body: some View {
        VStack {
            titleView
            VStack(spacing: 20) {
                
                Text("AUCA+ will need to verify your phone number.")
                    .multilineTextAlignment(.center)
                
                HStack {
                    HStack {
                        Text("+")
                        
                        TextField("250", text: $authModel.countryCode)
                            .frame(width: 40)
                            .keyboardType(.numberPad)
                            
                    }
                    .padding(.bottom, 5)
                    .overlay(alignment: .bottom) {
                        Color.red.frame(height: 1)
                    }
                    
                    TextField("phone number", text: $authModel.phone)
                        .keyboardType(.numberPad)
                        .textContentType(.telephoneNumber)
                        .padding(.bottom, 5)
                        .overlay(alignment: .bottom) {
                            Color.red.frame(height: 1)
                        }
                }
                .padding(.horizontal, 40)
                Text("Carrier charges may apply")
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            Button {
                guard authModel.isValid() else { return }
                showingAlert.toggle()
            } label: {
                Text("Next")
                    .bold()
                    .padding(.horizontal)
                    .padding(.vertical, 8)
            }
            .buttonStyle(.borderedProminent)
            .buttonBorderShape(.capsule)

        }
        .padding(25)
        .alert("You entered the phone number:", isPresented: $showingAlert, actions: {
            Button("Edit") { }
            Button("OK") {
                // Move one next screen
            }
        }, message: {
            Text("**\(authModel.formattedPhone())** \n Is this OK, or would you like to edit the number?")
        })
    }
    
    struct AuthModel {
        var countryCode: String
        var phone: String
        
        func formattedPhone() -> String {
            return "+\(countryCode) \(phone)"
        }
        
        func isValid() -> Bool {
            let isCountryValid = countryCode.trimmingCharacters(in: .whitespaces).count == 3
            let isPhoneValid = phone.trimmingCharacters(in: .whitespaces).count >= 5
            return isCountryValid && isPhoneValid
        }
    }
}

extension AuthenticationView {
    var titleView: some View {
        Text("Enter your phone number")
            .frame(maxWidth: .infinity)
            .overlay(alignment: .trailing) {
                Image(systemName: "questionmark.circle")
                    .contentShape(Rectangle())
            }
            .font(.title2)
            .fontWeight(.bold)
            .foregroundColor(.accentColor)
            .padding(.vertical)
    }
}
struct AuthenticationView_Previews: PreviewProvider {
    static var previews: some View {
        AuthenticationView()
    }
}
