import SwiftUI

struct ConversationListView: View {
    let conversations: [Conversation]
    let currentConversationId: UUID
    let onSelect: (Conversation) -> Void
    let onNew: () -> Void

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                Button(action: onNew) {
                    HStack(spacing: 4) {
                        Image(systemName: "plus")
                            .font(.system(size: 11))
                        Text("New")
                            .font(.system(size: 12))
                    }
                    .padding(.horizontal, 10)
                    .padding(.vertical, 5)
                    .background(Color.blue.opacity(0.1))
                    .foregroundStyle(.blue)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                }
                .buttonStyle(.plain)

                ForEach(conversations) { conversation in
                    ConversationPill(
                        conversation: conversation,
                        isSelected: conversation.id == currentConversationId
                    )
                    .onTapGesture {
                        onSelect(conversation)
                    }
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
        }
        .frame(height: conversations.isEmpty ? 0 : 38)
    }
}

struct ConversationPill: View {
    let conversation: Conversation
    let isSelected: Bool

    private var formattedDate: String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .abbreviated
        return formatter.localizedString(for: conversation.updatedAt, relativeTo: Date())
    }

    var body: some View {
        HStack(spacing: 4) {
            Text(conversation.title)
                .font(.system(size: 12))
                .lineLimit(1)
            Text("·")
                .foregroundStyle(.secondary)
            Text(formattedDate)
                .font(.system(size: 10))
                .foregroundStyle(.secondary)
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 5)
        .background(isSelected ? Color.blue.opacity(0.15) : Color(nsColor: .controlBackgroundColor))
        .foregroundStyle(isSelected ? .blue : .primary)
        .clipShape(RoundedRectangle(cornerRadius: 8))
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(isSelected ? Color.blue.opacity(0.3) : Color.clear, lineWidth: 1)
        )
    }
}
