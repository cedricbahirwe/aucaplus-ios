//
//  SettingsView.swift
//  AucaPlus
//
//  Created by Cédric Bahirwe on 02/04/2023.
//

import SwiftUI

struct SettingsView: View {
    @AppStorage(StorageKeys.isLoggedIn)
    private var isLoggedIn: Bool = false
    @StateObject private var settingsStore = SettingsStore()
    
    var body: some View {
        NavigationStack {
            Form {
                
                Section {
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
                                
                                if let headline = user.about {
                                    Text(headline)
                                        .font(.callout)
                                        .foregroundColor(.secondary)
                                }
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        
                        NavigationLink {
                            AccountSettingsView()
                        } label: {
                            FormLabel(.account)
                        }
                    }
                } header: {
                    SectionHeaderText("Account")
                }
                
                Section {
                    
                    Group {
                        FormLabel(.posting)
                            .asLink(ExternalLinks.opportunityPostingURL)

                        FormLabel(.whatsapp)
                            .asLink(ExternalLinks.whatsAppDMLink)
                    }
                    
                    NavigationLink {
                        BookmarksView()
                    } label: {
                        FormLabel(.bookmarks)
                    }
                } header: {
                    SectionHeaderText("Info")
                }
                
                Section {
                    NavigationLink {
                        AboutView()
                    } label: {
                        FormLabel(.about)
                    }

                    FormLabel(.rating, type: .external)
                        .asLink(ExternalLinks.appStoreReview)
                    
                    
                    NavigationLink {
                        BookmarksView()
                    } label: {
                        FormLabel(.appearance)
                    }
                    
                } header: {
                    SectionHeaderText("Application")
                }
                
                VersionLabel()
                
            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

extension SettingsView {
    struct VersionLabel: View {
        var body: some View {
            Text(AppMetaData.fullVersion)
                .foregroundColor(.secondary)
                .font(.caption)
                .padding()
                .listRowInsets(EdgeInsets.init(top: 0, leading: 0, bottom: 0, trailing: 0))
                .listRowBackground(Color.clear)
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
