//
//  ColorCircleSelector.swift
//  Habit Tracking
//
//  Created by Felipe Morais on 16/01/25.
//
import SwiftUI

struct ColorCircleSelector: View {
    let color: Color
    let isSelected: Bool
    let onTap: () -> Void

    var body: some View {
        Circle()
            .fill(color)
            .frame(width: 32, height: 32)
            .overlay(
                Circle()
                    .stroke(isSelected ? Color.black.opacity(0.5) : Color.white, lineWidth: 3)
            )
            .padding(.trailing, 4)
            .onTapGesture {
                onTap()
            }
    }
}
