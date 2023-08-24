//
//  LinkPreviewer.swift
//  AucaPlus
//
//  Created by Cédric Bahirwe on 23/08/2023.
//

import LinkPresentation
import SwiftUI

struct LinkPreviewer: UIViewRepresentable {
    @EnvironmentObject var linkVM: LinksPreviewModel

    var url: URL
    
    func makeUIView(context: Context) -> AucaLinkView {
        let linkView = AucaLinkView()
        Task {
            await generateLinkPreview(linkView: linkView)
        }
    
        return linkView
    }

    func updateUIView(_ uiView: AucaLinkView, context: Context) {

    }
    
    private func generateLinkPreview(linkView: AucaLinkView) async {
        if let previewData = linkVM.getLinkPreview(for: url.absoluteString)?.metadata {
            DispatchQueue.main.async {
                linkView.metadata = previewData
            }
            return
        }
        
        let metadataProvider = LPMetadataProvider()
        do {
            let metadata = try await metadataProvider.startFetchingMetadata(for: url)

            DispatchQueue.main.async {
                linkView.metadata = metadata
                if let originalURL = metadata.originalURL {
                    linkVM.createLink(with: metadata, for: originalURL.absoluteString)
                }
            }
        } catch {
            print("❌Error fetching metadata: \(error.localizedDescription)")
        }
    }
}

typealias AucaLinkView = LPLinkView
