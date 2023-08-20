//
//  SectionHeaderText.swift
//  AucaPlus
//
//  Created by Cédric Bahirwe on 20/08/2023.
//

import SwiftUI

struct SectionHeaderText: View {
    private let title: String
    
    init(_ title: String) {
        self.title = title
    }
    
    var body: some View {
        Text(title)
            .fontWeight(.semibold)
            .textCase(nil)
        
    }
}
//struct SectionHeaderText_Previews: PreviewProvider {
//    static var previews: some View {
//        SectionHeaderText()
//    }
//}
