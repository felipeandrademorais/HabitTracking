//
//  HabitDataStore.swift
//  Habit Tracking
//
//  Created by Felipe Morais on 01/01/25.
//


import SwiftUI

class HabitDataStore: ObservableObject {
    @Published var habits: [Habit] = []
    
    private let habitsKey = "habitsKey"

    init() {
        loadHabits()
    }

    func loadHabits() {
        guard let data = UserDefaults.standard.data(forKey: habitsKey) else { return }
        do {
            let decoded = try JSONDecoder().decode([Habit].self, from: data)
            self.habits = decoded
        } catch {
            print("Erro ao decodificar habits: \(error)")
        }
    }

    func saveHabits() {
        do {
            let encoded = try JSONEncoder().encode(habits)
            UserDefaults.standard.set(encoded, forKey: habitsKey)
        } catch {
            print("Erro ao codificar habits: \(error)")
        }
    }

    // CRUD básico
    func addHabit(_ habit: Habit) {
        habits.append(habit)
        saveHabits()
    }

    func updateHabit(_ habit: Habit) {
        if let index = habits.firstIndex(where: { $0.id == habit.id }) {
            habits[index] = habit
            saveHabits()
        }
    }

    func removeHabit(_ habit: Habit) {
        habits.removeAll { $0.id == habit.id }
        saveHabits()
    }
}
