//
//  SpinnerView.swift
//  AucaPlus
//
//  Created by Cédric Bahirwe on 22/08/2023.
//

import SwiftUI

struct SpinnerConfiguration {
    var spinnerColor: Color = Color.accentColor
    var blurredBackground: Color = .black
    var spinnerBackgroundColor: Color = .clear
    var backgroundCornerRadius: CGFloat = 30
    var size: CGFloat = 85
}

struct SpinnerView: View {
    var configuration: SpinnerConfiguration = SpinnerConfiguration()
    @State private var isAnimating = false
    
    var body: some View {
        
        ZStack {
            Color.clear.ignoresSafeArea()
                .background(Material.ultraThinMaterial)
//                    configuration.blurredBackground.opacity(0.8)
//                      .ignoresSafeArea()
//                      .blur(radius: 300)
//            
            ZStack {
                configuration.spinnerBackgroundColor
                    .background(Material.ultraThickMaterial)
                
                ProgressView()
                    .progressViewStyle(.circular)
                    .tint(configuration.spinnerColor)
                    .controlSize(.large)
            }
            .frame(width: configuration.size, height: configuration.size)
            .background(Color.white)
            .cornerRadius(configuration.backgroundCornerRadius)
            .shadow(color: Color.white.opacity(0.3), radius: 5, x: 0, y: 5)
            .shadow(color: Color.black.opacity(0.2), radius: 2, x: 0, y: 2)
            .onAppear {
                self.isAnimating = true
            }
        }
    }
}

struct SpinnerView_Previews: PreviewProvider {
    static var previews: some View {
        SpinnerView()
    }
}
