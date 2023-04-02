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
    
    var body: some View {
        Button("Log Out", role: .destructive) {
            isLoggedIn = false
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
