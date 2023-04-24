//
//  FeedRowView.swift
//  AucaPlus
//
//  Created by Cédric Bahirwe on 24/04/2023.
//

import SwiftUI

struct FeedRowView: View {
    @StateObject var itemVM: FeedItemViewModel
    
    var item: News {
        itemVM.item
    }
    @State private var liked = false
    var body: some View {
        VStack (alignment: .leading) {
            HStack {
                Image(item.imageURL)
                    .resizable()
                    .frame(width: 50, height: 50)
                VStack(alignment: .leading, spacing: 4) {
                    HStack(spacing: 4) {
                        HStack(spacing: 2) {
                            Text(item.schoolName).bold()
                            if item.isVerified {
                                Image("verify")
                            }
                        }
                        
                        HStack(spacing: 2) {
                            Text("·").fontWeight(.black)
                            Text(item.postedDate).font(.caption)
                        }
                        .foregroundColor(.secondary)
                    }
                    .lineLimit(1)
                    
                    Text(item.schoolSubtitle)
                        .font(.caption)
                        .opacity(0.8)
                    
                }
                
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
            Text(item.description)
                .font(.callout)
            VStack {
                Image(item.images.first!)
                    .resizable()
                    .scaledToFit()
                    .background(.gray)
                    .cornerRadius(15)
                
                HStack {
                    HStack(spacing: 2) {
                        Image(systemName: liked ? "heart.fill" : "heart")
                            .foregroundColor(liked ? .red : .secondary)
                        Text("\(item.likes)")
                    }
                    .onTapGesture {
                        liked ? itemVM.dislike() : itemVM.like()
                        liked.toggle()
                    }
                    
                    Spacer()
                    HStack(spacing: 2) {
                        Image(systemName: "chart.bar.xaxis")
                        Text("\(item.views)")
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
struct FeedRowView_Previews: PreviewProvider {
    static var previews: some View {
        FeedRowView(itemVM: FeedItemViewModel(item: .example))
    }
}
#endif
