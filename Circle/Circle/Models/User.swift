//
//  User.swift
//  Circle
//
//  Created by Djuro on 8/28/21.
//

import Foundation

struct User: Codable, Identifiable {
    
    // MARK: - Properties
    var id: Int
    let login: String
    let avatarUrl: String
    
}
