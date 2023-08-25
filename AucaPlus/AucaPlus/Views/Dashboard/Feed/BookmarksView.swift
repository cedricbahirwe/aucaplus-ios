//
//  BookmarksView.swift
//  AucaPlus
//
//  Created by Cédric Bahirwe on 24/04/2023.
//

import SwiftUI

struct BookmarksView: View {
    @EnvironmentObject private var bookmarksVM: BookmarkViewModel
    var body: some View {
        ScrollView(showsIndicators: false) {
            ForEach(bookmarksVM.sortedBookmarks) { bookmark in
                switch bookmark.type {
                case .news(let news):
                    NewsRowView(
                        news,
                        isBookmarked: bookmarksVM.isBookmarked(news),
                        onBookmarked: {
                            bookmarksVM.toggleBookmarking(.init(type: .news($0)))
                        }
                    )
                case .internship(let internship):
                    NavigationLink(value: internship) {
                        InternshipRowView(
                            internship: internship,
                            isBookmarked: bookmarksVM.isBookmarked(internship),
                            onBookmarking: { _ in
                                var oldBookmark = internship
                                oldBookmark.bookmarks -= 1
                                bookmarksVM.removeFromBookmarks(oldBookmark)
                            })
                        .padding(.horizontal)
                    }
                    
                    Divider()
                    
                }
            }
        }
        .background {
            if bookmarksVM.isEmpty() {
                VStack {
                    Image(systemName: "bubble.left.and.bubble.right")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 150)
                    
                    Text("Nothing Bookmarked Yet")
                        .font(.title2)
                }
                .foregroundStyle(.gray, Color.accentColor)
                .padding(30)
                .background(.ultraThinMaterial)
                .cornerRadius(20)
                .fixedSize()
            }
        }
        .navigationTitle("Bookmarks")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem {
                Menu {
                    Button("Clear All Bookmarks", action: bookmarksVM.clearAlls)
                        .disabled(bookmarksVM.isEmpty())
                } label: {
                    Image(systemName: "ellipsis")
                }
            }
        }
    }
}

struct BookmarksView_Previews: PreviewProvider {
    static var previews: some View {
        BookmarksView()
            .environmentObject(BookmarkViewModel())
    }
}
