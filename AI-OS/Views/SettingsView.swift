import SwiftUI

struct SettingsView: View {
    let onClearAll: () -> Void
    @StateObject private var viewModel = SettingsViewModel()
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Text("Settings")
                    .font(.system(size: 16, weight: .semibold))
                Spacer()
                Button("Done") {
                    viewModel.saveKeys()
                    dismiss()
                }
                .keyboardShortcut(.defaultAction)
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 16)

            Divider()

            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    apiKeySection
                    preferencesSection
                    dangerZoneSection
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 16)
            }
        }
        .frame(width: 360, height: 420)
    }

    private var apiKeySection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Label("API Keys", systemImage: "key.fill")
                .font(.system(size: 13, weight: .semibold))
                .foregroundStyle(.secondary)

            VStack(spacing: 8) {
                KeyField(label: "OpenAI", placeholder: "sk-...", text: $viewModel.openAIKey)
                KeyField(label: "Anthropic", placeholder: "sk-ant-...", text: $viewModel.anthropicKey)
                KeyField(label: "Google", placeholder: "AIza...", text: $viewModel.googleKey)
            }
        }
    }

    private var preferencesSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Label("Preferences", systemImage: "slider.horizontal.3")
                .font(.system(size: 13, weight: .semibold))
                .foregroundStyle(.secondary)

            Toggle("Sound Effects", isOn: $viewModel.soundEnabled)
                .toggleStyle(.switch)
                .controlSize(.small)
                .onChange(of: viewModel.soundEnabled) { _, _ in
                    viewModel.toggleSound()
                }
        }
    }

    private var dangerZoneSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Label("Danger Zone", systemImage: "exclamationmark.triangle.fill")
                .font(.system(size: 13, weight: .semibold))
                .foregroundStyle(.red)

            VStack(spacing: 8) {
                Button("Clear All Conversations") {
                    onClearAll()
                    dismiss()
                }
                .buttonStyle(.plain)
                .foregroundStyle(.red)

                Button("Quit AI OS") {
                    viewModel.quitApp()
                }
                .buttonStyle(.plain)
                .foregroundStyle(.red)
            }
        }
    }
}

struct KeyField: View {
    let label: String
    let placeholder: String
    @Binding var text: String

    var body: some View {
        HStack(spacing: 8) {
            Text(label)
                .font(.system(size: 12))
                .frame(width: 80, alignment: .trailing)
                .foregroundStyle(.secondary)

            SecureField(placeholder, text: $text)
                .font(.system(size: 12, design: .monospaced))
                .textFieldStyle(.roundedBorder)
        }
    }
}
