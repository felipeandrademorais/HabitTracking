//
//  HabitsTodayView.swift
//  Habit Tracking
//
//  Created by Felipe Morais on 01/01/25.
//

import SwiftUI

struct HabitsTodayView: View {
    @EnvironmentObject var dataStore: HabitDataStore

    @State private var selectedDate: Date = Date() // Estado para rastrear o dia selecionado.

    var body: some View {
            ZStack(alignment: .bottomTrailing) {
                VStack {
                    WeekView(onDaySelected: { date in
                        selectedDate = date
                    })
                    .frame(maxHeight: 85)
                    
                    List {
                        ForEach(todaysHabits) { habit in
                            HabitRowView(habit: habit)
                                .padding(.vertical, 8)
                                .listRowInsets(EdgeInsets())
                                .listRowBackground(
                                    Color.clear
                                )
                                .listRowSeparator(.hidden)
                        }
                        .onDelete(perform: deleteHabits)
                    }
                    .listStyle(.plain)
                    .listRowSeparator(.hidden)
                    .padding()
                }
        }
    }

    private var todaysHabits: [Habit] {
        // Filtrar hábitos relevantes para a data selecionada
        return dataStore.habits.filter { habit in
            switch habit.repeticoes {
            case .diario:
                return habit.dataInicio <= selectedDate
            case .semanal, .diasEspecificos:
                // Lógica adicional, se for semanal, etc.
                return habit.dataInicio <= selectedDate
            }
        }
    }

    private func deleteHabits(at offsets: IndexSet) {
        offsets.forEach { index in
            let habit = todaysHabits[index]
            dataStore.removeHabit(habit)
        }
    }
}

struct HabitsTodayView_Previews: PreviewProvider {
    static var previews: some View {
        let exampleDataStore = HabitDataStore()
        exampleDataStore.habits = [
            Habit(nome: "Exercício", cor: "color1", dataInicio: Date(), repeticoes: .diario),
            Habit(nome: "Meditação", cor: "color2", dataInicio: Date().addingTimeInterval(-86400), repeticoes: .diario),
            Habit(nome: "Leitura", cor: "color3", dataInicio: Date().addingTimeInterval(-172800), repeticoes: .diario)
        ]

        return HabitsTodayView()
            .environmentObject(exampleDataStore)
    }
}
