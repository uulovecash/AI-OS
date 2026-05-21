import Foundation

enum AIModel: String, Codable, CaseIterable, Identifiable {
    case gpt4o = "GPT-4o"
    case claude4 = "Claude 4"
    case gemini = "Gemini"

    var id: String { rawValue }

    var systemPrompt: String {
        switch self {
        case .gpt4o:
            return "You are GPT-4o, a helpful AI assistant by OpenAI."
        case .claude4:
            return "You are Claude 4, a helpful AI assistant by Anthropic."
        case .gemini:
            return "You are Gemini, a helpful AI assistant by Google."
        }
    }
}

class AppSettings: ObservableObject {
    static let shared = AppSettings()

    private let defaults = UserDefaults.standard

    private enum Keys {
        static let selectedModel = "selectedModel"
        static let soundEnabled = "soundEnabled"
        static let openAIKey = "openAIKey"
        static let anthropicKey = "anthropicKey"
        static let googleKey = "googleKey"
    }

    @Published var selectedModel: AIModel {
        didSet {
            defaults.set(selectedModel.rawValue, forKey: Keys.selectedModel)
        }
    }

    @Published var soundEnabled: Bool {
        didSet {
            defaults.set(soundEnabled, forKey: Keys.soundEnabled)
        }
    }

    var openAIKey: String {
        get { defaults.string(forKey: Keys.openAIKey) ?? "" }
        set { defaults.set(newValue, forKey: Keys.openAIKey) }
    }

    var anthropicKey: String {
        get { defaults.string(forKey: Keys.anthropicKey) ?? "" }
        set { defaults.set(newValue, forKey: Keys.anthropicKey) }
    }

    var googleKey: String {
        get { defaults.string(forKey: Keys.googleKey) ?? "" }
        set { defaults.set(newValue, forKey: Keys.googleKey) }
    }

    init() {
        let stored = defaults.string(forKey: Keys.selectedModel) ?? AIModel.gpt4o.rawValue
        self.selectedModel = AIModel(rawValue: stored) ?? .gpt4o
        self.soundEnabled = defaults.object(forKey: Keys.soundEnabled) as? Bool ?? true
    }

    func clearAllData() {
        ConversationStorage.shared.clearAll()
    }
}

class ConversationStorage {
    static let shared = ConversationStorage()

    private let defaults = UserDefaults.standard
    private let storageKey = "savedConversations"

    func save(_ conversations: [Conversation]) {
        let trimmed = Array(conversations.prefix(Conversation.maxStored))
        if let encoded = try? JSONEncoder().encode(trimmed) {
            defaults.set(encoded, forKey: storageKey)
        }
    }

    func load() -> [Conversation] {
        guard let data = defaults.data(forKey: storageKey),
              let decoded = try? JSONDecoder().decode([Conversation].self, from: data) else {
            return []
        }
        return decoded
    }

    func clearAll() {
        defaults.removeObject(forKey: storageKey)
    }
}
