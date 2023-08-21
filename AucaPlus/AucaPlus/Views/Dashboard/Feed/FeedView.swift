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
            ScrollView {
                ScrollViewReader { proxy in
                    VStack(spacing: 0) {
                        ForEach(feedStore.sortedItems, id: \.id) { item in
                            VStack(spacing: 3) {
                                if let announcement = item as? Announcement {
                                    AnnouncementRowView(announcement: announcement)
                                        .onTapGesture {
                                            withAnimation {
                                                overlay.present(announcement)
                                            }
                                        }
                                } else if let resource = item as? RemoteResource {
                                    ResourceRowView(resource: resource)
                                } else if let news = item as? News {
                                    NewsRowView(
                                        news,
                                        isBookmarked: bookmarksVM.isBookmarked(news),
                                        onBookmarked: {
                                            bookmarksVM.toggleBookmarking(.init(type: .news(news)))
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
            .overlayListener(of: $overlay) { announcement in
               AnnouncementRowView(announcement: announcement, isExpanded: true)
                    .padding()
            }
            .navigationBarTitle("Feed")
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    filterMenu                    
                }
            }
        }
    }
    
    private var filterMenu: some View {
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
            Image(systemName: "line.3.horizontal.decrease.circle")
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
