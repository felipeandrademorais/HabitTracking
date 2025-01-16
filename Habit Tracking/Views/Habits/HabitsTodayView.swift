//
//  HabitsTodayView.swift
//  Habit Tracking
//
//  Created by Felipe Morais on 01/01/25.
//

import SwiftUI

struct HabitsTodayView: View {
    @EnvironmentObject var dataStore: HabitDataStore
    @State private var selectedDate: Date = Date()
    @State private var isShowingAddHabit: Bool = false

    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            VStack {
                WeekView(onDaySelected: { date in
                    selectedDate = date
                })
                .frame(maxHeight: 85)
                
                if (todaysHabits.isEmpty) {
                    Spacer()
                    Image("Woman")
                        .resizable()
                        .scaledToFit()
                        .padding(40)
                    
                    Spacer()
                } else {
                    List {
                        ForEach(todaysHabits) { habit in
                            HabitRowView(
                                habit: habit,
                                selectedDate: selectedDate
                            )
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
            
            Button(action: {
                isShowingAddHabit = true
            }) {
                Image(systemName: "plus")
                    .font(.title)
                    .foregroundColor(.black)
                    .padding()
                    .background(.white)
                    .clipShape(Circle())
                    .shadow(radius: 5)
            }
            .padding(.trailing, 20)
            .padding(.bottom, 45)
            
        }.sheet(isPresented: $isShowingAddHabit) {
            AddHabitView()
                .environmentObject(dataStore)
        }
    }

    private var todaysHabits: [Habit] {
        // Filtrar hábitos relevantes para a data selecionada
        let filteredHabits = dataStore.habits.filter { habit in
            switch habit.repeticoes {
                case .diario:
                    return habit.dataInicio <= selectedDate
                case .semanal, .diasEspecificos:
                    // Lógica adicional, se for semanal, etc.
                    return habit.dataInicio <= selectedDate
            }
        }
        
        return filteredHabits.sorted {$0.datesCompleted.isEmpty && !$1.datesCompleted.isEmpty }
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
           
        ]

        return HabitsTodayView()
            .environmentObject(exampleDataStore)
    }
}
