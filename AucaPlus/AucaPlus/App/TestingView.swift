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
