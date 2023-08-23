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
//        NavigationView {
//            LinkPreviewView(urlString: "https://www.example.com")
            ScrollView {
                ForEach(testURLS, id: \.self) { url in
                    LinkPreviewView(isLoading: $isLoading, url: url)
//                        .frame(height: 80)
                        .animation(nil, value: isLoading)
                        .overlay(content: {
                            if isLoading {
                                ProgressView()
                            }
                        })
                }
                .padding(.horizontal)
            }
            .navigationTitle("Link Preview")

//        }
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


struct LinkPreviewView: UIViewRepresentable {
    @Binding var isLoading: Bool
    let url: URL
    
    func makeUIView(context: Context) -> LPLinkView {
        let linkView = LPLinkView()
//        linkView.
        Task {
            await generateLinkPreview(linkView: linkView)
        }
        return linkView
    }
    
    func updateUIView(_ uiView: LPLinkView, context: Context) {
        // Nothing to do here, as the link preview is generated in `makeUIView`
    }
    
    let cacher = MemoryCache<NSString, LPLinkMetadata>()

    
    private func generateLinkPreview(linkView: LPLinkView) async {
        if let cachedMetadata = cacher.value(forKey: NSString(string: url.absoluteString)) {
            print("Found cache")
            DispatchQueue.main.async {
                linkView.metadata = cachedMetadata
            }
            return
        }
        
        let metadataProvider = LPMetadataProvider()
        do {
            print("Starting", Date.now)
            isLoading = true
            let metadata = try await metadataProvider.startFetchingMetadata(for: url)
            print("Ending", Date.now)
            isLoading = false
            DispatchQueue.main.async {
                linkView.metadata = metadata
                if let originalURL = metadata.originalURL {
                    cacher.cache(value: metadata, forKey: NSString(string: originalURL.absoluteString))
                }
//                print("title", metadata.title)
//                print("URL", metadata.url)
//                print("originalURL", metadata.originalURL)
//                print("remoteVideoURL", metadata.remoteVideoURL)
//                print("description", metadata.description)
//                print("description", metadata.imageProvider)
            }
        } catch {
            isLoading = false
            print("Error fetching metadata: \(error.localizedDescription)")
        }
    }
}


class MemoryCache<Key: AnyObject, Value: AnyObject> {
    private let cache = NSCache<Key, Value>()
    
    func cache(value: Value, forKey key: Key) {
        cache.setObject(value, forKey: key)
    }
    
    func value(forKey key: Key) -> Value? {
        return cache.object(forKey: key)
    }
    
    func removeValue(forKey key: Key) {
        cache.removeObject(forKey: key)
    }
    
    func removeAll() {
        cache.removeAllObjects()
    }
}
