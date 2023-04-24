//
//  SettingsView.swift
//  AucaPlus
//
//  Created by Cédric Bahirwe on 02/04/2023.
//

import SwiftUI

struct SettingsView: View {
    @AppStorage("isLoggedIn")
    private var isLoggedIn: Bool = false
    @StateObject private var settingsStore = SettingsStore()
    
    var body: some View {
        NavigationStack {
            Form {
                VStack {
                    if let user = settingsStore.currentUser {
                        HStack(spacing: 8) {
                            AsyncImage(url: user.picture) { image in
                                image
                                    .resizable()
                            } placeholder: {
                                Color.secondary
                            }
                            .frame(width: 60, height: 60)
                            .clipShape(Circle())
                            
                            VStackLayout(alignment: .leading) {
                                Text(user.completeName())
                                    .font(.title2)
                                
                                Text(user.about)
                                    .font(.callout)
                                    .foregroundColor(.secondary)
                                
                              
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                    }
                }
                
                Section {
                    Button("Log Out", role: .destructive) {
                        isLoggedIn = false
                    }
                }
            }
            .navigationTitle("Settings")
        }
    }
}

#if DEBUG
struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
#endif