//
//  LinksPreviewModel.swift
//  AucaPlus
//
//  Created by Cédric Bahirwe on 23/08/2023.
//

import Foundation
import LinkPresentation


final class LinksPreviewModel: ObservableObject {
    var links = [LinkPreview]()
    private let linksPathComponent = "links"
    init() {
        
        loadAllLinks()
    }
    
    func getLinkPreview(for url: URL) async -> LinkPreview? {
        if let previewData = links.first(where: { $0.id == url.absoluteString }) {
            return previewData
        }
        
        let metadataProvider = LPMetadataProvider()
        do {
            let metadata = try await metadataProvider.startFetchingMetadata(for: url)

            return createLink(with: metadata, for: url.absoluteString)
        } catch {
            print("❌Error fetching metadata: \(error.localizedDescription)")
            return nil
        }
    }
    
    @discardableResult
    func createLink(with metadata: LPLinkMetadata, for urldID: String) -> LinkPreview {
        let link = LinkPreview()
        link.id = urldID
        link.metadata = metadata
        links.append(link)
        saveAllLinks()
        return link
    }

    private func saveAllLinks() {
        do {
            let data = try NSKeyedArchiver.archivedData(withRootObject: links, requiringSecureCoding: true)
            guard let docDirURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
            try data.write(to: docDirURL.appendingPathComponent(linksPathComponent))
            print("Saved Links at:", docDirURL.appendingPathComponent(linksPathComponent))
        } catch {
            print(error.localizedDescription)
        }
    }
    
    
    private func loadAllLinks() {
        guard let docDirURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
        let linksURL = docDirURL.appendingPathComponent(linksPathComponent)

        if FileManager.default.fileExists(atPath: linksURL.path) {
            do {
                let data = try Data(contentsOf: linksURL)
                guard let unarchived = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as? [LinkPreview] else { return }
                links = unarchived
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    private func removeSavedLinks() {
        do {
            guard let docDirURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
            let linksURL = docDirURL.appendingPathComponent(linksPathComponent)
            
            if FileManager.default.fileExists(atPath: linksURL.path) {
                try FileManager.default.removeItem(at: linksURL)
                print("Removed saved Links at:", linksURL)
            } else {
                print("No saved Links file found.")
            }
        } catch {
            print(error.localizedDescription)
        }
    }

    
    class func fetchMetadata(for url: URL) async throws -> LPLinkMetadata {
        let metadataProvider = LPMetadataProvider()
        let metadata  = try await metadataProvider.startFetchingMetadata(for: url)
        return metadata
    }
}


class LinkPreview: NSObject, NSSecureCoding, Identifiable {
    var id: String?
    var metadata: LPLinkMetadata?
    
    override init() {
        super.init()
    }
    
    
    // MARK: - NSSecureCoding Requirements
    
    static var supportsSecureCoding = true

    func encode(with coder: NSCoder) {
        guard let id = id, let metadata = metadata else { return }
        coder.encode(NSString(string: id), forKey: "id")
        coder.encode(metadata as NSObject, forKey: "metadata")
    }

    required init?(coder: NSCoder) {
        id = coder.decodeObject(of: NSString.self, forKey: "id") as? String
        metadata = coder.decodeObject(of: LPLinkMetadata.self, forKey: "metadata")
    }
}
