//
//  WebView.swift
//  AucaPlus
//
//  Created by Cédric Bahirwe on 17/08/2023.
//

import SwiftUI
import WebKit

struct WebView: View {
    let url: URL
    var body: some View {
        WebViewRepresentation(url: url)
    }
}

struct WebView_Previews: PreviewProvider {
    static var previews: some View {
        WebView(url: .init(string: "")!)
    }
}


fileprivate struct WebViewRepresentation: UIViewRepresentable {
    let url: URL
    
    func makeUIView(context: Context) -> WKWebView {
        return WKWebView()
    }
    
    func updateUIView(_ webView: WKWebView, context: Context) {
        
        let request = URLRequest(url: url)
        webView.load(request)
    }
}
