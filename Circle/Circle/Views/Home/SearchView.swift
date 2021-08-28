//
//  SearchView.swift
//  Circle
//
//  Created by Djuro on 8/28/21.
//

import SwiftUI

struct SearchView: View {
    @Binding var text: String
    @State var action: () -> Void

    var body: some View {
        ZStack {
            Color.black.opacity(0.05)
            
            HStack {
                Image(systemName: "magnifyingglass")
                
                TextField("Search Users", text: $text)
                    .padding(.horizontal, 8)
                    .frame(height: 44)
                    .cornerRadius(8)

                Button(action: action, label: { Text("Search") } )
                    .foregroundColor(Color.blue)
                    .disabled(text.isEmpty)
            }
            .padding(.horizontal, 16)
        }
        .frame(height: 64)
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView(text: .constant("Search"), action: {})
    }
}
