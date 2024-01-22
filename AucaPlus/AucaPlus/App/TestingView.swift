//
//  TestingView.swift
//  AucaPlus
//
//  Created by Cédric Bahirwe on 23/08/2023.
//

import SwiftUI

struct TestingView: View {
    
    var body: some View {
        VStack {
            Image("app.logo.transparent")
                .renderingMode(.template)
                .resizable()
                .scaledToFit()
                .frame(width: 100)
                .foregroundColor(.white)
        }
        .frame(width: 390, height: 280)
        .background(Color.init(red: 206/255, green: 206/255, blue: 206/255))
    }
}

struct TestingView_Previews: PreviewProvider {
    static var previews: some View {
        TestingView()
    }
}
