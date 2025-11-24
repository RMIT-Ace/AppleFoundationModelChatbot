//
//  ChatbotApp.swift
//  Chatbot
//
//  Created by Ace on 25/11/2025.
//

import SwiftUI

@main
struct ChatbotApp: App {
    private var vm = AppleFoundationModelViewModel()
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(vm)
        }
    }
}
