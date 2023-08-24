//
//  TestingView.swift
//  AucaPlus
//
//  Created by Cédric Bahirwe on 23/08/2023.
//

import SwiftUI
import LinkPresentation

struct TestingView: View {
    @State private var isLoading = false
    
    private let testURLS = [
        "https://developer.apple.com/news/?id=8sntwknb",
    ]
        .compactMap(URL.init(string:))
    
    var body: some View {
        ScrollView {
        }
    }


}

struct TestingView_Previews: PreviewProvider {
    static var previews: some View {
        TestingView()
    }
}


struct LinkView: UIViewRepresentable {
    typealias UIViewType = LPLinkView
    
    var metadata: LPLinkMetadata?
    
    func makeUIView(context: Context) -> LPLinkView {
        guard let metadata = metadata else { return LPLinkView() }
        let linkView = LPLinkView(metadata: metadata)
        return linkView
    }

    func updateUIView(_ uiView: LPLinkView, context: Context) {

    }
}
