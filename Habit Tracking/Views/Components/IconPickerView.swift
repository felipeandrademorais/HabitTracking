//
//  IconPickerView.swift
//  Habit Tracking
//
//  Created by Felipe Morais on 16/01/25.
//

import SwiftUI

struct IconPickerView: View {
    @Binding var selectedIcon: String
    @Binding var isPresented: Bool

    private let icons = [
        "star.fill", "heart.fill", "flame.fill", "alarm.fill", "bell.fill",
        "book.fill", "briefcase.fill", "sun.max.fill", "moon.fill", "bolt.fill",
        "car.fill", "cart.fill", "leaf.fill", "pawprint.fill", "gift.fill",
        "gamecontroller.fill", "house.fill", "music.note", "paperplane.fill"
    ]
    
    private let emojis = [
        "⭐️", "🔥", "💖", "🎉", "🍀",
        "📚", "💼", "☀️", "🌙", "⚡️",
        "🚗", "🛒", "🌱", "🐾", "🎁",
        "🎮", "🏡", "🎵", "✈️", "💪"
    ]

    var body: some View {
        ScrollView {
            // Exemplo de grid adaptativo
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 50))], spacing: 20) {
                ForEach(emojis, id: \.self) { emoji in
                    VStack {
                        Text(emoji) // Mostra o emoji
                            .font(.system(size: 36)) // Define o tamanho do emoji
                            .padding(8)
                            // Destaque para o emoji selecionado
                            .background(
                                Circle()
                                    .fill(emoji == selectedIcon ? Color.gray.opacity(0.3) : Color.clear)
                            )
                    }
                    .onTapGesture {
                        // Atualiza o emoji selecionado e fecha a popover
                        selectedIcon = emoji
                        isPresented = false
                    }
                }
            }
            .padding()
        }
    }
}
