//
//  ResourceRowView.swift
//  AucaPlus
//
//  Created by Cédric Bahirwe on 26/04/2023.
//

import SwiftUI

struct ResourceRowView: View {
    let resource: RemoteResource
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            
            Text(resource.name)
                .font(.title)
            Text(resource.description)
                .font(.title2)
            
            HStack {
                Group {
                    Text(resource.metadata.type.rawValue)
                        .textCase(.uppercase)
                        .font(.callout)
                    
                    Text(resource.createdDate.formatted(date: .long, time: .omitted))
                }
                .padding(.vertical, 6)
                .padding(.horizontal, 10)
                .background(.thinMaterial)
                .clipShape(Capsule())
            }
            .foregroundColor(.accentColor)
            
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            LinearGradient(
                colors: [
                    Color.accentColor,
                    Color.accentColor.opacity(0.75),
                    Color.accentColor.opacity(0.50)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing)
        )
//        .cornerRadius(15)
//        .padding()
        .foregroundColor(.white.opacity(0.8))
    }
}

#if DEBUG
struct ResourceRowView_Previews: PreviewProvider {
    static var previews: some View {
        ResourceRowView(resource: .example)
    }
}
#endif
