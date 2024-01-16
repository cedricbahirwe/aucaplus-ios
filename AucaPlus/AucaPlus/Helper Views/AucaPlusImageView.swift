//
//  AucaPlusImageView.swift
//  AucaPlus
//
//  Created by Cédric Bahirwe on 26/08/2023.
//

import SwiftUI

struct AucaPlusImageView<Content: View>: View {
    private let imageURL: URL
    private let placeholderView: () -> Content
    private let layout: AucaPlusImageLayout
    
    enum AucaPlusImageLayout {
        case square(CGFloat)
        case rectangle(width: CGFloat, height: CGFloat)
        case flexible
        
        var dimensions: CGSize? {
            switch self {
            case .square(let side):
                return CGSize(width: side, height: side)
            case .rectangle(let width, let height):
                return CGSize(width: width, height: height)
            case .flexible:
                return nil
            }
        }
    }
    
    init(
        _ imageURL: URL,
        @ViewBuilder placeholder: @escaping () -> Content = {
            Image("auca.logo")
                .resizable()
        },
        _ layout: AucaPlusImageLayout = .flexible
    ) {
        self.imageURL = imageURL
        self.layout = layout
        self.placeholderView = placeholder
    }
    var body: some View {
        AsyncImage(url: imageURL,
                   scale: 1) {
            $0.resizable()
        } placeholder: {
            placeholderView()
        }
        .frame(width: layout.dimensions?.width, height: layout.dimensions?.height)
        
    }
}

struct AucaPlusImageView_Previews: PreviewProvider {
    static var previews: some View {
        AucaPlusImageView(URL(string: "www.google.com")!)
    }
}
