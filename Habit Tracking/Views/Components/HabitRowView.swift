import SwiftUI

struct HabitRowView: View {
    @EnvironmentObject var dataStore: HabitDataStore
    @State private var showAnimation: Bool = false
    var habit: Habit
    var selectedDate: Date
    var showCheckbox: Bool = true
    var onHabitCompleted: ((Bool) -> Void)? = nil
    
    var body: some View {
        ZStack {
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
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(.green)
                            .font(Font.system(size: 24))
                    }
                }
            }
            .padding(.horizontal, 15)
            .padding(.vertical, 20)
            .background(Color(habit.cor))
            .cornerRadius(12)
            .overlay(alignment: .trailing) {
                if showAnimation {
                    LottieView(animationName: "Check.json")
                        .frame(width: 150, height: 150)
                        .offset(x: 45, y: 0)
                        .allowsHitTesting(false)
                        .transition(.scale)
                }
            }
        }
        .onAppear(){
            if isCompletedOnSelectedDate {
                showAnimation = false
            }
        }
    }
    
    private var isCompletedOnSelectedDate: Bool {
        habit.isCompleted(on: selectedDate)
    }
    
    private func toggleCompletion(for habit: Habit) {
        var updatedHabit = habit
        let day = Calendar.current.startOfDay(for: selectedDate)
        
        if isCompletedOnSelectedDate {
            updatedHabit.datesCompleted.removeAll { date in
                Calendar.current.startOfDay(for: date) == day
            }
            onHabitCompleted?(false)
        } else {
            updatedHabit.datesCompleted.append(day)
            onHabitCompleted?(true)
            showAnimation = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                showAnimation = false
            }
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
