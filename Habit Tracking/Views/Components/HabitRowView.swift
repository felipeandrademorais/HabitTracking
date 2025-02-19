import SwiftUI

struct HabitRowView: View {
    @EnvironmentObject var dataStore: HabitDataStore
    var habit: Habit
    var selectedDate: Date
    var showCheckbox: Bool = true

    var body: some View {
        HStack {
            Text(habit.icon)
                .font(.system(size: 28))
                .foregroundColor(.fontSoft)
            
            VStack(alignment: .leading) {
                Text(habit.nome)
                    .font(Font.custom("Poppins-Regular", size: 14))
                    .strikethrough(
                        isCompletedOnSelectedDate,
                        color: .blackSoft
                    )
                    .foregroundColor(isCompletedOnSelectedDate ? .fontSoft : .black)
            }
            
            Spacer()
            
            if showCheckbox {
                Button(
                    action: {
                        let impactMed = UIImpactFeedbackGenerator(style: .medium)
                        impactMed.impactOccurred()
                        toggleCompletion(for: habit)
                    }
                ) {
                    Image(
                        systemName: isCompletedOnSelectedDate
                            ? "checkmark.circle.fill"
                            : "circle"
                    )
                    .font(Font.system(size: 24))
                    .foregroundColor(isCompletedOnSelectedDate ? .green : .black)
                    
                }
                .buttonStyle(PlainButtonStyle())
            } else {
                if (isCompletedOnSelectedDate) {
                    Image(
                        systemName: "checkmark.circle.fill"
                    )
                    .foregroundColor(.green)
                    .font(Font.system(size: 20))
                }
            }
            
        }
        .padding(.horizontal, 15)
        .padding(.vertical, 20)
        .background(Color(habit.cor))
        .cornerRadius(12)
    }
    
    // MARK: - Computed property para verificar se o hábito foi concluído
    private var isCompletedOnSelectedDate: Bool {
        habit.isCompleted(on: selectedDate)
    }
    
    // MARK: - Lógica de toggle, removendo/adicionando somente a data selecionada
    private func toggleCompletion(for habit: Habit) {
        var updatedHabit = habit
        let day = Calendar.current.startOfDay(for: selectedDate)
        
        if isCompletedOnSelectedDate {
            updatedHabit.datesCompleted.removeAll { date in
                Calendar.current.startOfDay(for: date) == day
            }
        } else {
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
            repeticoes: .daily,
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
        .previewDisplayName("Habit Row com Checkbox e Validação")
    }
}
