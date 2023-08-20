//
//  FormLabel.swift
//  AucaPlus
//
//  Created by Cédric Bahirwe on 20/08/2023.
//

import SwiftUI

struct FormLabel: View {
    
    enum LabelType {
        case `internal`
        case external
    }
    init(_ option: Option,
         type: FormLabel.LabelType = LabelType.`internal`,
         action: @escaping () -> Void) {
        self.item = option.getSettingsItem()
        self.type = type
        self.action = action
    }
    
    init(_ option: Option, type: FormLabel.LabelType = LabelType.`internal`) {
        self.item = option.getSettingsItem()
        self.type = type
        self.action = nil
    }
    
    private let item: LabelItem
    private var type: LabelType
    private let action: (() -> Void)?
    
    var body: some View {
        if let action = action {
            Button(action: action) { contentView }
        } else {
            contentView
        }
    }
    
    var contentView: some View {
        HStack(spacing: 0) {
            
            
            Label {
                VStack(alignment: .leading) {
                    Text(item.title)
                    
                    if let subtitle = item.subtitle {
                        Text(subtitle)
                            .font(.system(.subheadline, design: .rounded))
                            .foregroundColor(.secondary)
                    }
                }
                .multilineTextAlignment(.leading)
                .minimumScaleFactor(0.8)
            } icon: {
                item.icon?
                    .resizable()
                    .scaledToFit()
                    .padding(5)
                    .frame(width: 28, height: 28)
                    .background(item.color)
                    .cornerRadius(8)
                    .foregroundColor(.white)
            }
            
            Spacer(minLength: 1)
            
            if type == .external {
                Image(systemName: "arrow.up.forward")
                    .imageScale(.small)
                    .fontWeight(.semibold)
                    .foregroundColor(.secondary.opacity(0.5))
            }
        }
        .tint(.primary)
    }
}

//
//struct FormLabel_Previews: PreviewProvider {
//    static var previews: some View {
//        FormLabel()
//    }
//}
extension FormLabel {
    func asLink(_ url: URL) -> Link<FormLabel> {
        var item = self
        item.type = .external
        return Link(destination: url) { item }
    }
}

struct LabelItem: Identifiable {
    init(icon: String, color: Color, title: String, subtitle: String? = nil) {
        self.icon = Image(icon)
        self.color = color
        self.title = title
        self.subtitle = subtitle
    }
    
    init(sysIcon: String, color: Color, title: String, subtitle: String? = nil) {
        self.icon = Image(systemName: sysIcon)
        self.color = color
        self.title = title
        self.subtitle = subtitle
    }
    
    init(title: String, subtitle: String? = nil) {
        self.icon = nil
        self.color = nil
        self.title = title
        self.subtitle = subtitle
    }
    
    let id = UUID()
    let icon: Image?
    let color: Color?
    let title: String
    let subtitle: String?
}

extension FormLabel {
    enum Option {
        // Settings
        case account
        case posting
        case whatsapp
        case bookmarks
        case about
        case rating
        case appearance
        
        // About
        case website
        case twitter
        case tos
        case privacy
        
        func getSettingsItem() -> LabelItem {
            switch self {
                /// ---------- Settings View -----------
            case .account:
                return .init(sysIcon: "person.fill", color: .green.opacity(0.8), title: "Acccount Settings")
            case .posting:
                return .init(sysIcon: "paperplane.fill", color: .mint, title: "Post an internship or a job")
            case .whatsapp:
                return .init(icon: "whatsapp", color: .green, title: "WhatsApp Us 💬")
            case .bookmarks:
                return .init(sysIcon: "bookmark.fill", color: .indigo, title: "Bookmarks")
            case .about:
                return .init(sysIcon: "info.circle", color: .orange, title: "About Auca Plus")
            case .rating:
                return .init(sysIcon: "star.circle.fill", color: .yellow.opacity(0.9), title: "Rate this App")
            case .appearance:
                return .init(sysIcon: "moon.stars.fill", color: Color.accentColor, title: "Appearance")
            /// ---------- About View -----------
            case .website:
                return .init(sysIcon: "network", color: .green, title: "Website")
            case .twitter:
                return .init(icon: "twitter", color: Color("twitter"), title: "Twitter ")
            case .tos:
                return .init(title: "Terms of Service")
            case .privacy:
                return .init(title: "Privacy Policy")
            }
        }
    }
}
