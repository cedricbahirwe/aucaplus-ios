//
//  AppTabView.swift
//  AucaPlus
//
//  Created by Cédric Bahirwe on 02/04/2023.
//

import SwiftUI

struct AppTabView: View {
    var body: some View {
        TabView {
            HomeView()
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
            
            Settings()
                .tabItem {
                    Label("Settings", systemImage: "gear")
                }
        }
    }
}

struct AppTabView_Previews: PreviewProvider {
    static var previews: some View {
        AppTabView()
    }
}
