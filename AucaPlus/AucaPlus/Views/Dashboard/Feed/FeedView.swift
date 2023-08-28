//
//  FeedView.swift
//  AucaPlus
//
//  Created by Cédric Bahirwe on 02/04/2023.
//

import SwiftUI

struct FeedView: View {
    @StateObject private var feedStore = FeedStore()
    
    @State private var overlay = OverlayModel<Announcement>()
    @EnvironmentObject private var bookmarksVM: BookmarkViewModel

    var body: some View {
        NavigationStack {
            ScrollView(showsIndicators: false) {
                ScrollViewReader { proxy in
                    VStack(spacing: 0) {
                        ForEach(feedStore.sortedItems, id: \.id) { item in
                            VStack(spacing: 3) {
                                if let announcement = item as? Announcement {
//                                    AnnouncementRowView(announcement: announcement)
//                                        .onTapGesture {
//                                            withAnimation {
//                                                overlay.present(announcement)
//                                            }
//                                        }
//                                } else if let resource = item as? RemoteResource {
//                                    ResourceRowView(resource: resource)
                                } else if let news = item as? News {
                                    NewsRowView(
                                        news,
                                        isBookmarked: bookmarksVM.isBookmarked(news),
                                        onBookmarked: {
                                            if bookmarksVM.isBookmarked(news) {
                                                bookmarksVM.removeFromBookmarks($0)
                                            } else {
                                                bookmarksVM.addToBookmarks($0)
                                            }
                                        }
                                    )
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
            .overlayListener(of: $overlay) { announcement in
               AnnouncementRowView(announcement: announcement, isExpanded: true)
                    .padding()
            }
            .navigationBarTitle("Feed")
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    filterButton
//                    notificationButton
//                        .hidden()
                }
            }
        }
        .overlay {
            if feedStore.isFetchingNews {
                SpinnerView()
            }
        }
    }
    
    @ViewBuilder
    private var filterButton: some View {
        Button("Fetch") {
            Task {
                await feedStore.fetchNews()
            }
        }
        
        Button("Create") {
            Task {
                await feedStore.createNews()
            }
        }
//        Menu {
//            ForEach(FeedStore.FeedFilter.allCases, id: \.self) { filter in
//                Button {
//                    feedStore.setFilter(filter)
//                } label: {
//                    Label {
//                        Text(filter.rawValue.capitalized)
//                    } icon: {
//                        if filter == feedStore.filter {
//                            Image(systemName: "checkmark")
//                        }
//                    }
//                }
//            }
//        } label: {
//            Label("Filter", systemImage: "line.3.horizontal.decrease.circle")
//        }
    }
    
    private var notificationButton: some View {
        Button {
        } label: {
            Label("Notifications", systemImage: "bell.badge")
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
