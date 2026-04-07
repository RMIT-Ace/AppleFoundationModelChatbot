//
//  ConversationView.swift
//  AppleFoundataionStudy
//
//  Created by Ace on 24/11/2025.
//

import SwiftUI

struct ConversationView: View {
    @Environment(AppleFoundationModelViewModel.self) var vm
    
    @State private var prompt: String = ""
    @FocusState private var isTextFieldFocused: Bool
    @State private var textEditorHeight: CGFloat = 42

    var body: some View {
        NavigationStack {
            ScrollViewReader { scrollReader in
                ZStack {
                    ScrollView {
                        ForEach(vm.conversation, id: \.self) { conversation in
                            VStack(alignment: .leading) {
                                HStack {
                                    Text(conversation.prompt)
                                        .padding()
                                        .background(
                                            RoundedRectangle(cornerRadius: 10)
                                                .fill(.blue.opacity(0.2)))
                                        .padding(.bottom, 8)
                                        .padding(.trailing, 8)
                                    Spacer()
                                }
                                .frame(maxWidth: .infinity)
                                HStack {
                                    Spacer()
                                    Text(conversation.response ?? "???")
                                        .padding()
                                        .background(
                                            RoundedRectangle(cornerRadius: 10)
                                                .fill(.green.opacity(0.2)))
                                        .padding(.bottom, 8)
                                        .padding(.leading, 8)
                                }
                                .frame(maxWidth: .infinity)
                            }
                            .frame(maxWidth: .infinity)
                        }
                        Text(" ")
                            .id("Bottom")
                    }
                    .padding()
                    .navigationTitle(Text("Conversation"))
#if os(iOS)
                    .navigationBarTitleDisplayMode(.inline)
#endif
                    .toolbar {
#if os(iOS)
                        let placement = ToolbarItemPlacement.topBarTrailing
#else
                        let placement = ToolbarItemPlacement.automatic
#endif
                        ToolbarItem(placement: placement) {
                            Button {
                                vm.resetSession()
                            } label: {
                                Image(systemName: "xmark.bin")
                            }
                        }
                    }
                    .onChange(of: vm.conversation.count) { oldValue, newValue in
                        withAnimation(.easeInOut(duration: 1.0)) {
                            scrollReader.scrollTo("Bottom", anchor: .bottom)
                        }
                    }
                }
                
                VStack {
                    HStack {
                        ZStack(alignment: .topLeading) {
                            if prompt.isEmpty {
                                Text("What's up?")
                                    .foregroundColor(.secondary)
                                    .padding(.horizontal, 8)
                                    .padding(.top, 16)
                                    .allowsHitTesting(false)
                            }
                            
                            TextEditor(text: $prompt)
                                .focused($isTextFieldFocused)
                                .frame(height: max(42, min(textEditorHeight, 200)))
                                .scrollContentBackground(.hidden)
                                .padding(.horizontal, 4)
                                .padding(.top, 8)
                                .overlay(
                                    // Hidden text to measure actual rendered height including wrapping
                                    GeometryReader { outerGeometry in
                                        Text(prompt.isEmpty ? " " : prompt)
                                            .font(.body)
                                            .padding(.horizontal, 8)
                                            .padding(.vertical, 8)
                                            .frame(width: outerGeometry.size.width, alignment: .leading)
                                            .fixedSize(horizontal: false, vertical: true)
                                            .background(
                                                GeometryReader { geometry in
                                                    Color.clear.preference(
                                                        key: TextHeightPreferenceKey.self,
                                                        value: geometry.size.height
                                                    )
                                                }
                                            )
                                            .opacity(0)
                                    }
                                )
                        }
                        .background(editorBackground)
                        .onPreferenceChange(TextHeightPreferenceKey.self) { height in
                            textEditorHeight = height
                        }
                        
                        Button {
                            submitPrompt()
                        } label: {
                            Image(systemName: "paperplane.fill")
                                .foregroundColor(.blue)
                                .padding(10)
                        }
                        .keyboardShortcut(.return, modifiers: .command)
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 10)
#if os(iOS)
                    .background(
                        Color(UIColor.systemBackground)
                            .ignoresSafeArea(edges: .bottom)
                        
                    )
#endif
                }
            }
        }
    }
    
    private func submitPrompt() {
        guard !prompt.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return }
        let currentPrompt = prompt
        prompt = ""
        isTextFieldFocused = false
        Task {
            _ = await vm.ask(prompt: currentPrompt)
        }
    }
    
    private var editorBackground: some View {
        RoundedRectangle(cornerRadius: 8)
#if os(macOS)
            .fill(Color(nsColor: .controlBackgroundColor))
#else
            .fill(Color(.systemBackground))
#endif
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color.secondary.opacity(0.2), lineWidth: 1)
            )
    }
}

struct TextHeightPreferenceKey: PreferenceKey {
    static var defaultValue: CGFloat = 42
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}

#Preview {
    let vm = AppleFoundationModelViewModel()
    vm.conversation = [
        PromptResponse(prompt: "Hello", response: "This is a response"),
        PromptResponse(
            prompt: "How are you?",
            response: "This is a very very long response which contains a long giberish string that will make the text long and unwieldy and so it will be easier to test the layout code. Yet, there are still more text coming out as if it cannot be stopped entirely."
        ),
        PromptResponse(prompt: "1 + 2 = ?", response: "3"),
    ]
    return NavigationStack {
        ConversationView()
            .frame(width: 400)
            .environment(vm)
    }
}
