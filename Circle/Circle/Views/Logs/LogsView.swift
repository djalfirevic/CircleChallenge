//
//  LogsView.swift
//  Circle
//
//  Created by Djuro on 12/25/21.
//

import SwiftUI
import PulseUI

struct LogsView: View {
    var body: some View {
        MainView(store: .default)
            .navigationBarTitle("", displayMode: .inline)
    }
}

struct LogsView_Previews: PreviewProvider {
    static var previews: some View {
        LogsView()
    }
}
