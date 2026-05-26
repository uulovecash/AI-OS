import SwiftUI

struct PopoverView: View {
    @ObservedObject var viewModel: ChatViewModel

    var body: some View {
        VStack(spacing: 0) {
            ChatHeaderView(showSettings: $viewModel.showSettings)
            Divider()

            ConversationListView(
                conversations: viewModel.conversations,
                currentConversationId: viewModel.currentConversation.id,
                onSelect: { viewModel.loadConversation($0) },
                onNew: { viewModel.startNewConversation() }
            )
            Divider()

            ScrollViewReader { proxy in
                ScrollView {
                    LazyVStack(spacing: 8) {
                        if viewModel.currentConversation.messages.isEmpty {
                            EmptyChatView()
                        } else {
                            ForEach(viewModel.currentConversation.messages) { message in
                                MessageBubbleView(message: message)
                                    .id(message.id)
                            }
                        }

                        if viewModel.isLoading {
                            LoadingBubbleView()
                        }

                        if let error = viewModel.errorMessage {
                            ErrorBubbleView(message: error)
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 12)
                }
                .onChange(of: viewModel.currentConversation.messages.count) { _, _ in
                    if let lastId = viewModel.currentConversation.messages.last?.id {
                        withAnimation(.easeOut(duration: 0.2)) {
                            proxy.scrollTo(lastId, anchor: .bottom)
                        }
                    }
                }
            }

            Divider()

            VStack(spacing: 8) {
                ChatInputView(
                    text: $viewModel.inputText,
                    canSend: viewModel.canSend,
                    onSend: { viewModel.sendMessage() }
                )
                HStack {
                    ModelSelectorView()
                    Spacer()
                    TokenCounterView(tokens: viewModel.totalTokens)
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
        }
        .frame(width: 380, height: 520)
        .sheet(isPresented: $viewModel.showSettings) {
            SettingsView()
        }
    }
}

struct EmptyChatView: View {
    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: "sparkles")
                .font(.system(size: 32))
                .foregroundStyle(.secondary)
            Text("No conversations yet. Start chatting!")
                .font(.system(size: 13))
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 40)
    }
}

struct LoadingBubbleView: View {
    @State private var animate = false

    var body: some View {
        HStack {
            HStack(spacing: 4) {
                ForEach(0..<3, id: \.self) { i in
                    Circle()
                        .fill(Color.secondary.opacity(0.5))
                        .frame(width: 6, height: 6)
                        .opacity(animate ? 1.0 : 0.3)
                        .animation(
                            .easeInOut(duration: 0.6)
                            .repeatForever()
                            .delay(Double(i) * 0.15),
                            value: animate
                        )
                }
            }
            .padding(.horizontal, 14)
            .padding(.vertical, 10)
            .background(Color(nsColor: .controlBackgroundColor).opacity(0.8))
            .clipShape(RoundedRectangle(cornerRadius: 16))
            Spacer()
        }
        .onAppear { animate = true }
    }
}

struct ErrorBubbleView: View {
    let message: String

    var body: some View {
        HStack {
            HStack(spacing: 6) {
                Image(systemName: "exclamationmark.triangle.fill")
                    .foregroundStyle(.orange)
                Text(message)
                    .font(.system(size: 13))
                    .foregroundStyle(.primary)
            }
            .padding(.horizontal, 14)
            .padding(.vertical, 10)
            .background(Color.orange.opacity(0.1))
            .clipShape(RoundedRectangle(cornerRadius: 16))
            Spacer()
        }
    }
}
