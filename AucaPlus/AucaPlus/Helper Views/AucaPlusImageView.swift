//
//  AucaPlusImageView.swift
//  AucaPlus
//
//  Created by Cédric Bahirwe on 26/08/2023.
//

import SwiftUI

struct AucaPlusImageView: View {
    private let imageURL: URL
    private let placeholderImage: Image
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
    
    init(_ imageURL: URL, placeholderImage: Image = Image("auca.logo"), _ layout: AucaPlusImageLayout = .flexible) {
        self.imageURL = imageURL
        self.layout = layout
        self.placeholderImage = placeholderImage
    }
    var body: some View {
        AsyncImage(url: imageURL,
                   scale: 1) {
            // Cache Image here if not cached
            $0.resizable()
        } placeholder: {
            placeholderImage
                .resizable()
        }
        .frame(width: layout.dimensions?.width, height: layout.dimensions?.height)
        
    }
}

struct AucaPlusImageView_Previews: PreviewProvider {
    static var previews: some View {
        AucaPlusImageView(URL(string: "www.google.com")!)
    }
}
