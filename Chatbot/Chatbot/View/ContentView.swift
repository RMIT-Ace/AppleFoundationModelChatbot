//
//  ContentView.swift
//  AppleFoundataionStudy
//
//  Created by Ace on 24/11/2025.
//

import SwiftUI
import FoundationModels

struct ContentView: View {
    @Environment(AppleFoundationModelViewModel.self) var vm
    @State private var searchText: String = ""
    var body: some View {
        TabView {
            Tab("Home", systemImage: "house") {
                InstructionView()
            }
            
            Tab("Conversation", systemImage: "finder") {
                ConversationView()
            }
            Tab(role: .search) {
                NavigationStack {
                    Text("TBD Search: \(searchText)")
                }
            }
        }
        .searchable(text: $searchText)
    }
}

#Preview {
    let vm = AppleFoundationModelViewModel()
    ContentView()
        .environment(vm)
}
