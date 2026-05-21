import SwiftUI

struct TokenCounterView: View {
    let tokens: Int

    private var formattedTokens: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter.string(from: NSNumber(value: tokens)) ?? "\(tokens)"
    }

    var body: some View {
        HStack(spacing: 4) {
            Image(systemName: "number")
                .font(.system(size: 10))
                .foregroundStyle(.secondary)
            Text("Tokens: \(formattedTokens)")
                .font(.system(size: 11, design: .monospaced))
                .foregroundStyle(.secondary)
        }
    }
}
