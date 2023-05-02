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
        Text("Hello, World!")
    }
}

#if DEBUG
struct ResourceRowView_Previews: PreviewProvider {
    static var previews: some View {
        ResourceRowView(resource: .example)
    }
}
#endif
