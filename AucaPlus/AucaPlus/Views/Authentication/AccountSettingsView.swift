//
//  AccountSettingsView.swift
//  AucaPlus
//
//  Created by Cédric Bahirwe on 20/08/2023.
//

import SwiftUI

struct AccountSettingsView: View {
    @State private var email = "qj897jjr5c@privaterelay.appleid.com"
    
    @AppStorage(StorageKeys.isLoggedIn)
    private var isLoggedIn: Bool = false
    @StateObject private var settingsStore = SettingsStore()
    
    var body: some View {
        
        Form {
            Section {
                
                Group {
                    HStack {
                        TextField("Enter your email", text: $email)
                            .textContentType(.emailAddress)
                            .textInputAutocapitalization(.none)
                        
                        if !email.isEmpty {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundStyle(Color(.white), .gray)
                                .onTapGesture {
                                    email = ""
                                }
                        }
                    }
                    .padding(10)
                    .background(.thickMaterial)
                    .cornerRadius(12)
                   
                }
                
                HStack {
                    Text("Auca Plus ID")
                    Spacer()
                    Text("#AC1200")
                        .opacity(0.8)
                }
             
            } header: {
                SectionHeaderText("Your data")
            }
          
            Button {
                StorageKeys.clearAll()
                isLoggedIn = false
            } label: {
                Text("Log out")
                    .bold()
                    .frame(maxWidth: .infinity)
                    .frame(height: 48)
                    .background(.red.opacity(0.15))
                    .cornerRadius(15)
                    .foregroundColor(.red)
            }
            .listRowInsets(EdgeInsets.init(top: 0, leading: 0, bottom: 0, trailing: 0))
            .listRowBackground(Color.clear)
        }
        .navigationTitle("Account settings")
        .navigationBarTitleDisplayMode(.inline)
        .safeAreaInset(edge: .bottom) {
            Button {
                StorageKeys.clearAll()
                isLoggedIn = false
            } label: {
                Text("Delete account")
                    .bold()
                    .frame(maxWidth: .infinity)
                    .frame(height: 48)
                    .foregroundColor(.red)
            }
        }
    }
    
}


struct AccountSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        AccountSettingsView()
    }
}
