//
//  InternshipDetailView.swift
//  AucaPlus
//
//  Created by Cédric Bahirwe on 25/08/2023.
//

import SwiftUI

struct InternshipDetailView: View {
    let internship: Internship
    
    @EnvironmentObject private var bookmarkVM: BookmarkViewModel
    @EnvironmentObject private var linksVM: LinksPreviewModel
    
    @State private var linkPreview: LinkPreview?
    @State private var showShareSheet = false
    
    var body: some View {
        ZStack {
            WebView(url: internship.link)
            if showShareSheet, let metadata = linkPreview?.metadata {
                ShareLinkView(metadata: metadata) {
                    showShareSheet = false
                }
                .frame(width: 0, height: 0)
            }
        }
        .toolbar {
            if linkPreview?.metadata != nil {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showShareSheet.toggle()
                    } label: {
                        Label("Share Link", systemImage: "square.and.arrow.up")
                    }
                }
            }
        }
        .task {
            linkPreview = await linksVM.getLinkPreview(for: internship.link)
        }
        .task {
            await bookmarkVM.view(internship)
        }
    }
}


struct InternshipDetailView_Previews: PreviewProvider {
    static var previews: some View {
        InternshipDetailView(internship: .example)
            .environmentObject(BookmarkViewModel())
            .environmentObject(LinksPreviewModel())
    }
}
