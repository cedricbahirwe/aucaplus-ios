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
    
    init(_ news: News) {
        _itemVM = StateObject(wrappedValue: { NewsItemViewModel(news) }())
    }
    
    @State private var liked = false
    var body: some View {
        VStack (alignment: .leading) {
            
            ProfileInfoView(imageURL: news.author.imageURL,
                            title: news.author.name,
                            subtitle: news.author.headline,
                            verified: news.isVerified,
                            caption: news.createdDate.formatted(date: .long, time: .omitted))
            
            Text(news.content)
                .font(.callout)
            VStack {
                Image(news.images.first!)
                    .resizable()
                    .scaledToFit()
                    .background(.gray)
                    .cornerRadius(15)
                
                HStack {
                    HStack(spacing: 2) {
                        Image(systemName: liked ? "heart.fill" : "heart")
                            .foregroundColor(liked ? .red : .secondary)
                        Text("\(news.likes)")
                    }
                    .onTapGesture {
                        liked ? itemVM.dislike() : itemVM.like()
                        liked.toggle()
                    }
                    
                    Spacer()
                    HStack(spacing: 2) {
                        Image(systemName: "chart.bar.xaxis")
                        Text("\(news.views)")
                    }
                    Spacer()
                    
                    HStack(spacing: 2) {
                        Image(systemName: "square.and.arrow.up")
                    }
                }
                .foregroundColor(.secondary)
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
        NewsRowView(.news1)
            .environmentObject(FeedStore())
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
    var verified: Bool = false
    let caption: String?
    
    var body: some View {
        HStack {
            ProfileImageView(imageURL)
            
            VStack(alignment: .leading, spacing: 4) {
                HStack(spacing: 4) {
                    HStack(spacing: 2) {
                        Text(title).bold()
                        if verified {
                            Image("verify")
                        }
                    }
                    
                    if let caption {
                        HStack(spacing: 2) {
                            Text("·").fontWeight(.black)
                            Text(caption).font(.caption)
                        }
                        .foregroundColor(.secondary)
                    }
                }
                .lineLimit(1)
                
                Text(subtitle ?? "")
                    .font(.caption)
                    .opacity(0.8)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}
