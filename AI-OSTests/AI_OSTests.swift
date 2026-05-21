import XCTest
@testable import AI_OS

final class AI_OSTests: XCTestCase {
    func testMessageEstimatedTokens() {
        let message = Message(sender: .user, content: "Hello world!")
        XCTAssertEqual(message.estimatedTokens, 3)
    }

    func testConversationDefaultTitle() {
        let messages = [
            Message(sender: .user, content: "What is the weather like today?")
        ]
        let conversation = Conversation(messages: messages)
        XCTAssertEqual(conversation.title, "What is the weather like today?")
    }

    func testConversationDefaultTitleShort() {
        let messages = [
            Message(sender: .user, content: "Hello")
        ]
        let conversation = Conversation(messages: messages)
        XCTAssertEqual(conversation.title, "Hello")
    }

    func testConversationTotalTokens() {
        let messages = [
            Message(sender: .user, content: "Hello"),
            Message(sender: .ai, content: "Hello! How can I")
        ]
        let conversation = Conversation(messages: messages)
        XCTAssertEqual(conversation.totalTokens, 5)
    }

    func testAIModelSystemPrompts() {
        XCTAssertFalse(AIModel.gpt4o.systemPrompt.isEmpty)
        XCTAssertFalse(AIModel.claude4.systemPrompt.isEmpty)
        XCTAssertFalse(AIModel.gemini.systemPrompt.isEmpty)
    }
}
