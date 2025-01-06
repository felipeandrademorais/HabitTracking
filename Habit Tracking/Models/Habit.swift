import SwiftUI

struct Habit: Identifiable, Codable {
    let id: UUID
    var nome: String
    var cor: String
    var dataInicio: Date
    var repeticoes: Repeticao
    var datesCompleted: [Date]

    init(
        id: UUID = UUID(),
        nome: String,
        cor: String,
        dataInicio: Date,
        repeticoes: Repeticao,
        datesCompleted: [Date] = []
    ) {
        self.id = id
        self.nome = nome
        self.cor = cor
        self.dataInicio = dataInicio
        self.repeticoes = repeticoes
        self.datesCompleted = datesCompleted
    }
}
