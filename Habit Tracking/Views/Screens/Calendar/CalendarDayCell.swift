import SwiftUI

struct CalendarDayCell: View {
    @EnvironmentObject var dataStore: HabitDataStore

    let date: Date
    let isSelected: Bool
    let onSelect: () -> Void

    var body: some View {
        let dayCompleted = checkIfAllHabitsAreCompleted(on: date)

        Text("\(Calendar.current.component(.day, from: date))")
            .frame(minWidth: 40, minHeight: 40)
            .background(
                isSelected ? Color.blueSoft :
                dayCompleted ? Color.green.opacity(0.2) : Color.clear
            )
            .cornerRadius(20)
            .onTapGesture {
                onSelect()
            }
            .foregroundColor(.fontSoft)
            .font(Font.custom("Poppins-Medium", size: 16))
            
    }

    private func checkIfAllHabitsAreCompleted(on date: Date) -> Bool {
        let activeHabits = dataStore.habits.filter { $0.dataInicio <= date }
        guard !activeHabits.isEmpty else { return false }
        return activeHabits.allSatisfy { $0.isCompleted(on: date) }
    }
}
