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
        content: News.description3,
        files: [URL(string: "https://example.com/image2.jpg")!],
        fileType: .image,
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
    
    static var description3: AttributedString = {
        var str = AttributedString(" https://dr0krcbe81m.typeform.com/to/YxTXmLWR")
        str.link = URL(string: "https://dr0krcbe81m.typeform.com/to/YxTXmLWR")
        str.foregroundColor = .accentColor
        
        return """
To kickstart 2024, we are excited to share a fantastic opportunity with you. CODEXTREME, with the support from GIZ, ALU, CcHub, and many more presents the largest and most disruptive student hackathon happening for 4 days in Kigali from January 24th to 27th, 2024, at the African Leadership University.

This event provides an invaluable opportunity for 200+ student developers, junior developers, tech enthusiasts, and student entrepreneurs in Kigali to come together for 4 days to learn, collaborate, and create innovative tech solutions to real-world problems.

There will be 5000$ worth of prizes, including 2500$ in cash and a mentorship program for winning teams after the hackathon.

Register your interest now and embark on a journey full of creativity and innovation. We believe your work and contribution will positively impact Rwanda's tech ecosystem and beyond.

For registration, fill out this form, and our team will follow up with you:
""" + str
    }()
}

//extension RemoteResource {
//    static let example  = RemoteResource(id: 3121,
//                                         title: "Remote Resourece",
//                                         userID: UUID(),
//                                         link: URL(string: "https://example.com/remote-resource")!,
//                                         source: .person,
//                                         postedDate: .now,
//                                         content: .example)
//}


//extension RemoteResource.Metadata {
//    static let example = .init(type: .pdf,
//                                   size: 1024,
//                                   owner: "John Doe")
//}
//extension Announcement {
//    static let example = Announcement(title: "Exams timetable is updated",
//                                      userID: UUID(), source: .person,
//                                      postedDate: .now,
//                                      content: AttributedString())
//}

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

