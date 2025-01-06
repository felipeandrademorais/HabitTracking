import SwiftUI

struct HabitRow: View {
    let habit: Habit
    let selectedDate: Date

    var body: some View {
        
        HStack {
            Circle()
                .fill(Color(habit.cor))
                .frame(width: 12, height: 12)
            Text(habit.nome)
                .font(.subheadline)
                .padding(.leading, 5)
                .bold()
            Spacer()
            if isHabitCompleted {
                Image(systemName: "checkmark.circle.fill")
                    .foregroundColor(.green)
            }
        }
        .padding(15)
        .background(Color(habit.cor))
        .cornerRadius(8)
        .onAppear {
            print(habit)
        }
    }

    private var isHabitCompleted: Bool {
        habit.datesCompleted.contains {
            Calendar.current.isDate($0, inSameDayAs: selectedDate)
        }
    }
}

struct HabitRow_Previews: PreviewProvider {
    static var previews: some View {
        let exampleHabit = Habit(
            nome: "Exercício",
            cor: "color1",
            dataInicio: Calendar.current.date(byAdding: .day, value: -5, to: Date()) ?? Date(),
            repeticoes: .diario,
            datesCompleted: [
                Calendar.current.date(byAdding: .day, value: -2, to: Date()) ?? Date(),
                Calendar.current.startOfDay(for: Date())
            ]
        )

        let selectedDate = Calendar.current.startOfDay(for: Date())

        return HabitRow(habit: exampleHabit, selectedDate: selectedDate)
            .previewLayout(.sizeThatFits)
            .padding()
    }
}
