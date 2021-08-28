//
//  LogBuilder.swift
//  Circle
//
//  Created by Djuro on 8/28/21.
//

import Foundation

enum LogBuilderOutputSeparator: String {
    case newline = "\n"
    case comma = ","
}

final class LogBuilder {
    
    // MARK: - Properties
    private var log = [String]()
    
    // MARK: - Public API
    func append(_ string: String) {
        log.append(string)
    }
    
    func build(with separator: LogBuilderOutputSeparator = .newline) -> String {
        switch separator {
        case .comma:
            append("\n")
            return log.joined(separator: separator.rawValue)
        default:
            return log.joined(separator: separator.rawValue)
        }
    }
    
}
