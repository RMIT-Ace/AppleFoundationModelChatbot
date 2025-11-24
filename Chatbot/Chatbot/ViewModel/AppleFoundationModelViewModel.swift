//
//  AppleFoundationModelViewModel.swift
//  AppleFoundataionStudy
//
//  Created by Ace on 24/11/2025.
//
import Foundation
import FoundationModels

@Observable
class AppleFoundationModelViewModel {
    
    var model = SystemLanguageModel()
    
    var instruction: String = ""
    
    var conversation: [PromptResponse] = []
    
    private var session: LanguageModelSession? = nil
    
    /// Start a new LanguageModelSession session with current instruction.
    func resetSession(with instruction: String) {
        session = LanguageModelSession(instructions: instruction)
        self.instruction = instruction
        self.conversation.removeAll()
    }
    
    func ask(prompt: String) async -> String? {
        guard let session = session, model.availability == .available else {
            print(">> WARN: Session or Model not available.")
            return nil
        }
        
        let response = try? await session.respond(to: prompt)
        conversation.append(PromptResponse(prompt: prompt, response: response?.content))
        return response?.content
    }
}
