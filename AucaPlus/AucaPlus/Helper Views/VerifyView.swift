//
//  VerifyView.swift
//  AucaPlus
//
//  Created by Cédric Bahirwe on 26/08/2023.
//

import SwiftUI

struct VerifyView: View {
    private let size: CGFloat
    private let color: Color
    init(_ size: CGFloat = 20, color: Color = Color.accentColor) {
        self.size = size
        self.color = color
    }
    var body: some View {
        Image(systemName: "seal.fill")
            .resizable()
            .scaledToFit()
            .frame(width: size, height: size)
            .foregroundColor(color)
            .overlay {
                Image("app.logo.transparent")
                    .resizable()
                    .scaledToFit()
            }
    }
}

struct VerifyView_Previews: PreviewProvider {
    static var previews: some View {
        VerifyView()
    }
}
