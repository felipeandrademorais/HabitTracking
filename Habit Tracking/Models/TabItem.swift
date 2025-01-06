//
//  TabItem.swift
//  Habit Tracking
//
//  Created by Felipe Morais on 06/01/25.
//
import SwiftUI

struct TabItem: Identifiable {
    let id = UUID()
    let tag: String
    let icon: String
    let content: AnyView
}
