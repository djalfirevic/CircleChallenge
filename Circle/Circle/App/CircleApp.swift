//
//  CircleApp.swift
//  Circle
//
//  Created by Djuro on 8/28/21.
//

import SwiftUI

@main
struct CircleApp: App {
    var body: some Scene {
        WindowGroup {
            HomeView(viewModel: HomeViewModel())
        }
    }
}
