//
//  NewsRowView.swift
//  AucaPlus
//
//  Created by Cédric Bahirwe on 26/04/2023.
//

import SwiftUI

struct NewsRowView: View {
    @StateObject private var itemVM: NewsItemViewModel
    @EnvironmentObject private var feedVM: FeedStore

    init(_ news: News, isBookmarked: Bool,
         onBookmarked: @escaping (News) -> Void,
         onViewed: @escaping (News) async -> Void) {
        _itemVM = StateObject(wrappedValue: { NewsItemViewModel(news) }())
        self.isBookmarked = isBookmarked
        self.onBookmarked = onBookmarked
        self.onViewed = onViewed
    }
    
    private var isBookmarked: Bool
    private var onBookmarked: (News) -> Void
    private var news: News { itemVM.item }
    private var onViewed: (News) async -> Void
     
    var body: some View {
        VStack (alignment: .leading) {
            
            if let source = news.source {
                HStack(alignment: .firstTextBaseline) {
                    ProfileInfoView(imageURL: source.profile,
                                    title: source.name,
                                    subtitle: source.headline,
                                    postedDate: news.postedDate)
                    
                    Image(isBookmarked ? "bookmark.fill" : "bookmark")
                        .renderingMode(.template)
                        .resizable()
                        .scaledToFit()
                        .foregroundColor(isBookmarked ? Color.accentColor : nil)
                        .frame(width: 20)
                        .contentShape(Rectangle())
                        .onTapGesture {
                            itemVM.bookmark(!isBookmarked)
                            onBookmarked(news)
                        }
                }
            }
            
            VStack (alignment: .leading) {
                if let content = news.content {
                    Text(content)
                        .font(.callout)
                }
                
                AucaPlusImageView(news.images.first!, placeholderImage: Image("placeholder"))
                    .scaledToFit()
                    .background(.gray)
                    .cornerRadius(15)
                    .frame(maxWidth: .infinity)
            }
        }
        .padding()
        .task {
            itemVM.view()
            await onViewed(news)
        }
    }
}

#if DEBUG
struct NewsRowView_Previews: PreviewProvider {
    static var previews: some View {
        NewsRowView(.news1,
                    isBookmarked: false,
                    onBookmarked: { _ in },
                    onViewed: { _ in })
            .environmentObject(FeedStore())
            .previewLayout(.sizeThatFits)
    }
}
#endif

fileprivate extension NewsRowView {
    struct ProfileInfoView: View {
        let imageURL: URL?
        let title: String
        let subtitle: String?
        let postedDate: Date
        
        var body: some View {
            
            HStack {
                AucaPlusImageView(imageURL!, .square(40))
                
                VStack(alignment: .leading, spacing: 4) {
                    HStack(alignment: .firstTextBaseline, spacing: 4) {
                        Text(title)
                            .font(.headline)
                        
                        if subtitle != nil {
                            Text("·").fontWeight(.black)
                            Text(postedDate.formatted(date: .long, time: .omitted))
                                .font(.callout)
                                .opacity(0.8)
                        }
                    }
                    .lineLimit(1)
                    
                    Group {
                        if let subtitle {
                            Text(subtitle)
                        } else {
                            Text(postedDate.formatted(date: .long, time: .omitted))
                        }
                    }
                    .font(.caption)
                    .opacity(0.8)
                }
            }
            .padding(.bottom, 8)
            .overlay(alignment: .bottom) {
                if subtitle == nil {
                    Divider()
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
}
