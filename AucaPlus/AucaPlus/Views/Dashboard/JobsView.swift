//
//  JobsView.swift
//  AucaPlus
//
//  Created by Cédric Bahirwe on 02/04/2023.
//

import SwiftUI

struct JobsView: View {
    var body: some View {
        NavigationStack {
            ScrollView {
                ForEach(0..<10, id: \.self) { i in
                    JobRowView()
                        .padding()
                }
            }
            .background(Color(.secondarySystemBackground), ignoresSafeAreaEdges: .all)
            .navigationTitle("Opportunities")
        }
    }
}

extension JobsView  {
    struct JobRowView: View {
        var body: some View {
            VStack(alignment: .leading) {
               
                HStackLayout(alignment: .top) {
                    Text("Investor Relations Intern")
                        .font(.callout)
                        .fontWeight(.medium)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    Image(systemName: "bookmark")
                }
                
                
                Text("One Acre Fund")
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                
                Text("Posted: \("06/04/2023")")
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                HStack(spacing: 2) {
                    Image("verify")
                    Text("Verified")
                }
                .font(.caption)
                .foregroundColor(.green)
                //                Text("Kigali, Kigali City, Rwanda (On-site")
                //                Text("**JOB POSITION AT RWANDA REVENUE AUTHORITY🇷🇼**\n\nThe Rwanda Revenue Authority has begin its 2023/2024 staff recuritment\n\nInterested Applicants Must Have Educational Qualification.\n\n**Apply Here**\n\(Text("https://bit.ly/RRA-Recruitment-2023"))")
            }
        }
    }
}

#if DEBUG
struct JobsView_Previews: PreviewProvider {
    static var previews: some View {
        JobsView()
            .preferredColorScheme(.dark)
    }
}
#endif
