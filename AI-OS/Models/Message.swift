import Foundation

enum Sender: String, Codable, Identifiable {
    case user
    case ai

    var id: String { rawValue }
}

struct Message: Identifiable, Codable, Equatable {
    let id: UUID
    let sender: Sender
    let content: String
    let timestamp: Date

    init(id: UUID = UUID(), sender: Sender, content: String, timestamp: Date = Date()) {
        self.id = id
        self.sender = sender
        self.content = content
        self.timestamp = timestamp
    }

    var estimatedTokens: Int {
        return Int(Double(content.count) / 4.0)
    }
}
