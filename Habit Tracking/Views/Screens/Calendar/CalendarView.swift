import SwiftUI

struct CalendarView: View {
    @EnvironmentObject var dataStore: HabitDataStore
    @State private var currentMonth: Date = Date()
    @State private var selectedDate: Date = Date()

    var body: some View {
        VStack() {
            VStack {
                headerView
                daysOfWeekView
                daysInMonthView
            }
            .padding()
            .background(Color.calendarBackground)
            .cornerRadius(20)
            
            habitsListView(for: selectedDate)
        }
        .padding()
        .background(Color.blue.opacity(0.2))
    }
}

// MARK: - Subviews / Computed properties
extension CalendarView {
    private var headerView: some View {
        HStack {
            Spacer()
            Text(formattedDate(currentMonth, format: "LLLL"))
                .font(Font.custom("Poppins-Regular", size: 16))
            Spacer()
            Text(formattedDate(currentMonth, format: "yyyy"))
                .font(Font.custom("Poppins-Regular", size: 12))
        }
        .padding()
    }

    private var daysOfWeekView: some View {
        return LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 7)) {
            ForEach(days, id: \.self) { day in
                Text(day)
                    .font(Font.custom("Poppins-Thin", size: 12))
                    .frame(maxWidth: .infinity)
                    .foregroundColor(.black)
            }
        }
    }

    private var daysInMonthView: some View {
        let daysInMonth = generateDaysInMonth(for: currentMonth)
        return LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 7), spacing: 10) {
            ForEach(daysInMonth.indices, id: \.self) { index in
                if let date = daysInMonth[index] {
                    CalendarDayCell(date: date, isSelected: Calendar.current.isDate(selectedDate, inSameDayAs: date)) {
                        selectedDate = date
                    }
                } else {
                    Spacer()
                }
            }
        }
    }

    @ViewBuilder
    private func habitsListView(for date: Date) -> some View {
        let habitsForSelectedDate = dataStore.habits(for: date)
        VStack(spacing: 20) {
            Text(formattedDate(date, format: "MMMM d, EEEE"))
                .font(.headline)
                .foregroundColor(.fontSoft)

            if habitsForSelectedDate.isEmpty {
                Text("Nenhum Hábito para essa data")
                    .foregroundColor(.fontSoft)
                    .padding()
            } else {
                ScrollView {
                    VStack(alignment: .leading, spacing: 10) {
                        ForEach(habitsForSelectedDate, id: \.id) { habit in
                            HabitRowView(
                                habit: habit,
                                selectedDate: selectedDate,
                                showCheckbox: false
                            )
                        }
                    }
                }
            }
            
            Spacer()
        }
        .padding()
    }
}

// MARK: - Funções auxiliares
extension CalendarView {
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
        }
    }

    private func nextMonth() {
        if let newMonth = Calendar.current.date(byAdding: .month, value: 1, to: currentMonth) {
            currentMonth = newMonth
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
        return CalendarView()
            .environmentObject(HabitDataStore.sampleDataStore)
    }
}
