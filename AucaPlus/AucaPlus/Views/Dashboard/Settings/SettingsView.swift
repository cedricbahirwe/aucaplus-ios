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
                        HStack(alignment: .center, spacing: 8) {
                            AsyncImage(url: user.picture) { image in
                                image
                                    .resizable()
                            } placeholder: {
                                Color.secondary
                            }
                            .frame(width: 65, height: 65)
                            .clipShape(Circle())
                            
                            VStack(alignment: .leading) {
                                Text(user.completeName())
                                    .font(.title2)
                                
                                if let headline = user.about {
                                    Text(headline)
                                        .font(.callout)
                                        .foregroundColor(.secondary)
                                }
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .redacted(reason: user == .example1 ? .placeholder : .init())
                        .animation(.easeInOut, value: user == .example1)
                        
                        NavigationLink {
                            AccountSettingsView(settingsStore: settingsStore)
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
                        .inBeta()
                    
                    NavigationLink {
                        BookmarksView()
                    } label: {
                        FormLabel(.appearance)
                    }
                    .inBeta()
                    
                } header: {
                    SectionHeaderText("Application")
                }
                
                VersionLabel()
    
            }
            .task {
                await settingsStore.getUser()
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
                .frame(maxWidth: .infinity)
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

extension View {
    func inBeta() -> some View {
       ModifiedContent(content: self, modifier: BetaModifier())
    }
}

struct BetaModifier: ViewModifier {
    @State private var animate = false
    func body(content: Content) -> some View {
        HStack {
            content
                .disabled(true)
            Text(animate ? "Work In Progess" : "WIP ⚙️")
                .font(.caption)
                .foregroundColor(.green)
                .padding(8)
                .background(Color.green.opacity(0.1))
                .clipShape(Capsule())
                .onTapGesture {
                    withAnimation {
                        animate = true
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now()+1.5) {
                        withAnimation {
                            animate = false
                        }
                    }
                }
        }
    }
}
