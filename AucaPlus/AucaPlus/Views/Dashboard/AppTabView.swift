//
//  AppTabView.swift
//  AucaPlus
//
//  Created by Cédric Bahirwe on 02/04/2023.
//

import SwiftUI

struct AppTabView: View {
    @AppStorage("appSelectedTab")
    private var selection: AppTab = .home
    
    var body: some View {
        TabView(selection: $selection) {
            FeedView()
                .tabItem {
                    Label("Feed", systemImage: "house")
                }
            
            ChatsView()
                .tabItem {
                    Label("Chats", systemImage: "bubble.left.and.bubble.right")
                        .symbolVariant(SwiftUI.SymbolVariants.square)
                }
            
            JobsView()
                .tabItem {
                    Label("Opportunities", systemImage: "bag.circle")
                }
            
            SettingsView()
                .tabItem {
                    Label("Settings", systemImage: "gear")
                }
        }
    }
    
    enum AppTab: String {
        case home, chat, job, settings
    }
}

struct AppTabView_Previews: PreviewProvider {
    static var previews: some View {
        AppTabView()
    }
}
