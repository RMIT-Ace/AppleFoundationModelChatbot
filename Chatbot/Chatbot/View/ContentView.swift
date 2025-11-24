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
    var body: some View {
        TabView {
            InstructionView()
                .tabItem {
                    Label("Home", systemImage: "house")
                }
            
            ConversationView()
                .tabItem {
                    Label("Conversation", systemImage: "finder")
                }
        }
    }
}

#Preview {
    let vm = AppleFoundationModelViewModel()
    ContentView()
        .environment(vm)
}
