import Foundation

struct Conversation: Identifiable, Codable, Equatable {
    let id: UUID
    var title: String
    var messages: [Message]
    let createdAt: Date
    var updatedAt: Date

    init(id: UUID = UUID(), title: String? = nil, messages: [Message] = [], createdAt: Date = Date(), updatedAt: Date = Date()) {
        self.id = id
        self.title = title ?? Conversation.defaultTitle(from: messages)
        self.messages = messages
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }

    private static func defaultTitle(from messages: [Message]) -> String {
        guard let firstUserMessage = messages.first(where: { $0.sender == .user }) else {
            return "New Conversation"
        }
        let words = firstUserMessage.content.split(separator: " ").prefix(5)
        let title = words.joined(separator: " ")
        return title.isEmpty ? "New Conversation" : title
    }

    mutating func append(_ message: Message) {
        messages.append(message)
        updatedAt = Date()
        if title == "New Conversation" && message.sender == .user {
            title = Conversation.defaultTitle(from: messages)
        }
    }

    var totalTokens: Int {
        return messages.reduce(0) { $0 + $1.estimatedTokens }
    }

    static let maxStored = 20
}
