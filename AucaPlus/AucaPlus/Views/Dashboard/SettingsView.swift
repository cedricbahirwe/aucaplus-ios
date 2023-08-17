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
                            BookmarksView()
                        } label: {
                            Label {
                                Text("Acccount Settings")
                            } icon: {
                                Image(systemName: "person.fill")
                                    .resizable()
                                    .scaledToFit()
                                    .padding(5)
                                    .background(Color.green.opacity(0.8))
                                    .foregroundColor(.white)
                                    .cornerRadius(8)
                            }
                        }
                    }
                } header: {
                    sectionHeader("Account")
                }
                
                Section {
                    NavigationLink {
                        BookmarksView()
                    } label: {
                        Label {
                            Text("About AucaPlus")
                        } icon: {
                            Image(systemName: "info.circle")
                                .resizable()
                                .scaledToFit()
                                .padding(5)
                                .background(Color.orange)
                                .foregroundColor(.white)
                                .cornerRadius(8)
                        }
                    }
                    .foregroundColor(.primary)
                    
                    HStack {
                        Label {
                            Text("Rate this App")
                        } icon: {
                            Image(systemName: "info.circle")
                                .resizable()
                                .scaledToFit()
                                .padding(5)
                                .background(Color.yellow)
                                .foregroundColor(.white)
                                .cornerRadius(8)
                        }
                        Spacer()
                        
                        Image(systemName: "arrow.up.forward")
                            .foregroundColor(.secondary)
                            .imageScale(.small)
                    }
                    
                    NavigationLink {
                        BookmarksView()
                    } label: {
                        Label {
                            Text("Bookmarks")
                        } icon: {
                            Image(systemName: "bookmark.fill")
                                .resizable()
                                .scaledToFit()
                                .padding(5)
                                .frame(width: 28, height: 28)
                                .background(Color.indigo)
                                .foregroundColor(.white)
                                .cornerRadius(8)
                        }
                    }
                    .foregroundColor(.primary)
                } header: {
                    sectionHeader("Info")
                }
                
                Section {
                    NavigationLink {
                        BookmarksView()
                    } label: {
                        Label {
                            Text("Appearance")
                        } icon: {
                            Image(systemName: "moon.stars.fill")
                                .resizable()
                                .scaledToFit()
                                .padding(5)
                                .background(Color.accentColor)
                                .foregroundColor(.white)
                                .cornerRadius(8)
                        }
                    }
                   
                } header: {
                    sectionHeader("Application")
                }
                
                VStack {
                    Button {
                        StorageKeys.clearAll()
                        isLoggedIn = false
                    } label: {
                        Text("Log out")
                            .bold()
                            .frame(maxWidth: .infinity)
                            .frame(height: 45)
                            .background(.red.opacity(0.15))
                            .cornerRadius(15)
                            .foregroundColor(.red)
                    }
                    
                    Text("1.1.0 (100)")
                        .foregroundColor(.secondary)
                        .font(.caption)
                        .padding()
                }
                .listRowInsets(EdgeInsets.init(top: 0, leading: 0, bottom: 0, trailing: 0))
                .listRowBackground(Color.clear)
            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
    
    func sectionHeader(_ title: String) -> some View {
        Text(title)
            .fontWeight(.semibold)
            .textCase(nil)
    }
}

#if DEBUG
struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
#endif
