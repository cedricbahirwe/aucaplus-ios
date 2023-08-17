//
//  View+Extensions.swift
//  AucaPlus
//
//  Created by Cédric Bahirwe on 24/04/2023.
//

import SwiftUI

extension View {
    /// Dismiss keyboard
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
    
    func overlayListener<Content, T>(
        of overlay: Binding<OverlayModel<T>>,
        @ViewBuilder content: (T) -> Content)
    -> some View where Content: View {
        self
            .overlay {
                ZStack {
                    Color.black.opacity(0)
                        .ignoresSafeArea()
                        .background(.ultraThinMaterial.opacity(overlay.wrappedValue.isShown ? 1 :0))
                        .onTapGesture {
                            overlay.wrappedValue.dismiss()
                        }
                    
                    if let data = overlay.wrappedValue.data {
                        content(data)
                        
                    }
                }
            }
    }
}
