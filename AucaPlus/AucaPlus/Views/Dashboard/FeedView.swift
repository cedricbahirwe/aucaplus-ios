//
//  FeedView.swift
//  AucaPlus
//
//  Created by Cédric Bahirwe on 02/04/2023.
//

import SwiftUI

struct FeedView: View {
    @StateObject private var feedStore = FeedStore()
    @State private var goToCreator = false
    
    var body: some View {
        NavigationStack {
            ScrollView {
                ScrollViewReader { proxy in
                    VStack(spacing: 0) {
                        ForEach(feedStore.news) { newsItem in
                            VStack(spacing: 3) {
                                FeedRowView(itemVM: .init(item: newsItem))
                                Divider()
                            }
                            .id(newsItem.id)
                        }
                    }
                }
            }
            .navigationBarTitle("Feed")
            .toolbar(.visible, for: .navigationBar)
            .navigationDestination(isPresented: $goToCreator) {
                PostCreatorView()
            }
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    filterMenu
                    
                    addButton
                }
            }
        }
    }
    
    private var filterMenu: some View {
        Menu {
            Button {
                
            } label: {
                Label("Verified", systemImage: "checkmark.seal.fill")
            }
            
            Button {
                
            } label: {
                Label("For Me", systemImage: "person.badge.shield.checkmark.fill")
            }
            
        } label: {
            Image(systemName: "line.3.horizontal.decrease.circle")
        }
    }
    
    private var addButton: some View {
        Button {
            goToCreator.toggle()
        } label: {
            Image(systemName: "plus")
        }
    }
}

#if DEBUG
struct FeedView_Previews: PreviewProvider {
    static var previews: some View {
        FeedView()
            .previewLayout(SwiftUI.PreviewLayout.fixed(width: 416, height: 1000))
    }
}
#endif

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


struct News: Identifiable, Codable {
    var id: String { UUID().uuidString }
    
    var imageURL: String
    
    var schoolName: String
    
    var schoolSubtitle: String
    
    var description: AttributedString
    
    var images: [String]
    
    var postedDate: String
    
    var isVerified: Bool = true
    
    var likes: Int
    
    var views: Int
    
    mutating func like() {
        likes += 1
    }
    
    mutating func dislike() {
        likes -= 1
    }
    
    static let example = News(imageURL: "auca.logo",
                               schoolName: "AUCA",
                               schoolSubtitle: "Adventist University of Central Africa",
                               description: News.description1,
                               images: ["auca1"],
                               postedDate: "1d",
                               likes: 21,
                               views: 104)
    
    static var description1: AttributedString = {
        var str = AttributedString("@Bridge2Rwanda")
        str.link = URL(string: "https://github.com/AUCA-DEVELOPERS")
        str.foregroundColor = .accentColor
        
        return "Today, AUCA & " + str + "'s Bridge Talent Services, signed a MoU in areas of career devpt for students/graduates. The partnership will enhance education-to-employment approach, thus enabling students to learn, apply skills to build career mobility via job readiness workshops."
    }()
    
    
}

final class FeedItemViewModel: ObservableObject {
    @Published var item: News
    
    init(item: News) {
        self.item = item
    }
    
    func like() {
        item.like()
    }
    
    func dislike() {
        item.dislike()
    }
}
