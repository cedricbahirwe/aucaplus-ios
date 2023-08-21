//
//  AboutView.swift
//  AucaPlus
//
//  Created by Cédric Bahirwe on 20/08/2023.
//

import SwiftUI

struct AboutView: View {
    var body: some View {
        Form {
            VStack {
                Image("auca.logo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 80)
                
                Text("Auca Plus")
                    .font(.system(.title3, design: .rounded).weight(.bold))
                
                Text("Some good introduction can go here!")
                
            }
            .frame(maxWidth: .infinity)

            Section(header: SectionHeaderText("Social media")) {
                FormLabel(.twitter).asLink(ExternalLinks.appTwitter)
                FormLabel(.website).asLink(ExternalLinks.appWebsite)
            }
            
            Section(header: SectionHeaderText("Legal")) {
                FormLabel(.tos).asLink(ExternalLinks.tos)
                FormLabel(.privacy).asLink(ExternalLinks.privacy)
            }
            
            SettingsView.VersionLabel()
        }
        .navigationBarTitle("About Auca Plus")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct AboutView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            AboutView()
        }
    }
}
