import SwiftUI

struct CalendarDayCell: View {
    @EnvironmentObject var dataStore: HabitDataStore

    let date: Date
    let isSelected: Bool
    let onSelect: () -> Void

    var body: some View {
        let completionOpacity = calculateCompletionOpacity(for: date)

        Text("\(Calendar.current.component(.day, from: date))")
            .frame(minWidth: 40, minHeight: 40)
            .background(
                isSelected ? Color.blueSoft :
                Color.green.opacity(completionOpacity)
            )
            .cornerRadius(20)
            .onTapGesture {
                onSelect()
            }
            .foregroundColor(.fontSoft)
            .font(Font.custom("Poppins-Medium", size: 16))
    }

    /// Calcula a opacidade da cor de fundo com base na porcentagem de hábitos completos no dia.
    private func calculateCompletionOpacity(for date: Date) -> Double {
        let startOfSelectedDate = Calendar.current.startOfDay(for: date)

        let activeHabits = dataStore.habits.filter {
            Calendar.current.startOfDay(for: $0.dataInicio) <= startOfSelectedDate
        }
        
        let totalHabits = activeHabits.count
        let completedHabits = activeHabits.filter { $0.isCompleted(on: date) }.count

        // Retorna um valor entre 0.0 (nenhum completo) e 1.0 (todos completos)
        return totalHabits > 0 ? Double(completedHabits) / Double(totalHabits) : 0.001
    }
}
