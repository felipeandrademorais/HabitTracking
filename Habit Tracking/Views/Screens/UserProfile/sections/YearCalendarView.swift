import SwiftUI

struct YearCalendarView: View {
    var habitDataStore: HabitDataStore
    private let rows = Array(repeating: GridItem(.fixed(10), spacing: 4), count: 7)
    
    var body: some View {
        VStack(spacing: 2) {
            Text("Atividade Anual")
                .font(.custom("Poppins-SemiBold", size: 16))
                .foregroundColor(.fontSoft)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            VStack(spacing: 2) {
                // Month Labels
                HStack(spacing: 0) {
                    Text("")
                        .frame(width: 30)
                }
                
                HStack(spacing: 4) {
                    // Weekday labels
                    VStack(spacing: 4) {
                        ForEach(["Dom", "Seg", "Ter", "Qua", "Qui", "Sex", "Sáb"], id: \.self) { day in
                            Text(day)
                                .font(.custom("Poppins-Regular", size: 8))
                                .foregroundColor(.fontSoft)
                                .frame(width: 30, alignment: .trailing)
                        }
                    }
                    
                    // Year Grid
                    ScrollView(.horizontal) {
                        LazyHGrid(rows: rows, spacing: 4) {
                            ForEach(0..<53, id: \.self) { weekIndex in
                                ForEach(0..<7, id: \.self) { dayIndex in
                                    let date = dateForWeekAndDay(weekIndex: weekIndex, dayIndex: dayIndex)
                                    if let date = date {
                                        let completionRate = habitDataStore.getCompletionRateForDate(date)
                                        Rectangle()
                                            .fill(colorForCompletionRate(completionRate))
                                            .frame(width: 10, height: 10)
                                            .cornerRadius(3)
                                    }
                                }
                            }
                        }
                        .padding()
                    }
                }
            }
            .background(Color.white.opacity(0.05))
            .cornerRadius(8)
        }
    }
    
    /// Generates the date for a given week and day index
    private func dateForWeekAndDay(weekIndex: Int, dayIndex: Int) -> Date? {
        let calendar = Calendar.current
        let today = Date()
        let components = calendar.dateComponents([.year], from: today)
        
        // Get January 1st of the current year
        guard let startOfYear = calendar.date(from: DateComponents(year: components.year, month: 1, day: 1)) else {
            return nil
        }
        
        // Get the first day of the first week
        let firstWeekday = calendar.component(.weekday, from: startOfYear)
        let daysToAdd = weekIndex * 7 + dayIndex
        
        // Calculate the actual date
        let date = calendar.date(byAdding: .day, value: daysToAdd - (firstWeekday - 1), to: startOfYear)
        
        // Only return dates within the current year
        if let date = date,
           let year = components.year,
           calendar.component(.year, from: date) == year {
            return date
        }
        return nil
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
        guard let firstDayOfMonth = calendar.date(from: DateComponents(year: components.year, month: month, day: 1)) else {
            return 0
        }
        
        // Get the first day of the year
        guard let startOfYear = calendar.date(from: DateComponents(year: components.year, month: 1, day: 1)) else {
            return 0
        }
        
        // Calculate the week difference
        let weekOfYear = calendar.component(.weekOfYear, from: firstDayOfMonth)
        let firstWeekOfYear = calendar.component(.weekOfYear, from: startOfYear)
        return weekOfYear - firstWeekOfYear
    }
    
    /// Determines color based on habit completion rate
    private func colorForCompletionRate(_ rate: Double) -> Color {
        if rate <= 0 {
            return Color.gray.opacity(0.1)
        } else if rate < 0.25 {
            return Color.gray.opacity(0.3)
        } else if rate < 0.5 {
            return Color.green.opacity(0.5)
        } else if rate < 0.75 {
            return Color.green.opacity(0.7)
        } else {
            return Color.green
        }
    }
}

#Preview {
    YearCalendarView(habitDataStore: HabitDataStore.sampleDataStore)
        .padding()
        .background(Color.color1)
}
