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
    
    @State private var showAllText = false
     
    var body: some View {
        VStack (alignment: .leading) {
            
            if let source = news.source {
                HStack(alignment: .firstTextBaseline) {
                    ProfileInfoView(imageURL: source.profile,
                                    title: source.name,
                                    subtitle: source.headline)
                    
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
                        .lineLimit(showAllText ? nil : 5)
                        .onTapGesture {
                            withAnimation {
                                showAllText.toggle()
                            }
                        }
                }
                
                if let image = news.files?.first {
                    AucaPlusImageView(image, placeholder: {
                        PlaceHolderView()
                    })
                    .scaledToFit()
                    .background(.gray)
                    .cornerRadius(15)
                    .frame(maxWidth: .infinity)
                    .onTapGesture {
                        // Get image from cache and display
                        // if not in cache load image
                    }
                }
                
                HStack(spacing: 3) {
                    Text(news.postedDate.formatted(date: .numeric, time: .omitted))
                    
                    Text("·")
                    
                    Text(news.postedDate.formatted(date: .omitted, time: .shortened))
                    
                    Text("·")

                    Text("\(Text("\(news.views)").bold().foregroundColor(.primary)) View\(news.views > 1 ? "s" : "")")
                }
                .font(.callout)
                .foregroundColor(.secondary.opacity(0.8))
                .padding(.top, 8)
            }
        }
        .padding()
        .task {
            itemVM.view()
            await onViewed(news)
        }
    }
}

struct NewsRowView_Previews: PreviewProvider {
    static var previews: some View {
        NewsRowView(.news1,
                    isBookmarked: false,
                    onBookmarked: { _ in },
                    onViewed: { _ in })
            .environmentObject(FeedStore())
            .previewLayout(.sizeThatFits)
//            .preferredColorScheme(.dark)
    }
}

private extension NewsRowView {
    struct ProfileInfoView: View {
        let imageURL: URL?
        let title: String
        let subtitle: String?
        
        var body: some View {
            
            HStack {
                AucaPlusImageView(imageURL!, .square(40))
                    .clipShape(Circle())
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.headline)
                        .lineLimit(1)
                    
                    if let subtitle {
                        Text(subtitle)
                            .font(.caption)
                            .opacity(0.8)
                    }
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
