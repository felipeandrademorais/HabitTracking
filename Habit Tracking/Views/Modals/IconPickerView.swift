import SwiftUI

struct IconPickerView: View {
    @Binding var selectedIcon: String
    @Binding var isPresented: Bool

    
    private let emojis = [
        "⭐️", "🔥", "💖", "🎉", "🍀",
        "📚", "💼", "☀️", "🌙", "⚡️",
        "🚗", "🛒", "🌱", "🐾", "🎁",
        "🎮", "🏡", "🎵", "✈️", "💪"
    ]

    var body: some View {
        ScrollView {
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 70))], spacing: 20) {
                ForEach(emojis, id: \.self) { emoji in
                    HStack {
                        Text(emoji)
                            .padding()
                            .font(.system(size: 32))
                            .background(
                                Circle()
                                    .fill(emoji == selectedIcon ? Color.gray.opacity(0.3) : Color.white.opacity(0.001))
                            )
                    }
                    .onTapGesture {
                        selectedIcon = emoji
                        isPresented = false
                    }
                }
            }
            .padding()
        }
    }
}

struct IconPickerView_Previews: PreviewProvider {
    static var previews: some View {
        IconPickerPreviewWrapper()
    }
}

struct IconPickerPreviewWrapper: View {
    @State private var selectedIcon: String = "⭐️"
    @State private var isPresented: Bool = true

    var body: some View {
        IconPickerView(selectedIcon: $selectedIcon, isPresented: $isPresented)
            .previewLayout(.sizeThatFits)
            .padding()
    }
}
