//
//  PlaceHolderView.swift
//  AucaPlus
//
//  Created by Cédric Bahirwe on 16/01/2024.
//

import SwiftUI

struct PlaceHolderView: View {
    var body: some View {
        VStack {
            Image("app.logo.transparent")
                .renderingMode(.template)
                .resizable()
                .scaledToFit()
                .frame(width: 100)
                .foregroundColor(.white)
        }
        .frame(maxWidth: .infinity)
        .frame(height: 280)
        .background(Color.init(red: 206/255, green: 206/255, blue: 206/255))
    }
    
    static var Auca: some View {
        Image("auca.logo")
            .resizable()
    }
}

#Preview {
    PlaceHolderView()
}
