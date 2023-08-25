//
//  InternshipDetailView.swift
//  AucaPlus
//
//  Created by Cédric Bahirwe on 25/08/2023.
//

import SwiftUI

struct InternshipDetailView: View {
    let internship: Internship
    
    @EnvironmentObject private var bookmarkVM: BookmarkViewModel
    var body: some View {
        WebView(url: internship.link)
            .task {
                await bookmarkVM.view(internship: internship)
            }
    }
}

#if DEBUG
struct InternshipDetailView_Previews: PreviewProvider {
    static var previews: some View {
        InternshipDetailView(internship: .example)
            .environmentObject(BookmarkViewModel())
    }
}
#endif
