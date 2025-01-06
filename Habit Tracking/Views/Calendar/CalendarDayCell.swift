//
//  CalendarDayCell.swift
//  Habit Tracking
//
//  Created by Felipe Morais on 02/01/25.
//


import SwiftUI

struct CalendarDayCell: View {
    @EnvironmentObject var dataStore: HabitDataStore

    let date: Date
    let isSelected: Bool
    let onSelect: () -> Void

    var body: some View {
        let dayCompleted = checkIfAllHabitsAreCompleted(on: date)

        Text("\(Calendar.current.component(.day, from: date))")
            .frame(minWidth: 40, minHeight: 40)
            .background(
                isSelected ? Color.blue.opacity(0.2) :
                dayCompleted ? Color.green.opacity(0.2) : Color.clear
            )
            .cornerRadius(20)
            .foregroundColor(isSelected ? .white : .primary)
            .onTapGesture {
                onSelect()
            }
    }

    private func checkIfAllHabitsAreCompleted(on date: Date) -> Bool {
        let day = Calendar.current.startOfDay(for: date)
        let activeHabits = dataStore.habits.filter { $0.dataInicio <= date }
        guard !activeHabits.isEmpty else { return false }

        for habit in activeHabits {
            if !habit.datesCompleted.contains(where: {
                Calendar.current.startOfDay(for: $0) == day
            }) {
                return false
            }
        }
        return true
    }
}