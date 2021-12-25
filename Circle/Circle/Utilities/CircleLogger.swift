//
//  CircleLogger.swift
//  Circle
//
//  Created by Djuro on 8/28/21.
//

import Foundation
import Logging

enum LogType: String {
    case error = "[🛑]"
    case info = "[ℹ️]"
    case debug = "[💬]"
    case warning = "[⚠️]"
    case fatal = "[🔥]"
    case success = "[✅]"
}

final class CircleLogger {
    
    // MARK: - Properties
    static var logger = Logger(label: "com.djuroalfirevic.Circle")
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
        
        switch type {
        case .error:
            logger.error(.init(stringLiteral: message))
        case .info:
            logger.info(.init(stringLiteral: message))
        case .debug:
            logger.debug(.init(stringLiteral: message))
        case .warning:
            logger.warning(.init(stringLiteral: message))
        case .fatal:
            logger.critical(.init(stringLiteral: message))
        case .success:
            logger.notice(.init(stringLiteral: message))
        }
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
        CircleLogger.log(message: "\(message): \(error)", type: .error)
        logger.error(.init(stringLiteral: message))
    }
    
    // MARK: - Private API
    private class func sourceFileName(filePath: String) -> String {
        let components = filePath.components(separatedBy: "/")
        return components.isEmpty ? "" : components.last!
    }
    
}

internal extension Date {
    func formatted() -> String {
        return CircleLogger.dateFormatter.string(from: self)
    }
}
