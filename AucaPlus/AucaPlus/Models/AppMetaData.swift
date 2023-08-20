//
//  AppMetaData.swift
//  AucaPlus
//
//  Created by Cédric Bahirwe on 20/08/2023.
//

import Foundation

enum AppMetaData {
    
    static var appVersion: String {
        return Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String
    }
    
    static var buildVersion: String {
        return Bundle.main.object(forInfoDictionaryKey: kCFBundleVersionKey as String) as! String
    }
    
    static var fullVersion: String {
        "\(appVersion) (\(buildVersion))"
    }
}

