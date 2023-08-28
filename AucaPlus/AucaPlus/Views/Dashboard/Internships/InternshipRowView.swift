//
//  InternshipRowView.swift
//  AucaPlus
//
//  Created by Cédric Bahirwe on 24/08/2023.
//

import SwiftUI

struct InternshipRowView: View {
    var internship: Internship
    var isBookmarked: Bool
    var onBookmarking: (Bool) -> Void
    @EnvironmentObject var linkVM: LinksPreviewModel
    
    @State private var linkPreview: LinkPreview?

    var body: some View {
        VStack(alignment: .leading) {
            VStack(alignment: .leading) {
                if let title = internship.title {
                    Text(title)
                        .fontWeight(.medium)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .foregroundColor(.primary)
                }
                
                if let description = internship.description {
                    Text(description)
                        .font(.callout)
                        .fontWeight(.light)
                        .foregroundColor(.primary)
                        .opacity(0.9)
                        .multilineTextAlignment(.leading)
                        .lineLimit(3)
                        .layoutPriority(3)
                }
            }
            
            if let metadata = linkPreview?.metadata {
                LinkPreviewer(metadata: metadata)
                    .disabled(true)
            } else {
                EmptyView()
            }
            
            HStack(spacing: 5) {
                
                Text(internship.postedDate.timeAgo)
                    .opacity(0.6)

                if internship.views != 0 {
                    DotView()
                    
                    HStack(spacing: 2) {
                        Text("\(internship.views)")
                            .bold()
                        Text("View\(internship.views > 1 ? "s" : "")")
                            .opacity(0.6)
                    }
                }
                
                if internship.bookmarks != 0 {
                    DotView()
                    
                    HStack(spacing: 4) {
                        Text("\(internship.bookmarks)")
                            .bold()
                        Text("Bookmark\(internship.bookmarks > 1 ? "s" : "")")
                            .opacity(0.6)
                    }
                }
                
            }
            .foregroundColor(.primary)
            .font(.callout)
            .lineLimit(1)
            .minimumScaleFactor(0.8)
            
            Divider()
            
            HStack {
                
                Group {
                    Text(internship.source.name)
                        .fontWeight(.medium)
                    
                    DotView()
                    
                    Text(internship.location)
                    
                    DotView()
                }
                .foregroundColor(.primary)
                .opacity(0.6)
                
                HStack(spacing: 2) {
                    VerifyView(color: internship.verified ? .accentColor : .primary.opacity(0.6))
                    Text(internship.verified ? "Verified" : "Not verified")
                        .foregroundColor(internship.verified ? Color.accentColor : .primary.opacity(0.6))
                }
                
                Spacer()
                
                Image(isBookmarked ? "bookmark.fill" : "bookmark")
                    .renderingMode(.template)
                    .resizable()
                    .scaledToFit()
                    .foregroundColor(isBookmarked ? Color.accentColor : nil)
                    .frame(width: 20)
                    .contentShape(Rectangle())
                    .onTapGesture {
                        onBookmarking(!isBookmarked)
                    }
                
            }
            .font(.callout)
        }
        .task {
            self.linkPreview = await  linkVM.getLinkPreview(for: internship.link)
        }
    }
}

struct InternshipRowView_Previews: PreviewProvider {
    static var previews: some View {
        InternshipRowView(internship: .example,
                          isBookmarked: true,
                          onBookmarking: { _ in })
        .environmentObject(LinksPreviewModel())
        .padding()
        
        .frame(height: 400)
        .previewLayout(.sizeThatFits)
    }
}
