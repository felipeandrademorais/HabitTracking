import SwiftUI

struct YearCalendarView: View {
    var habitDataStore: HabitDataStore
    private let columns = Array(repeating: GridItem(.fixed(6), spacing: 1), count: 53) // 53 weeks
    private let rows = Array(repeating: GridItem(.fixed(6), spacing: 1), count: 7) // 7 days

    var body: some View {
        VStack(spacing: 8) {
            Text("Atividade Anual")
                .font(.custom("Poppins-SemiBold", size: 16))
                .foregroundColor(.fontSoft)
                .frame(maxWidth: .infinity, alignment: .leading)

            HStack(alignment: .top, spacing: 4) {
                // Weekday labels (Monday - Sunday)
                VStack(spacing: 2) {
                    ForEach(["Seg", "Ter", "Qua", "Qui", "Sex", "Sáb", "Dom"], id: \.self) { day in
                        Text(day)
                            .font(.custom("Poppins-Regular", size: 6))
                            .foregroundColor(.fontSoft)
                            .frame(height: 8)
                    }
                }
                .padding(.top, 8)

                VStack(alignment: .leading) {
                    // Month Labels aligned with correct weeks
                    HStack(spacing: 4) {
                        ForEach(0..<12) { month in
                            let monthStartIndex = getMonthStartWeek(month: month + 1)
                            Text(monthAbbreviation(month: month + 1))
                                .font(.custom("Poppins-Regular", size: 6))
                                .foregroundColor(.fontSoft)
                                .frame(width: 20, alignment: .leading)
                                .offset(x: CGFloat(monthStartIndex * 6)) // Align month names
                        }
                    }
                    .padding(.leading, 8)

                    // Year Grid (fixing weekday alignment)
                    LazyVGrid(columns: columns, spacing: 2) {
                        let janFirstWeekday = getWeekdayForFirstDayOfYear()
                        let emptyDays = janFirstWeekday // Remove the incorrect offset calculation

                        // Add empty spaces before first day of the year
                        ForEach(0..<emptyDays, id: \.self) { _ in
                            Rectangle()
                                .fill(Color.clear)
                                .frame(width: 6, height: 6)
                        }

                        // Fill with actual habit completion days
                        ForEach((0..<371).reversed(), id: \.self) { index in
                            let date = dateForIndex(index)
                            let completionRate = habitDataStore.getCompletionRateForDate(date)

                            Rectangle()
                                .fill(colorForCompletionRate(completionRate))
                                .frame(width: 6, height: 6)
                                .cornerRadius(2)
                        }
                    }
                }
            }
            .frame(maxWidth: .infinity)
        }
    }

    /// Generates the correct date for each index, in inverse order
    private func dateForIndex(_ index: Int) -> Date {
        let calendar = Calendar.current
        let today = Date()
        let components = calendar.dateComponents([.year], from: today)
        
        // Get January 1st of the current year
        let startOfYear = calendar.date(from: DateComponents(year: components.year, month: 1, day: 1)) ?? today
        return calendar.date(byAdding: .day, value: index, to: startOfYear) ?? today
    }

    /// Returns short month abbreviation like "Jan", "Feb"
    private func monthAbbreviation(month: Int) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale.current
        return dateFormatter.shortMonthSymbols[month - 1]
    }

    /// Determines in which week a given month starts
    private func getMonthStartWeek(month: Int) -> Int {
        let calendar = Calendar.current
        let today = Date()
        let components = calendar.dateComponents([.year], from: today)

        // Get the first day of the month
        let firstDayOfMonth = calendar.date(from: DateComponents(year: components.year, month: month, day: 1)) ?? today
        let weekOfYear = calendar.component(.weekOfYear, from: firstDayOfMonth)

        return weekOfYear - 1 // Adjust for zero-based indexing
    }

    /// Gets the weekday for January 1st (0 = Monday, 6 = Sunday)
    private func getWeekdayForFirstDayOfYear() -> Int {
        let calendar = Calendar.current
        let today = Date()
        let components = calendar.dateComponents([.year], from: today)
        
        // Get January 1st of the current year
        let janFirst = calendar.date(from: DateComponents(year: components.year, month: 1, day: 1)) ?? today
        
        // Convert Sunday-based weekday to Monday-based (1-7 to 0-6)
        let weekday = calendar.component(.weekday, from: janFirst)
        return (weekday + 5) % 7  // Transform Sunday=1 to Sunday=6
    }

    /// Determines color based on habit completion rate
    private func colorForCompletionRate(_ rate: Double) -> Color {
        if rate <= 0 {
            return Color.gray
        } else if rate < 0.25 {
            return Color.green.opacity(0.3)
        } else if rate < 0.5 {
            return Color.green.opacity(0.5)
        } else if rate < 0.75 {
            return Color.green.opacity(0.7)
        } else {
            return Color.green.opacity(0.9)
        }
    }
}

#Preview {
    YearCalendarView(habitDataStore: HabitDataStore.sampleDataStore)
        .padding()
        .background(Color.color1)
}
