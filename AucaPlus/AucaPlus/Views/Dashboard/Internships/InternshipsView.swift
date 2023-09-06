//
//  InternshipsView.swift
//  AucaPlus
//
//  Created by Cédric Bahirwe on 17/08/2023.
//

import SwiftUI

struct InternshipsView: View {
    @EnvironmentObject private var bookmarksVM: BookmarkViewModel
    @StateObject private var internshipsVM = InternshipsViewModel()
    @State private var showBookmarks = false
    
    @EnvironmentObject var linkVM: LinksPreviewModel
    
    var body: some View {
        NavigationStack {
            ScrollView(showsIndicators: false) {
                
                ForEach($internshipsVM.internships) { $internship in
                    NavigationLink(value: internship) {
                        InternshipRowView(
                            internship: internship,
                            isBookmarked: bookmarksVM.isBookmarked(internship),
                            onBookmarking: { isBookmarking in
                                if isBookmarking {
                                    internship.bookmarks += 1
                                    bookmarksVM.addToBookmarks(internship)
                                } else {
                                    internship.bookmarks -= 1
                                    bookmarksVM.removeFromBookmarks(internship)
                                }
                            }).padding(.horizontal)
                    }
                    
                    Divider()
                        .frame(height: 0.65)
                        .overlay(.gray)
                }
                
                if internshipsVM.internships.count > 10 {
                    CaughtUpView("You're all caught up🎉", "You've seen all recent internships.")
                }
            }
            .navigationDestination(for: Internship.self, destination: InternshipDetailView.init)
            .navigationDestination(isPresented: $showBookmarks) {
                BookmarksView()
            }
            .task {
                await internshipsVM.fetchInternships()
            }
            .task {
                await internshipsVM.isUserAuthenticated()
            }
            .frame(maxWidth: .infinity)
            .background(Color(.secondarySystemBackground), ignoresSafeAreaEdges: .all)
            .navigationTitle("Internships")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showBookmarks = true
                    } label: {
                        Image(systemName: "bookmark.circle")
                    }
                }
            }
        }
        .overlay {
            if internshipsVM.isFetchingInternships {
                SpinnerView()
            }
        }
    }
}

struct InternshipsView_Previews: PreviewProvider {
    static var previews: some View {
        InternshipsView()
            .environmentObject(BookmarkViewModel())
    }
}
