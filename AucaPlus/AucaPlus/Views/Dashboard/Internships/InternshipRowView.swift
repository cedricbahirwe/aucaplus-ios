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
    var onBookmarked: (Internship) -> Void
    
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
            
            LinkPreviewer(url: internship.link)
                .disabled(true)
            
            HStack(spacing: 5) {
                
                Text("Posted \(internship.postedDate.timeAgo)")
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
                
                Text(internship.verified ? "Verified" : "Not verified")
                    .foregroundColor(internship.verified ? Color.accentColor : .primary.opacity(0.6))
                
                Spacer()
                
                Image(isBookmarked ? "bookmark.fill" : "bookmark")
                    .renderingMode(.template)
                    .resizable()
                    .scaledToFit()
                    .foregroundColor(isBookmarked ? Color.accentColor : nil)
                    .frame(width: 20)
                    .contentShape(Rectangle())
                    .onTapGesture {
                        var newValue = self.internship
                        if isBookmarked {
                            newValue.bookmarks -= 1
                        } else {
                            newValue.bookmarks += 1
                        }
                        onBookmarked(newValue)
                    }
                
            }
            .font(.callout)
        }
    }
}

struct InternshipRowView_Previews: PreviewProvider {
    static var previews: some View {
        InternshipRowView(internship: .example,
                          isBookmarked: true,
                          onBookmarked: { _ in })
        .environmentObject(LinksPreviewModel())
        .padding()
        
        .frame(height: 400)
        .previewLayout(.sizeThatFits)
    }
}
