//
//  CaughtUpView.swift
//  AucaPlus
//
//  Created by Cédric Bahirwe on 17/08/2023.
//

import SwiftUI

struct CaughtUpView: View {
    let title: String
    let subtitle: String
    
    init(_ title: String, _ subtitle: String) {
        self.title = title
        self.subtitle = subtitle
    }
    
    var body: some View {
        VStack(spacing: 5) {
            Text(title)
                .font(.callout)
            Text(subtitle)
                .foregroundColor(.secondary)
                .font(.caption)
        }
    }
}

struct CaughtUpView_Previews: PreviewProvider {
    static var previews: some View {
        CaughtUpView(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/, /*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}
