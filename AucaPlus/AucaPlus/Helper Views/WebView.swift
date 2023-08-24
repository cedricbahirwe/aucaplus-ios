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
            .navigationTitle("\(Image(systemName: "house.fill"))Auca Web")
            .navigationBarTitleDisplayMode(.inline)
    }
}

struct WebView_Previews: PreviewProvider {
    static var previews: some View {
        WebView(url: .init(string: "https://chat.openai.com")!)
    }
}

fileprivate struct WebViewRepresentation: UIViewControllerRepresentable {
    
    let url: URL
    
    func makeUIViewController(context: Context) -> AucaWebViewController {
        let viewController = AucaWebViewController()
        return viewController
    }
    
    func updateUIViewController(_ uiViewController: AucaWebViewController, context: Context) {
        uiViewController.loadURL(url)
    }
}

fileprivate class AucaWebViewController: UIViewController {
    private var webView: WKWebView!
    private var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupWebView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    private func setupWebView() {
        view.backgroundColor = .clear
        
        webView = WKWebView()
        webView.navigationDelegate = self
        view.addSubview(webView)
        webView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            webView.topAnchor.constraint(equalTo: view.topAnchor),
            webView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        addActivityIndicator()
    }
    
    private func addActivityIndicator() {
        activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.color = UIColor(Color.accentColor)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(activityIndicator)
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    private func setTitle(_ pageTitle: String?) {
        parent?.navigationItem.title = pageTitle
    }
    
    func loadURL(_ url: URL) {
        let request = URLRequest(url: url)
        webView.load(request)
    }
}

extension AucaWebViewController: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        activityIndicator.startAnimating()
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        Task {
            let pageTitle = try? await webView.evaluateJavaScript("document.title") as? String
                self.setTitle(pageTitle)
        }
        
        activityIndicator.stopAnimating()
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        activityIndicator.stopAnimating()
    }
}
