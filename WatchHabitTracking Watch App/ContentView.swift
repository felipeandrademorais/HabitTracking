//
//  ContentView.swift
//  WatchHabitTracking Watch App
//
//  Created by Felipe Morais on 23/01/25.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var dataStore = HabitDataStore()
    
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Habits count: \($dataStore.habits.count)")
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
