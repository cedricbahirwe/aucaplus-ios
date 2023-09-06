//
//  AppTabView.swift
//  AucaPlus
//
//  Created by Cédric Bahirwe on 02/04/2023.
//

import SwiftUI

struct AppTabView: View {
    @AppStorage(StorageKeys.appSelectedTab)
    private var selection: AppTab = .home
    
    @StateObject private var bookmarksVM = BookmarkViewModel()
    @StateObject private var linksVM = LinksPreviewModel()
    
    var body: some View {
        TabView(selection: $selection) {
            FeedView()
                .tabItem {
                    Label("Feed", systemImage: "house")
                }
                .tag(AppTab.home)
            
            InternshipsView()
                .tabItem {
                    Label("Internships", systemImage: "graduationcap")
                }
                .tag(AppTab.jobs)
            
            SettingsView()
                .tabItem {
                    Label("Settings", systemImage: "gear")
                }
                .tag(AppTab.settings)
        }
        .environmentObject(bookmarksVM)
        .environmentObject(linksVM)
    }
}

struct AppTabView_Previews: PreviewProvider {
    static var previews: some View {
        AppTabView()
    }
}

fileprivate enum AppTab: String {
    case home, jobs, settings
}
