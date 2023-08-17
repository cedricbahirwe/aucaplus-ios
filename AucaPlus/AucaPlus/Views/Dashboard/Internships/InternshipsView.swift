//
//  InternshipsView.swift
//  AucaPlus
//
//  Created by Cédric Bahirwe on 17/08/2023.
//

import SwiftUI

struct InternshipsView: View {
    @StateObject private var internshipsVM = InternshipsViewModel()
    @EnvironmentObject private var bookmarksVM: BookmarkViewModel
        
    @State var showBookmarks = false
    var body: some View {
        NavigationStack {
            ScrollView(showsIndicators: false) {
                ForEach(internshipsVM.sortedInternships) { internship in
                    NavigationLink(value: internship) {
                        InternshipRowView(
                            internship: internship,
                            isBookmarked: bookmarksVM.isBookmarked(internship), onBookmarked: {
                                if bookmarksVM.isBookmarked(internship) {
                                    bookmarksVM.removeBookmark(.init(type: .internship(internship)))
                                } else {
                                    bookmarksVM.addNewBookmark(.init(type: .internship(internship)))
                                }
                            }).padding(.horizontal)
                    }
                    
                    Divider()
                }
                
                CaughtUpView("You're all caught up🎉", "You've seen all recent internships.")
            }
            .navigationDestination(for: Internship.self) { internship in
                WebView(url: internship.link.url)
            }
            .navigationDestination(isPresented: $showBookmarks, destination: {
                BookmarksView()
            })
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
    }
}
struct InternshipRowView: View {
    var internship: Internship
    var isBookmarked: Bool
    var onBookmarked: () -> Void
    
    var body: some View {
        VStack(alignment: .leading) {
            
            HStack(alignment: .top) {
                VStack(alignment: .leading) {
                    if let title = internship.title {
                        Text(title)
                            .fontWeight(.medium)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    
                    if let description = internship.description {
                        Text(description)
                            .font(.callout)
                            .fontWeight(.light)
                            .foregroundColor(.primary)
                            .opacity(0.9)
                            .multilineTextAlignment(.leading)
                            .lineLimit(3)
                            .layoutPriority(3)
                    }
                }
                
                Image(systemName: isBookmarked ? "bookmark.fill" : "bookmark")
                    .onTapGesture {
                        onBookmarked()
                    }
            }
            
            HStack {
                
                Text(internship.source.name)
                    .underline()
                
                Divider()
                
                Text(internship.location.city)
                
                DotView()
                
                
                HStack(spacing: 2) {
                    if internship.verified {
                        Image("verify")
                    }
                    
                    Text(internship.verified ? "Verified" : "Not verified")
                        .foregroundColor(internship.verified ? .green : nil)
                }
            }
            .foregroundColor(.secondary)
            .font(.callout)
            
            HStack {
                Text("Posted: \(internship.postedDate.timeAgo)")
                    .foregroundColor(.secondary)
            }
            .font(.callout)
        }
    }
}
struct InternshipsView_Previews: PreviewProvider {
    static var previews: some View {
        InternshipsView()
    }
}
