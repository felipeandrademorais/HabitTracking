//
//  HabitsTodayView.swift
//  Habit Tracking
//
//  Created by Felipe Morais on 01/01/25.
//

import SwiftUI

struct HabitsTodayView: View {
    @EnvironmentObject var dataStore: HabitDataStore
    
    var body: some View {
        NavigationView {
            VStack{
                Text("Lista de Hábitos")
                    .font(.title)
                    .fontWeight(.semibold)
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
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
                .padding(.horizontal)
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        NavigationLink(destination: AddHabitView()) {
                            Image(systemName: "plus")
                        }
                    }
                }
            }
        }
    }

    private var todaysHabits: [Habit] {
        // Filtrar hábitos que são relevantes para o dia de hoje.
        // Exemplo (bem simples): todos os hábitos cujo dataInicio <= hoje
        // ou a repetição seja Diária.
        let hoje = Date()
        return dataStore.habits.filter { habit in
            switch habit.repeticoes {
            case .diario:
                return habit.dataInicio <= hoje
            case .semanal, .diasEspecificos:
                // Lógica adicional, se for semanal, etc.
                return habit.dataInicio <= hoje
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
            Habit(nome: "Exercício", cor: Color.blue.description, dataInicio: Date(), repeticoes: .diario),
            Habit(nome: "Meditação", cor: Color.green.description, dataInicio: Date().addingTimeInterval(-86400), repeticoes: .diario),
            Habit(nome: "Leitura", cor: Color.orange.description, dataInicio: Date().addingTimeInterval(-172800), repeticoes: .diario)
        ]

        return HabitsTodayView()
            .environmentObject(exampleDataStore)
    }
}
