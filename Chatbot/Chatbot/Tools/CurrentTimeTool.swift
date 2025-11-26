//
//  CurrentTimeTool.swift
//  Chatbot
//
//  Created by Ace on 26/11/2025.
//

import Foundation
import FoundationModels

struct CurrentTimeTool: Tool {
    let name = "getCurrentTime"
    let description = "Get the current time of the day."
    
    @Generable
    struct Arguments {
        @Guide(description: "The current time of the day.")
        var currentTime: String
    }
    
    func call(arguments: Arguments) async throws -> String {
        let now = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: now)
    }
}
