//
//  Logger.swift
//  Circle
//
//  Created by Djuro on 8/28/21.
//

import Foundation

enum LogType: String {
    case error = "[🛑]"
    case info = "[ℹ️]"
    case debug = "[💬]"
    case warning = "[⚠️]"
    case fatal = "[🔥]"
    case success = "[✅]"
}

final class Logger {
    
    // MARK: - Properties
    static var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        formatter.locale = .current
        formatter.timeZone = .current
        
        return formatter
    }
    
    // MARK: - Public API
    class func log(message: String,
                   type: LogType,
                   fileName: String = #file,
                   line: Int = #line,
                   column: Int = #column,
                   function: String = #function) {
        
        #if DEBUG
        print("\(Date().formatted()) \(type.rawValue)[\(sourceFileName(filePath: fileName))]: line: \(line), column: \(column) func: \(function) -> \(message)")
        #endif
    }
    
    class func log<T: Codable>(_ object: T) {
        let data = try! JSONEncoder().encode(object)
        let json = String(data: data, encoding: .utf8)
        
        #if DEBUG
        print("JSON: \(json ?? "")")
        #endif
    }
    
    class func logError(message: String, error: Error) {
        Logger.log(message: "\(message): \(error)", type: .error)
    }
    
    // MARK: - Private API
    private class func sourceFileName(filePath: String) -> String {
        let components = filePath.components(separatedBy: "/")
        return components.isEmpty ? "" : components.last!
    }
    
}

internal extension Date {
    func formatted() -> String {
        return Logger.dateFormatter.string(from: self)
    }
}
