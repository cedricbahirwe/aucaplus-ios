//
//  FeedItem+Preview.swift
//  AucaPlus
//
//  Created by Cédric Bahirwe on 26/08/2023.
//

import Foundation

#if DEBUG
extension News {
    static let news1 = News(
        id: 123,
        title: "Example news",
        userID: UUID(),
        source: FeedSource.person,
        postedDate: .now,
        content: News.description1,
        images: [URL(string: "https://example.com/image2.jpg")!],
        tags: ["football", "league", "fun"],
        views: 100
    )
    
    static var description1: AttributedString = {
        var str = AttributedString("@Bridge2Rwanda")
        str.link = URL(string: "https://github.com/aucaplus")
        str.foregroundColor = .accentColor
        
        return "Today, AUCA & " + str + "'s Bridge Talent Services, signed a MoU in areas of career devpt for students/graduates. The partnership will enhance education-to-employment approach, thus enabling students to learn, apply skills to build career mobility via job readiness workshops."
    }()
    
    static var description2: AttributedString = {
        var str = AttributedString("@ASOMEHealth")
        str.link = URL(string: "https://twitter.com/ASOMEHealth")
        str.foregroundColor = .red
       
        return "VC Prof Kelvin Onongha hands over a token of appreciation to Dr Zeno L. Charles-Marcel.  Zeno is the Assoc. Director of Adventist Health Ministry at the Headquarters of the SDA World Church. He has been very instrumental in the establishment of AUCA's Medical School " + str
    }()
}

extension RemoteResource {
    static let example  = RemoteResource(id: 3121,
                                         title: "Remote Resourece",
                                         userID: UUID(),
                                         link: URL(string: "https://example.com/remote-resource")!,
                                         source: .person,
                                         postedDate: .now,
                                         content: .example)
}

extension Announcement {
    static let example = Announcement(title: "Exams timetable is updated",
                                      userID: UUID(), source: .person,
                                      postedDate: .now,
                                      content: AttributedString())
}


extension RemoteResource.Metadata {
    static let example = Self.init(type: .pdf,
                                   size: 1024,
                                   owner: "John Doe")
}

extension FeedItem {
    func replicate(_ count: Int) -> [Self] {
        guard count > 1 else { return [self] }
        
        let newItems = (0..<count-1).map { i in
            var item = self
            item.id = i
            return item
        }
        return [self] + newItems
    }
}

extension FeedSource {
    static let person = FeedSource(name: "Jane Do", profile: URL(string: "https://placehold.co/100"))
}
#endif

