//
//  SendToChatbotIntent.swift
//  Chatbot
//
//  Created by Ace on 9/3/2026.
//

import SwiftUI
import AppIntents

struct SendToChatbotIntent: AppIntent {

    static let title: LocalizedStringResource = "Send to Chatbot"
    
    static let description = IntentDescription("Testing")
    
    static let openAppWhenRun: Bool = false
    
    @Parameter(title: "To Chatbot", requestValueDialog: "What to send?")
    var target: String

    @Parameter(title: "Context", requestValueDialog: "Provide context (optional)")
    var context: String
    
    @MainActor
    func perform() async throws -> some IntentResult & ReturnsValue<String> {
        if context == "NewConversation" {
            AppleFoundationModelViewModel.shared.resetSession()
        }
        let combinedPrompt = context.isEmpty ? target : "\(target)\nContext: \(context)"
        let answer = await AppleFoundationModelViewModel.shared.ask(prompt: combinedPrompt) ?? "No response"
        return .result(value: answer)
    }
}

