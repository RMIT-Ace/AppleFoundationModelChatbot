//
//  CurrentDateTool.swift
//  Chatbot
//
//  Created by Ace on 26/11/2025.
//

import Foundation
import FoundationModels

struct CurrentDateTool: Tool {
    let name = "getCurrentDate"
    let description = "Get the current date."
    
    @Generable
    struct Arguments {
        @Guide(description: "The current date.")
        var currentTime: String
    }
    
    func call(arguments: Arguments) async throws -> String {
        let now = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: now)
    }
}
