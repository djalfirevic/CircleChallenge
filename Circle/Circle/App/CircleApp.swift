//
//  CircleApp.swift
//  Circle
//
//  Created by Djuro on 8/28/21.
//

import SwiftUI
import Pulse
import Logging

@main
struct CircleApp: App {
    
    init() {
        LoggingSystem.bootstrap(PersistentLogHandler.init)
    }
    
    var body: some Scene {
        WindowGroup {
            HomeView(viewModel: HomeViewModel())
        }
    }
}
