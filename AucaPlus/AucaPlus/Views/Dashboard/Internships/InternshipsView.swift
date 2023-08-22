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
                            isBookmarked: bookmarksVM.isBookmarked(internship),
                            onBookmarked: {
                                bookmarksVM.toggleBookmarking(.init(type: .internship($0)))
                            }).padding(.horizontal)
                    }
                    
                    Divider()
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
                try? await internshipsVM.fetchInternships()
            }
            .task {
                await internshipsVM.isUserAuthenticated()
            }
            .frame(maxWidth: .infinity)
            .background(Color(.secondarySystemBackground), ignoresSafeAreaEdges: .all)
            .navigationTitle("Internships")
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    Button {
                        showBookmarks = true
                    } label: {
                        Image(systemName: "bookmark.circle")
                    }
                    
                    if internshipsVM.isAuthenticated {
                        Button("Create") {
                            Task {
                                try? await internshipsVM.createInternship()
                                try? await internshipsVM.fetchInternships()
                            }
                        }
                    }
                }
                
                if internshipsVM.isAuthenticated {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button("Sign Out") {
                            Task {
                                try? await internshipsVM.signOut()
                            }
                        }
                        
                    }
                } else {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button("Log In") {
                            Task {
                                try? await internshipsVM.signIn()
                                await internshipsVM.isUserAuthenticated()
                            }
                        }
                        
                    }
                }
            }
        }
    }
}
struct InternshipRowView: View {
    var internship: Internship
    var isBookmarked: Bool
    var onBookmarked: (Internship) -> Void
    
    var body: some View {
        VStack(alignment: .leading) {
            
            HStack(alignment: .top) {
                VStack(alignment: .leading) {
                    if let title = internship.title {
                        Text(title)
                            .fontWeight(.medium)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .foregroundColor(.primary)
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
                        var newValue = self.internship
                        if isBookmarked {
                            newValue.bookmarks -= 1
                        } else {
                            newValue.bookmarks += 1
                        }
                        onBookmarked(newValue)
                    }
            }
            
            HStack {
                
                Text(internship.source.name)
                    .underline()
                
                Divider()
                
                Text(internship.location)
                
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
                Text("Posted \(internship.postedDate.timeAgo)")
                    .foregroundColor(.secondary)
                
                if internship.views != 0 {
                    DotView()

                    Text("^[\(Int.random(in: 100...1_000)) \("view")](inflect: true)")
                }
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
