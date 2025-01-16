import SwiftUI

struct Habit: Identifiable, Codable {
    let id: UUID
    var nome: String
    var cor: String
    var dataInicio: Date
    var repeticoes: Repeticao
    var datesCompleted: [Date]
    var icon: String

    init(
        id: UUID = UUID(),
        nome: String,
        cor: String,
        dataInicio: Date,
        repeticoes: Repeticao,
        datesCompleted: [Date] = [],
        icon: String
    ) {
        self.id = id
        self.nome = nome
        self.cor = cor
        self.dataInicio = dataInicio
        self.repeticoes = repeticoes
        self.datesCompleted = datesCompleted
        self.icon = icon
    }
}
