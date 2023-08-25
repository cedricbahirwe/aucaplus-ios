//
//  LinkPreviewer.swift
//  AucaPlus
//
//  Created by Cédric Bahirwe on 23/08/2023.
//

import LinkPresentation
import SwiftUI

typealias AucaLinkView = LPLinkView
struct LinkPreviewer: UIViewRepresentable {
    var metadata: LPLinkMetadata
    
    func makeUIView(context: Context) -> AucaLinkView {
        let linkView = AucaLinkView()
        linkView.metadata = metadata
    
        return linkView
    }

    func updateUIView(_ uiView: LPLinkView, context: Context) {}

}
