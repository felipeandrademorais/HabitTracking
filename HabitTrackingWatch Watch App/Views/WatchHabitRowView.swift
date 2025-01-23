import SwiftUI

struct WatchHabitRowView: View {
    @EnvironmentObject var dataStore: HabitDataStore
    let habit: Habit
    let selectedDate: Date

    var body: some View {
        HStack {
            // Ícone do hábito
            Text(habit.icon)
                .font(.title3)
                .padding(.trailing, 4)

            // Nome do hábito
            VStack(alignment: .leading) {
                Text(habit.nome)
                    .font(.system(.body, design: .rounded))
                    .foregroundColor(isCompletedOnSelectedDate ? .gray : .white)
                    .strikethrough(isCompletedOnSelectedDate, color: .gray)
            }

            Spacer()

            // Botão de check
            Button(action: { toggleCompletion(habit) }) {
                Image(systemName: isCompletedOnSelectedDate
                        ? "checkmark.circle.fill"
                        : "circle")
                    .foregroundColor(isCompletedOnSelectedDate ? .green : .white)
            }
            .buttonStyle(PlainButtonStyle())
        }
        .padding(8)
        .background(
            isCompletedOnSelectedDate
            ? Color(habit.cor).opacity(0.2)
            : Color(habit.cor).opacity(0.7)
        )
        .cornerRadius(8)
    }

    // Computed property para verificar se foi concluído no dia selecionado
    private var isCompletedOnSelectedDate: Bool {
        habit.isCompleted(on: selectedDate)
    }

    // Lógica de toggle (igual no iOS)
    private func toggleCompletion(_ habit: Habit) {
        var updatedHabit = habit
        let day = Calendar.current.startOfDay(for: selectedDate)

        if isCompletedOnSelectedDate {
            updatedHabit.datesCompleted.removeAll {
                Calendar.current.startOfDay(for: $0) == day
            }
        } else {
            updatedHabit.datesCompleted.append(day)
        }

        dataStore.updateHabit(updatedHabit)
    }
}

struct WatchHabitRowView_Previews: PreviewProvider {
    static var previews: some View {
        let dataStore = HabitDataStore.sampleDataStore
        let habitExample = dataStore.habits.first!

        return WatchHabitRowView(
            habit: habitExample,
            selectedDate: Date()
        )
        .environmentObject(dataStore)
        .previewLayout(.sizeThatFits)
    }
}