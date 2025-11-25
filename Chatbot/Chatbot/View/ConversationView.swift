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
                                        .padding(.bottom, 12)
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
                    
                    //-- Top layer
                    VStack {
                        HStack {
                            Spacer()
                            Text("Token: \(vm.tokenCount)")
                                .padding(.trailing)
                        }
                        Spacer()
                    }
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
