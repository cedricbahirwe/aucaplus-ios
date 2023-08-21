//
//  DotView.swift
//  AucaPlus
//
//  Created by Cédric Bahirwe on 17/08/2023.
//

import SwiftUI

struct DotView: View {
    var opacity: Double
    init(_ opacity: Double = 0.8) {
        self.opacity = opacity
    }
    var body: some View {
        Text("·")
            .scaleEffect(2)
            .opacity(opacity)
    }
}


struct DotView_Previews: PreviewProvider {
    static var previews: some View {
        DotView()
    }
}
