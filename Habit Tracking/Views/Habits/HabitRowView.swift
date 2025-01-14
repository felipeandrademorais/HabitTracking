import SwiftUI

struct HabitRowView: View {
    @EnvironmentObject var dataStore: HabitDataStore
    var habit: Habit
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(habit.nome)
                    .font(
                        Font.custom(
                            "Poppins-Regular",
                            size: 14
                        )
                    )
                    .strikethrough(
                        isCompletedToday,
                        color: .blackSoft
                    )
                    .foregroundColor(isCompletedToday ? .fontSoft : .black)
            }
            
            Spacer()
            
            Button(
                action: {
                    toggleCompletion(for: habit)
                }
            ) {
                Image(
                    systemName: isCompletedToday ? "checkmark.circle.fill" : "circle")
                    .foregroundColor(isCompletedToday ? .fontSoft : .black)
                    .font(
                        Font.system(size: 20)
                    )
            }
            .buttonStyle(PlainButtonStyle())
        }
        .padding(.horizontal, 15)
        .padding(.vertical, 20)
        .background(
            Color(habit.cor).opacity(0.7)
        )
        .cornerRadius(12)        
    }
    
    private var isCompletedToday: Bool {
        // Verifica se a 'datesCompleted' contém a data de hoje
        let hoje = Calendar.current.startOfDay(for: Date())
        return habit.datesCompleted.contains {
            Calendar.current.startOfDay(for: $0) == hoje
        }
    }
    
    private func toggleCompletion(for habit: Habit) {
        var updatedHabit = habit
        let hoje = Calendar.current.startOfDay(for: Date())
        
        if isCompletedToday {
            // Se já está concluído hoje, removemos a data
            updatedHabit.datesCompleted.removeAll { date in
                Calendar.current.startOfDay(for: date) == hoje
            }
        } else {
            // Se não está concluído hoje, adicionamos a data de hoje
            updatedHabit.datesCompleted.append(Date())
        }
        
        // Atualiza no dataStore
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
            datesCompleted: [Date()]
        )
        
        dataStore.habits = [habitExample]
        
        return HabitRowView(habit: habitExample)
            .environmentObject(dataStore)
            .previewLayout(.sizeThatFits)
            .padding()
            .previewDisplayName("Habit Row com Checkbox")
    }
}
