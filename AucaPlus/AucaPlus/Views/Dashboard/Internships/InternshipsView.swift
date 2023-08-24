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

    var body: some View {
        NavigationStack {
            ScrollView(showsIndicators: false) {
                
                ForEach(internshipsVM.sortedInternships) { internship in
                    NavigationLink(value: internship) {
                        InternshipRowView(
                            internship: internship,
                            isBookmarked: bookmarksVM.isBookmarked(internship),
                            onBookmarked: {
                                bookmarksVM.toggleBookmarking(.init(type: .internship($0)))
                            }).padding(.horizontal)
                    }
                    
                    Divider()
                        .frame(height: 0.65)
                        .overlay(.gray)
                }
                
                if internshipsVM.sortedInternships.count > 10 {
                    CaughtUpView("You're all caught up🎉", "You've seen all recent internships.")
                }
            }
            .navigationDestination(for: Internship.self) { internship in
                WebView(url: internship.link)
            }
            .navigationDestination(isPresented: $showBookmarks, destination: {
                BookmarksView()
            })
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
