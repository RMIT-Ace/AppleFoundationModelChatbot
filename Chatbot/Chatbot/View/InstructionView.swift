//
//  InstructionView.swift
//  AppleFoundataionStudy
//
//  Created by Ace on 24/11/2025.
//

import SwiftUI
import FoundationModels

struct InstructionView: View {
    @Environment(AppleFoundationModelViewModel.self) var vm
    @State private var instruction: String = ""
    @FocusState private var isTextFieldFocused: Bool
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Model availability: \(String(describing: vm.model.availability))")
            Text("Instructions:")
            TextField("Enter instruction", text: $instruction, axis: .vertical)
                .focused($isTextFieldFocused)
                .lineLimit(3...5)
                .multilineTextAlignment(.leading)
            Button {
                vm.resetSession(with: instruction)
                isTextFieldFocused = false
            } label: {
                Text("Start New Session")
            }
        }
        .padding()
        .onAppear {
            instruction = vm.instruction
        }
    }
}

#Preview {
    let vm = AppleFoundationModelViewModel()
    InstructionView()
        .environment(vm)
}
