//
//  NewsRowView.swift
//  AucaPlus
//
//  Created by Cédric Bahirwe on 26/04/2023.
//

import SwiftUI

struct NewsRowView: View {
    
    private var news: News {
        itemVM.item
    }
    
    @StateObject private var itemVM: NewsItemViewModel
    
    @EnvironmentObject private var feedVM: FeedStore
    
    private var isBookmarked: Bool
    private var onBookmarked: (News) -> Void
    
    init(_ news: News, isBookmarked: Bool, onBookmarked: @escaping (News) -> Void) {
        _itemVM = StateObject(wrappedValue: { NewsItemViewModel(news) }())
        self.isBookmarked = isBookmarked
        self.onBookmarked = onBookmarked
    }
    
    var body: some View {
        VStack (alignment: .leading) {
            
            if let source = news.source {
                ProfileInfoView(imageURL: source.profile,
                                title: source.name,
                                subtitle: source.headline,
                                postedDate: news.postedDate)
            }
            
            //            ProfileInfoView(imageURL: news..imageURL,
            //                            title: news.author.name,
            //                            subtitle: news.author.headline,
            //                            verified: news.isVerified,
            //                            caption: news.createdDate.formatted(date: .long, time: .omitted))
            
            VStack (alignment: .leading) {
                Text(news.content)
                    .font(.callout)
                VStack {
                    AucaPlusImageView(news.images.first!, placeholderImage: Image("auca1"))
                        .scaledToFit()
                        .background(.gray)
                        .cornerRadius(15)
                }
            }
        }
        .padding()
    }
    
    var message: AttributedString {
        let string = "The letters go up and down"
        var result = AttributedString()
        
        for (index, letter) in string.enumerated() {
            var letterString = AttributedString(String(letter))
            letterString.baselineOffset = sin(Double(index)) * 5
            result += letterString
        }
        
        result.font = .largeTitle
        return result
    }
}

#if DEBUG
struct NewsRowView_Previews: PreviewProvider {
    static var previews: some View {
        NewsRowView(.news1, isBookmarked: false) { _ in }
            .environmentObject(FeedStore())
            .previewLayout(.sizeThatFits)
    }
}
#endif

struct ProfileImageView: View {
    let image: URL?
    let placeholderImage: String
    let size: CGFloat
    
    init(_ image: URL?, placeholderImage: String = "auca.logo", _ size: CGFloat = 50) {
        self.image = image
        self.size = size
        self.placeholderImage = placeholderImage
    }
    
    var body: some View {
        Group {
            AsyncImage(url: image,
                       scale: 1) {
                $0.resizable()
            } placeholder: {
                Image(placeholderImage)
                    .resizable()
            }
        }
        .frame(width: size, height: size)
        .clipShape(Circle())
    }
}

struct ProfileInfoView: View {
    let imageURL: URL?
    let title: String
    let subtitle: String?
    let postedDate: Date
    
    var body: some View {
        
        HStack {
            
            ProfileImageView(imageURL, 40)
            
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
