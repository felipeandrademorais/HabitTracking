import SwiftUI

struct HabitList: View {
    let habits: [Habit]
    let selectedDate: Date

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 10) {
                ForEach(habits, id: \.id) { habit in
                    HabitRow(habit: habit, selectedDate: selectedDate)
                }
            }
        }
    }
}

struct HabitList_Previews: PreviewProvider {
    static var previews: some View {
        let exampleHabits = [
            Habit(nome: "Exercício", cor: "color1", dataInicio: Calendar.current.date(byAdding: .day, value: -3, to: Date()) ?? Date(), repeticoes: .diario, icon: "⭐️"),
            Habit(nome: "Meditação", cor: "color2", dataInicio: Calendar.current.date(byAdding: .day, value: -5, to: Date()) ?? Date(), repeticoes: .diario, icon: "💖"),
            Habit(nome: "Leitura", cor: "color3", dataInicio: Calendar.current.date(byAdding: .day, value: -1, to: Date()) ?? Date(), repeticoes: .diario, icon: "💪")
        ]

        let selectedDate = Calendar.current.date(byAdding: .day, value: -1, to: Date()) ?? Date()

        return HabitList(habits: exampleHabits, selectedDate: selectedDate)
    }
}
