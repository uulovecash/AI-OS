import Foundation
import Combine

@MainActor
class ChatViewModel: ObservableObject {
    @Published var currentConversation: Conversation = Conversation()
    @Published var conversations: [Conversation] = []
    @Published var inputText: String = ""
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    @Published var showSettings: Bool = false

    private let settings = AppSettings.shared
    private let storage = ConversationStorage.shared

    init() {
        loadConversations()
    }

    var canSend: Bool {
        !inputText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty && !isLoading
    }

    var totalTokens: Int {
        currentConversation.totalTokens
    }

    func sendMessage() {
        guard canSend else { return }

        let content = inputText.trimmingCharacters(in: .whitespacesAndNewlines)
        inputText = ""
        errorMessage = nil

        let userMessage = Message(sender: .user, content: content)
        currentConversation.append(userMessage)

        isLoading = true

        Task {
            try? await Task.sleep(nanoseconds: 800_000_000)
            let aiResponse = Message(
                sender: .ai,
                content: generateStubResponse(for: content, model: settings.selectedModel)
            )
            currentConversation.append(aiResponse)
            isLoading = false
            saveCurrentConversation()
        }
    }

    func loadConversation(_ conversation: Conversation) {
        saveCurrentConversation()
        currentConversation = conversation
    }

    func startNewConversation() {
        saveCurrentConversation()
        currentConversation = Conversation()
    }

    func clearAllConversations() {
        conversations = []
        currentConversation = Conversation()
        storage.clearAll()
    }

    func clearCurrentConversation() {
        currentConversation = Conversation()
        saveCurrentConversation()
    }

    private func generateStubResponse(for input: String, model: AIModel) -> String {
        let responses: [String]
        switch model {
        case .gpt4o:
            responses = [
                "Based on your query about \"\(input.prefix(30))...\", here are some thoughts: GPT-4o is great at reasoning, creativity, and detailed explanations. How can I help further?",
                "I understand you're asking about \"\(input.prefix(40))...\" — as GPT-4o, I'd approach this by breaking it down into clear steps. What specific aspect would you like to explore?",
                "Great question! \"\(input.prefix(30))...\" touches on several interesting areas. Let me provide a structured response that covers the key points."
            ]
        case .claude4:
            responses = [
                "I appreciate your question about \"\(input.prefix(30))...\" — as Claude 4, I can offer a thoughtful, nuanced perspective. Here are my thoughts:\n\nClaude 4 emphasizes careful reasoning and helpfulness.",
                "Your query \"\(input.prefix(40))...\" is interesting! As Claude 4, I'd analyze this by considering multiple viewpoints and providing a balanced, thorough response.",
                "Thanks for asking about \"\(input.prefix(30))...\" — Claude 4 here, ready to help! I'd break this down step by step to give you the clearest answer possible."
            ]
        case .gemini:
            responses = [
                "Looking at \"\(input.prefix(30))...\" from multiple angles, Gemini brings strong multimodal reasoning to provide you with a comprehensive answer.",
                "Your question \"\(input.prefix(40))...\" is something I can help with! Gemini excels at connecting information across different domains.",
                "Great topic: \"\(input.prefix(30))...\" — as Gemini, I can draw on Google's extensive knowledge base to give you an informed, up-to-date response."
            ]
        }

        let index = abs(input.hashValue) % responses.count
        return responses[index]
    }

    private func saveCurrentConversation() {
        if !currentConversation.messages.isEmpty {
            var all = conversations.filter { $0.id != currentConversation.id }
            all.insert(currentConversation, at: 0)
            conversations = Array(all.prefix(Conversation.maxStored))
            storage.save(conversations)
        }
    }

    private func loadConversations() {
        conversations = storage.load()
    }
}
