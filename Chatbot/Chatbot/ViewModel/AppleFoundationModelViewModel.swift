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
    
    /// The number of tokens used during the current session.
    var tokenCount: Int = 0
    
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
        
        do {
            let response = try? await session.respond(to: prompt)
            let responseContent = response?.content ?? ""
            let tokenPattern = "\\[token: (\\d+)\\]"
            let regex = try NSRegularExpression(pattern: tokenPattern, options: [])
            let formattedResponse = regex.stringByReplacingMatches(
                in: responseContent,
                options: [],
                range: NSRange(location: 0, length: (responseContent.count)),
                withTemplate: ""
            )
            conversation.append(PromptResponse(prompt: prompt, response: formattedResponse))
            await updateTokenCount(response: responseContent)
            return response?.content
        } catch {
            print(">> ERRONR: \(error.localizedDescription)")
        }
        return nil
    }
    
    /// Calculate and update tokenCount for prompts and responses in the current session.
    private func updateTokenCount(response: String) async {
        let tokenRegex = /\[token: (\d+)\]/
        if let match = response.firstMatch(of: tokenRegex) {
            let (_, tokenCount) = match.output
            self.tokenCount = Int(tokenCount) ?? 0
        }
    }
}
