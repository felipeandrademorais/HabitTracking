import SwiftUI

struct HabitRow: View {
    let habit: Habit
    let selectedDate: Date

    var body: some View {
        
        HStack {
            Circle()
                .fill(Color(habit.cor))
                .frame(width: 20, height: 20)
            Text(habit.nome)
                .font(
                    Font.custom("Poppins-Regular", size: 14)
                )
                .padding(.leading, 5)
                .foregroundColor(.black)
            Spacer()
            if isHabitCompleted {
                Image(systemName: "checkmark.circle.fill")
                    .foregroundColor(.green)
                    .font(
                        Font.system(size: 20)
                    )
            }
        }
        .padding(.horizontal, 15)
        .padding(.vertical, 20)
        .background(Color.blueSoft.opacity(0.5))
        .cornerRadius(12)
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
