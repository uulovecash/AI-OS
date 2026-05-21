import SwiftUI

struct ModelSelectorView: View {
    @ObservedObject private var settings = AppSettings.shared

    var body: some View {
        Picker("Model", selection: $settings.selectedModel) {
            ForEach(AIModel.allCases) { model in
                Text(model.rawValue)
                    .tag(model)
            }
        }
        .pickerStyle(.segmented)
        .labelsHidden()
        .help("Select AI Model")
    }
}
