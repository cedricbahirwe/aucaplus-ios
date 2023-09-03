//
//  AccountSettingsView.swift
//  AucaPlus
//
//  Created by Cédric Bahirwe on 20/08/2023.
//

import SwiftUI

struct AccountSettingsView: View {
    
    @AppStorage(StorageKeys.isLoggedIn)
    private var isLoggedIn: Bool = false
    
    @State private var isSigningOut: Bool = false
    
    @ObservedObject var settingsStore: SettingsStore
    
    var body: some View {
        ZStack {
            Form {
                Section {
                    
                    Group {
                        HStack {
                            TextField("Enter your phone", text: $settingsStore.currentUser.phoneNumber)
                                .textContentType(.telephoneNumber)
                                .textInputAutocapitalization(.none)
                            
                            
                            if !settingsStore.currentUser.phoneNumber.isEmpty {
                                Image(systemName: "xmark.circle.fill")
                                    .foregroundStyle(Color(.white), .gray)
                                    .onTapGesture {
                                        settingsStore.currentUser.phoneNumber = ""
                                    }
                            }
                        }
                        
                        HStack {
                            TextField("Enter your email", text: $settingsStore.currentUser.email)
                                .textContentType(.emailAddress)
                                .textInputAutocapitalization(.none)
                            
                          
                            
                            if !settingsStore.currentUser.email.isEmpty {
                                Image(systemName: "xmark.circle.fill")
                                    .foregroundStyle(Color(.white), .gray)
                                    .onTapGesture {
                                        settingsStore.currentUser.email = ""
                                    }
                            }
                        }
                    }
                    .padding(10)
                    .background(.thickMaterial)
                    .cornerRadius(12)
                    
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
                    Task {
                        isSigningOut = true
                        try await AuthClient.shared.signOut()
                        isSigningOut = false
                        StorageKeys.clearAll()
                        isLoggedIn = false
                    }
                } label: {
                    Text("Sign out")
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
            .safeAreaInset(edge: .bottom) {
                VStack {
                    Button {
                        Task {
    //                        await AuthClient.shared.deleteAccount()
                            StorageKeys.clearAll()
                        }
                    } label: {
                        Text("Delete account")
                            .bold()
                            .frame(maxWidth: .infinity)
                            .frame(height: 48)
                            .foregroundColor(.red)
                    }
                }
                .background(.regularMaterial)
            }
            .toolbar {
                if settingsStore.shouldUpdate {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button("Update") {}
                            .bold()
                    }
                }
            }
            
            if isSigningOut {
                SpinnerView()
            }
        }
        .navigationTitle("Account settings")
        .navigationBarTitleDisplayMode(.inline)
    }
    
}


struct AccountSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            AccountSettingsView(settingsStore: SettingsStore())
        }
    }
}
