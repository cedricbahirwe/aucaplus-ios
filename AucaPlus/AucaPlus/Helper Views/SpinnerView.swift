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
    var spinnerBackgroundColor: Color = .gray
    var backgroundCornerRadius: CGFloat = 30
    var width: CGFloat = 50
    var height: CGFloat = 50
    var speed: Double = 1
}

struct SpinnerView: View {
    var configuration: SpinnerConfiguration = SpinnerConfiguration()
    @State private var isAnimating = false
    
    var body: some View {
        let multiplier = configuration.width / 40
        
        ZStack {
            Color.clear.ignoresSafeArea()
                .background(Material.ultraThinMaterial)
            //        configuration.blurredBackground.opacity(0.8)
            //          .ignoresSafeArea()
            //          .blur(radius: 300)
            
            ZStack {
                configuration.spinnerBackgroundColor.opacity(0.0)
                    .background(Material.ultraThickMaterial)
                
                Circle()
                    .trim(from: 0.2, to: 1)
                    .stroke(
                        configuration.spinnerColor,
                        style: StrokeStyle(
                            lineWidth: 5 * multiplier,
                            lineCap: .round
                        )
                    )
                    .frame(width: configuration.width, height: configuration.height)
                    .shadow(color: Color.black.opacity(0.1), radius: 3, x: 0, y: 3)
                    .rotationEffect(.degrees(isAnimating ? 360 : 0))
                    .animation(
                        Animation.linear(duration: configuration.speed)
                            .repeatForever(autoreverses: false)
                        , value: isAnimating
                    )
            }
            .frame(width: 80 * multiplier, height: 80 * multiplier)
            .background(Color.white)
            .cornerRadius(configuration.backgroundCornerRadius)
            .shadow(color: Color.white.opacity(0.3), radius: 5, x: 0, y: 5)
            .shadow(color: Color.black.opacity(0.1), radius: 2, x: 0, y: 2)
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
