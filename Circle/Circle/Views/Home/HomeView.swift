//
//  HomeView.swift
//  Circle
//
//  Created by Djuro on 8/28/21.
//

import SwiftUI

struct HomeView: View {
    @ObservedObject var viewModel: HomeViewModel
    @State private var searchText = ""
    @State private var showLogs = false
    
    var body: some View {
        NavigationView {
            VStack {
                SearchView(text: $searchText) {
                    self.viewModel.fetchItems(for: searchText)
                    UIApplication.shared.endEditing()
                }

                List {
                    ForEach(viewModel.items) { user in
                        UserRow(user: user)
                    }
                    
                    if viewModel.hasMoreData {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle())
                            .onAppear {
                                self.viewModel.fetchItems(for: searchText)
                            }
                    }
                }.refreshable {
                    self.viewModel.refresh()
                }
            }
            .navigationBarTitle(Text("Circle"))
            .toolbar {
                ToolbarItem(placement: .navigation) {
                    Button("Logs") {
                        showLogs = true
                    }
                }
            }
            .sheet(isPresented: $showLogs) {
                LogsView()
            }
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView(viewModel: HomeViewModel())
    }
}
