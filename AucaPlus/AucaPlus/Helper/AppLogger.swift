//
//  AppLogger.swift
//  AucaPlus
//
//  Created by Cédric Bahirwe on 03/09/2023.
//

import Foundation
import os

typealias Log = AppLogger
final class AppLogger {
    private static let isDebugEnabled = false
    static let mainBundleID = Bundle.main.bundleIdentifier!
//    static let webapi = OSLog(subsystem: mainBundleID, category: "Web API")
//    static let authentication = OSLog(subsystem: mainBundleID, category: "Authentication")
//    static let config = OSLog(subsystem: mainBundleID, category: "App configuration")
//    static let userProfile = OSLog(subsystem: mainBundleID, category: "User profile")
    
    static func error(_ message: StaticString? = nil, _ error: Error) {
        debug("❌❌ Message: \(message ?? "-")\nError: ", error.localizedDescription)
    }
    
    static func add(_ message: StaticString, file: String = #file, dso: UnsafeRawPointer? = #dsohandle, log: OSLog = .default, type: OSLogType = .default, _ args: CVarArg...) {
        #if DEBUG

        if isDebugEnabled {
            os_log(message, dso: dso, log: log, type: type, args)
        }
        let filename = String(file.split(separator: "/").last ?? "")
        let formatter = getFormatter(format: "MM/dd/yyyy HH:mm")
        let logs: [String : Any] = [
            "date": formatter.string(from: Date()),
            "message": "\(message)",
            "args:": "\(args)",
            "file": filename
        ]
        
        DispatchQueue.global().sync {
            
            if let documentURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
                let filename = documentURL.appendingPathComponent("logs.txt")
                // create the file if needed
                if !FileManager.default.fileExists(atPath: filename.path) {
                    FileManager.default.createFile(atPath: filename.path, contents: nil, attributes: nil)
                }
                // add the log to the file
                do {
                    let input = try String(contentsOf: filename) + "\n" + logs.description
                    try input.description.write(to: filename, atomically: true, encoding: .utf8)
                } catch {
                    debug("Logger saving error: \(error.localizedDescription)")
                }
            }
        }
        #endif
    }
    
    /// only print during development
    static func debug(_ items: Any...) {
        #if DEBUG
        Swift.debugPrint(items)
        #endif
    }
    
    
    private static func getFormatter(format: String) -> DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        dateFormatter.timeZone = .current
        
        return dateFormatter
    }
}
