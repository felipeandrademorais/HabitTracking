import SwiftUI

struct WeekView: View {
    let calendar = Calendar.current
    let today = Date()
    let onDaySelected: (Date) -> Void    

    @State private var selectedDate: Date?

    var weekDays: [Date] {
        guard let weekStart = calendar.dateInterval(of: .weekOfYear, for: today)?.start else {
            return []
        }
        return (0..<7).compactMap {
            calendar.date(byAdding: .day, value: $0, to: weekStart)
        }
    }

    var body: some View {
        ZStack(alignment: .top) {
            Color.color1
                .opacity(0.6)
                .ignoresSafeArea(.all)
            
            HStack(spacing: 8) {
                ForEach(weekDays, id: \.self) { day in
                    VStack(spacing: 4) {
                        Text(shortWeekdayName(for: day))
                            .font(Font.custom("Poppins-Medium", size: 12))
                            .foregroundColor(.fontSoft)
                            .fontWeight(isSelected(day) ? .bold : .regular)
                        ZStack {
                            Circle()
                                .fill(.white)
                                .frame(width: 32, height: 32)
                            
                            Text(dayNumber(for: day))
                                .font(Font.custom("Poppins-Medium", size: 12))
                                .foregroundColor(.black)
                                .fontWeight(isSelected(day) ? .bold : .regular)
                        }
                    }
                    .padding(6)
                    .background(
                        isSelected(day) ? .capsulePrimary : .capsuleSecundary
                    )
                    .cornerRadius(12)
                    .onTapGesture {
                        selectedDate = day
                        onDaySelected(day)
                    }
                }
            }
            .padding()
            .cornerRadius(12)
        }
    }

    func isSelected(_ date: Date) -> Bool {
        selectedDate != nil ? calendar.isDate(selectedDate!, inSameDayAs: date) : isToday(date)
    }

    func shortWeekdayName(for date: Date) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale.current
        formatter.dateFormat = "E"
        return formatter.string(from: date).prefix(3).capitalized
    }

    func dayNumber(for date: Date) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale.current
        formatter.dateFormat = "d"
        return formatter.string(from: date)
    }

    func isToday(_ date: Date) -> Bool {
        calendar.isDate(date, inSameDayAs: today)
    }
}

struct WeekView_Previews: PreviewProvider {
    static var previews: some View {
        WeekView(onDaySelected: { selectedDate in
            print("Selected date: \(selectedDate)")
        })
        .previewLayout(.sizeThatFits)
    }
}
