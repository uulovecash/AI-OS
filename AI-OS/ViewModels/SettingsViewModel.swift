import Foundation
import Combine
import AppKit

class SettingsViewModel: ObservableObject {
    @Published var openAIKey: String {
        didSet {
            settings.openAIKey = openAIKey
        }
    }
    @Published var anthropicKey: String {
        didSet {
            settings.anthropicKey = anthropicKey
        }
    }
    @Published var googleKey: String {
        didSet {
            settings.googleKey = googleKey
        }
    }
    @Published var soundEnabled: Bool {
        didSet {
            settings.soundEnabled = soundEnabled
        }
    }

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
        settings.soundEnabled = soundEnabled
    }

    func quitApp() {
        NSApplication.shared.terminate(nil)
    }
}
