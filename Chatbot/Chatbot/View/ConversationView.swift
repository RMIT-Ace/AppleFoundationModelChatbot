//
//  ConversationView.swift
//  AppleFoundataionStudy
//
//  Created by Ace on 24/11/2025.
//

import SwiftUI

struct ConversationView: View {
    @Environment(AppleFoundationModelViewModel.self) var vm
    
    @State private var isShowingPromptSheet: Bool = false
    @State private var prompt: String = ""
    @State private var response: String = ""
    @FocusState private var isTextFieldFocused: Bool

    var body: some View {
        NavigationStack {
            ScrollViewReader { scrollReader in
                ScrollView {
                    ForEach(vm.conversation, id: \.self) { conversation in
                        VStack(alignment: .leading) {
                            VStack(alignment: .leading) {
                                Text(conversation.prompt)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .padding()
                                    .background(.blue)
                                    .padding(.bottom, 8)
                                    .padding(.trailing, 8)
                            }
                            .frame(maxWidth: .infinity)
                            VStack(alignment: .trailing) {
                                Text(conversation.response ?? "???")
                                    .frame(maxWidth: .infinity, alignment: .trailing)
                                    .padding()
                                    .background(.green)
                                    .padding(.bottom, 12)
                                    .padding(.leading, 8)
                            }
                            .frame(maxWidth: .infinity)
                        }
                        .frame(maxWidth: .infinity)
                        .border(.red)
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
                    let placement = ToolbarItemPlacement.trailing
#else
                    let placement = ToolbarItemPlacement.automatic
#endif
                    ToolbarItem(placement: placement) {
                        Button {
                            isTextFieldFocused = true
                            isShowingPromptSheet = true
                        } label: {
                            Image(systemName: "plus")
                        }
                    }
                }
                .onChange(of: vm.conversation.count) { oldValue, newValue in
                    scrollReader.scrollTo("Bottom", anchor: .bottom)
                }
            }
        }
        .sheet(isPresented: $isShowingPromptSheet) {
            VStack(alignment: .leading) {
                Text("Prompt")
                TextField("Enter prompt", text: $prompt)
                    .focused($isTextFieldFocused)
                    .submitLabel(.go)
                    .onSubmit {
                        Task {
                            response = await vm.ask(prompt: prompt) ?? "???"
                            isShowingPromptSheet = false
                            prompt = ""
                        }
                    }
                    .onAppear {
                        isTextFieldFocused = true
                    }
                HStack {
                    Button(role: .cancel) {
                        isShowingPromptSheet = false
                    } label: {
                        Text("Cancel")
                    }
                }
            }
            .padding(20)
            .presentationDetents([.height(200)])
        }
    }
    
}

#Preview {
    let vm = AppleFoundationModelViewModel()
    NavigationStack {
        ConversationView()
            .environment(vm)
    }
}
