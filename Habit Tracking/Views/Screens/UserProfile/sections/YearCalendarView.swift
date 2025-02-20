import SwiftUI

struct YearCalendarView: View {
    var habitDataStore: HabitDataStore
    private let columns = Array(repeating: GridItem(.fixed(6), spacing: 1), count: 53)
    private let rows = Array(repeating: GridItem(.fixed(6), spacing: 1), count: 7)
    
    var body: some View {
        VStack(spacing: 16) {
            Text("Atividade Anual")
                .font(.custom("Poppins-SemiBold", size: 16))
                .foregroundColor(.fontSoft)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            HStack(alignment: .top, spacing: 4) {
                VStack(spacing: 6) {
                    ForEach(["Mon", "Wed", "Fri"], id: \.self) { day in
                        Text(day)
                            .font(.custom("Poppins-Regular", size: 6))
                            .foregroundColor(.fontSoft)
                            .frame(height: 8)
                    }
                }
                .padding(.top, 20)
                
                VStack(alignment: .leading) {
                    HStack(spacing: 20) {
                        ForEach(0..<12) { month in
                            Text(monthAbbreviation(month: month + 1))
                                .font(.custom("Poppins-Regular", size: 6))
                                .foregroundColor(.fontSoft)
                        }
                    }
                    .padding(.leading, 8)
                    
                    LazyVGrid(columns: columns, spacing: 2) {
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
    
    private func dateForIndex(_ index: Int) -> Date {
        let calendar = Calendar.current
        let today = Date()
        let startOfYear = calendar.date(byAdding: .day, value: -371, to: today) ?? today
        let calculatedDate = calendar.date(byAdding: .day, value: index, to: startOfYear) ?? today
        return calculatedDate
    }
    
    private func monthAbbreviation(month: Int) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale.current
        return dateFormatter.shortMonthSymbols[month - 1]
    }

    private func colorForCompletionRate(_ rate: Double) -> Color {
        if rate <= 0 {
            return Color.gray
        } else if rate < 0.25 {
            return Color.gray.opacity(0.3)
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
