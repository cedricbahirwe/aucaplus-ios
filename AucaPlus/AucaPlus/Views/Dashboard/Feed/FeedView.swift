//
//  FeedView.swift
//  AucaPlus
//
//  Created by Cédric Bahirwe on 02/04/2023.
//

import SwiftUI

struct FeedView: View {
    @StateObject private var feedStore = FeedStore()
    
    @EnvironmentObject private var bookmarksVM: BookmarkViewModel
    
    var body: some View {
        NavigationStack {
            ScrollView(showsIndicators: false) {
                ScrollViewReader { proxy in
                    VStack(spacing: 0) {
                        ForEach(feedStore.sortedItems, id: \.id) { item in
                            VStack(spacing: 3) {
                                if let news = item as? News {
                                    NewsRowView(
                                        news,
                                        isBookmarked: bookmarksVM.isBookmarked(news),
                                        onBookmarked: {
                                            if bookmarksVM.isBookmarked(news) {
                                                bookmarksVM.removeFromBookmarks($0)
                                            } else {
                                                bookmarksVM.addToBookmarks($0)
                                            }
                                        },
                                        onViewed: bookmarksVM.view)
                                }
                                
                                Divider()
                            }
                            .id(item.id)
                        }
                    }
                }
            }
            .refreshable {
                
            }
            .task {
                await feedStore.fetchNews()
            }
            .navigationBarTitle("Feed")
//            .toolbar {
//                ToolbarItemGroup(placement: .navigationBarTrailing) {
//                    filterButton
//                }
//            }
        }
        .overlay {
            if feedStore.isFetchingNews {
                SpinnerView()
            }
        }
    }
    
    @ViewBuilder
    private var filterButton: some View {
        Menu {
            ForEach(FeedStore.FeedFilter.allCases, id: \.self) { filter in
                Button {
                    feedStore.setFilter(filter)
                } label: {
                    Label {
                        Text(filter.rawValue.capitalized)
                    } icon: {
                        if filter == feedStore.filter {
                            Image(systemName: "checkmark")
                        }
                    }
                }
            }
        } label: {
            Label("Filter", systemImage: "line.3.horizontal.decrease.circle")
        }
    }
}

#if DEBUG
struct FeedView_Previews: PreviewProvider {
    static var previews: some View {
        FeedView()
            .environmentObject(BookmarkViewModel())
    }
}
#endif
