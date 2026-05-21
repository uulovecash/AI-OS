import SwiftUI

struct MessageBubbleView: View {
    let message: Message

    private var isUser: Bool { message.sender == .user }

    private var timeString: String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter.string(from: message.timestamp)
    }

    var body: some View {
        HStack(alignment: .bottom, spacing: 6) {
            if isUser { Spacer(minLength: 0) }

            VStack(alignment: isUser ? .trailing : .leading, spacing: 4) {
                HStack(spacing: 6) {
                    if !isUser {
                        Image(systemName: "cpu")
                            .font(.system(size: 10))
                            .foregroundStyle(.secondary)
                    }
                    Text(isUser ? "You" : "AI OS")
                        .font(.system(size: 11))
                        .foregroundStyle(.secondary)
                }

                Text(message.content)
                    .font(.system(size: 13))
                    .foregroundStyle(isUser ? .white : .primary)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                    .background(isUser ? Color.blue : Color(nsColor: .controlBackgroundColor))
                    .clipShape(RoundedRectangle(cornerRadius: 16))

                Text(timeString)
                    .font(.system(size: 10))
                    .foregroundStyle(.secondary)
            }
            .frame(maxWidth: 280, alignment: isUser ? .trailing : .leading)

            if !isUser { Spacer(minLength: 0) }
        }
    }
}
