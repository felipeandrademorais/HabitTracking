import SwiftUI

struct CalendarView: View {
    @EnvironmentObject var dataStore: HabitDataStore
    @State private var currentMonth: Date = Date()
    @State private var selectedDate: Date? = nil

    var body: some View {
        VStack {
            headerView
            daysOfWeekView
            daysInMonthView
            
            Divider().padding(.vertical)
            
            if let selectedDate = selectedDate {
                habitsListView(for: selectedDate)
            } else {
                Spacer()
            }
        }
        .padding()
    }
}

// MARK: - Subviews / Computed properties
extension CalendarView {
    private var headerView: some View {
        HStack {
            Button(action: previousMonth) {
                Image(systemName: "chevron.left")
            }
            Spacer()
            Text(formattedDate(currentMonth, format: "LLLL yyyy"))
                .font(.headline)
            Spacer()
            Button(action: nextMonth) {
                Image(systemName: "chevron.right")
            }
        }
        .padding()
    }

    private var daysOfWeekView: some View {
        let daysOfWeek = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
        return LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 7)) {
            ForEach(daysOfWeek, id: \.self) { day in
                Text(day)
                    .font(.subheadline)
                    .frame(maxWidth: .infinity)
                    .foregroundColor(.gray)
            }
        }
    }

    private var daysInMonthView: some View {
        let daysInMonth = generateDaysInMonth(for: currentMonth)
        return LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 7)) {
            ForEach(daysInMonth.indices, id: \.self) { index in
                if let date = daysInMonth[index] {
                    CalendarDayCell(date: date, isSelected: Calendar.current.isDate(selectedDate ?? Date.distantPast, inSameDayAs: date)) {
                        selectedDate = date
                    }
                    .environmentObject(dataStore) // Passa o EnvironmentObject para a subview
                } else {
                    Spacer() // Espaço vazio
                }
            }
        }
    }

    @ViewBuilder
    private func habitsListView(for date: Date) -> some View {
        let habitsForSelectedDate = habitsFor(date: date)
        Text(formattedDate(date, format: "dd MMMM yyyy"))
            .font(.headline)
            .padding(.vertical)

        if habitsForSelectedDate.isEmpty {
            Text("Nenhum hábito para este dia")
                .foregroundColor(.gray)
                .padding()
        } else {
            HabitList(habits: habitsForSelectedDate, selectedDate: date)
        }
        
        Spacer()
    }
}

// MARK: - Funções auxiliares
extension CalendarView {
    private func habitsFor(date: Date) -> [Habit] {
        let day = Calendar.current.startOfDay(for: date)
        return dataStore.habits.filter { habit in
            habit.dataInicio <= day
        }
    }

    private func generateDaysInMonth(for date: Date) -> [Date?] {
        guard
            let range = Calendar.current.range(of: .day, in: .month, for: date),
            let monthStart = Calendar.current.date(from: Calendar.current.dateComponents([.year, .month], from: date))
        else { return [] }

        let firstDayOfMonthWeekday = Calendar.current.component(.weekday, from: monthStart)
        let emptyDays = Array(repeating: nil as Date?, count: firstDayOfMonthWeekday - 1)

        let days = range.compactMap { day -> Date? in
            Calendar.current.date(byAdding: .day, value: day - 1, to: monthStart)
        }

        return emptyDays + days
    }

    private func previousMonth() {
        if let newMonth = Calendar.current.date(byAdding: .month, value: -1, to: currentMonth) {
            currentMonth = newMonth
            selectedDate = nil
        }
    }

    private func nextMonth() {
        if let newMonth = Calendar.current.date(byAdding: .month, value: 1, to: currentMonth) {
            currentMonth = newMonth
            selectedDate = nil
        }
    }

    private func formattedDate(_ date: Date, format: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: date)
    }
}

struct CalendarView_Previews: PreviewProvider {
    static var previews: some View {
        let exampleDataStore = HabitDataStore()
        exampleDataStore.habits = [
            Habit(nome: "Exercício", cor: Color(.color1).description, dataInicio: Date(), repeticoes: .diario),
            Habit(nome: "Meditação", cor: Color(.color1).description, dataInicio: Calendar.current.date(byAdding: .day, value: -2, to: Date()) ?? Date(), repeticoes: .diario),
            Habit(nome: "Leitura", cor: Color(.color1).description, dataInicio: Calendar.current.date(byAdding: .day, value: -5, to: Date()) ?? Date(), repeticoes: .diario)
        ]

        return CalendarView()
            .environmentObject(exampleDataStore)
    }
}
