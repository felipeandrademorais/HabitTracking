import SwiftUI

struct Habit: Identifiable, Codable {
    let id: UUID
    var nome: String
    var cor: String
    var dataInicio: Date
    var repeticoes: Repeticao
    var diasDoHabito: [Int]
    var datesCompleted: [Date]
    var icon: String
    var notificationsEnabled: Bool
    var notificationTime: Date?

    init(
        id: UUID = UUID(),
        nome: String,
        cor: String,
        dataInicio: Date,
        repeticoes: Repeticao,
        diasDoHabito: [Int] = [],
        datesCompleted: [Date] = [],
        icon: String,
        notificationsEnabled: Bool = false,
        notificationTime: Date? = nil
    ) {
        self.id = id
        self.nome = nome
        self.cor = cor
        self.dataInicio = dataInicio
        self.repeticoes = repeticoes
        self.diasDoHabito = diasDoHabito
        self.datesCompleted = datesCompleted
        self.icon = icon
        self.notificationsEnabled = notificationsEnabled
        self.notificationTime = notificationTime
    }
    
    func isCompleted(on date: Date) -> Bool {
        let selectedDay = Calendar.current.startOfDay(for: date)
        return datesCompleted.contains { completedDate in
            Calendar.current.startOfDay(for: completedDate) == selectedDay
        }
    }
}
