import SwiftUI

struct WeekDayHelper {
    static func localizedWeekdays() -> [(dayNumber: Int, dayName: String)] {
        let calendar = Calendar.current
        let symbols = calendar.shortWeekdaySymbols
        let firstWeekday = calendar.firstWeekday
        let count = symbols.count
        
        var orderedDays: [(Int, String)] = []
        for i in 0..<count {
            let dayNumber = ((firstWeekday - 1 + i) % count) + 1
            let dayName = symbols[dayNumber - 1].capitalized
            orderedDays.append((dayNumber, dayName))
        }
        return orderedDays
    }
}
