import SwiftUI

struct HabitRowView: View {
    @EnvironmentObject var dataStore: HabitDataStore
    var habit: Habit
    // Novo parâmetro
    var selectedDate: Date
    
    var body: some View {
        HStack {
            Text(habit.icon)
                .font(.system(size: 24))
            VStack(alignment: .leading) {
                Text(habit.nome)
                    .font(
                        Font.custom(
                            "Poppins-Regular",
                            size: 14
                        )
                    )
                    .strikethrough(
                        isCompletedOnSelectedDate,
                        color: .blackSoft
                    )
                    .foregroundColor(isCompletedOnSelectedDate ? .fontSoft : .black)
            }
            
            Spacer()
            
            Button(
                action: {
                    toggleCompletion(for: habit)
                }
            ) {
                Image(
                    systemName: isCompletedOnSelectedDate
                        ? "checkmark.circle.fill"
                        : "circle"
                )
                .foregroundColor(isCompletedOnSelectedDate ? .fontSoft : .black)
                .font(Font.system(size: 20))
            }
            .buttonStyle(PlainButtonStyle())
        }
        .padding(.horizontal, 15)
        .padding(.vertical, 20)
        .background(
            isCompletedOnSelectedDate
                ? Color(habit.cor).opacity(0.2)
                : Color(habit.cor).opacity(0.7)
        )
        .cornerRadius(12)
    }
    
    // MARK: - Computed property para verificar se está concluído
    private var isCompletedOnSelectedDate: Bool {
        let day = Calendar.current.startOfDay(for: selectedDate)
        return habit.datesCompleted.contains {
            Calendar.current.startOfDay(for: $0) == day
        }
    }
    
    // MARK: - Lógica de toggle, removendo/adicionando somente a data selecionada
    private func toggleCompletion(for habit: Habit) {
        var updatedHabit = habit
        let day = Calendar.current.startOfDay(for: selectedDate)
        
        if isCompletedOnSelectedDate {
            // Se já está concluído, remove somente a data selecionada
            updatedHabit.datesCompleted.removeAll { date in
                Calendar.current.startOfDay(for: date) == day
            }
        } else {
            // Se ainda não está concluído, adiciona somente a data selecionada
            updatedHabit.datesCompleted.append(day)
        }
        
        dataStore.updateHabit(updatedHabit)
    }
}

// MARK: - Preview
struct HabitRowView_Previews: PreviewProvider {
    static var previews: some View {
        let dataStore = HabitDataStore()
        
        let habitExample = Habit(
            nome: "Beber 2L de água",
            cor: "color2",
            dataInicio: Date().addingTimeInterval(-86400 * 5),
            repeticoes: .diario,
            datesCompleted: [Calendar.current.startOfDay(for: Date())],
            icon: "⭐️"
        )
        
        dataStore.habits = [habitExample]
        
        return HabitRowView(
            habit: habitExample,
            selectedDate: Date()
        )
        .environmentObject(dataStore)
        .previewLayout(.sizeThatFits)
        .padding()
        .previewDisplayName("Habit Row com Checkbox")
    }
}
