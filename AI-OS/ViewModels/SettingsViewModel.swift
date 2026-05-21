import Foundation
import Combine

class SettingsViewModel: ObservableObject {
    @Published var openAIKey: String
    @Published var anthropicKey: String
    @Published var googleKey: String
    @Published var soundEnabled: Bool

    private let settings = AppSettings.shared

    init() {
        self.openAIKey = settings.openAIKey
        self.anthropicKey = settings.anthropicKey
        self.googleKey = settings.googleKey
        self.soundEnabled = settings.soundEnabled
    }

    func saveKeys() {
        settings.openAIKey = openAIKey
        settings.anthropicKey = anthropicKey
        settings.googleKey = googleKey
    }

    func toggleSound() {
        soundEnabled.toggle()
        settings.soundEnabled = soundEnabled
    }

    func clearConversation() {
        settings.clearAllData()
    }

    func quitApp() {
        NSApplication.shared.terminate(nil)
    }
}
