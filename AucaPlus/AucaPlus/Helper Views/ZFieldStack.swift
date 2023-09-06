//
//  ZFieldStack.swift
//  AucaPlus
//
//  Created by Cédric Bahirwe on 26/08/2023.
//

import SwiftUI

struct ZFieldStack: View {
    private let title: LocalizedStringKey
    private let placeholder: LocalizedStringKey
    private let axis: Axis
    @Binding var text: String
    
    enum Axis {
        case horizontal
        case vertical(maxHeight: CGFloat? = nil, lines: Int? = nil)
    }
    
    init(_ title: LocalizedStringKey,
         _ placeholder: LocalizedStringKey = "",
         axis: Axis = .horizontal,
         text: Binding<String>) {
        
        self.title = title
        self.placeholder = placeholder
        self.axis = axis
        self._text = text
    }
    
    
    @ViewBuilder
    var fieldView: some View {
        switch axis {
        case .horizontal:
            TextField("", text: $text)
                .padding(10)
                .frame(height: 45 )
        case .vertical(let maxHeight, let lines):
            TextField("", text: $text, axis: .vertical)
                .padding(10)
                .frame(height: maxHeight, alignment: .topLeading)
                .lineLimit(lines)
        }
    }
    
    var body: some View {
        VStack {
            fieldView
                .overlay(content: {
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.secondary, lineWidth: 1)
                })
                .overlay(alignment: .topLeading) {
                    Text(title)
                        .font(.caption)
                        .lineLimit(1)
                        .foregroundColor(.secondary)
                        .padding(.horizontal, 8)
                        .background(.background)
                        .offset(x: 0, y: -8)
                }
        }
    }
}

#if DEBUG
struct ZFieldStack_Previews: PreviewProvider {
    static var previews: some View {
        ZFieldStack("Placholder", text: .constant(""))
    }
}
#endif
