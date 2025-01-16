
import SwiftUI

struct Medal: Identifiable, Codable {
    let id: UUID
    var name: String
    var description: String
    var icon: String // Nome do ícone da medalha
    var unlockCondition: String // Exemplo: "Complete 10 tarefas"
}
