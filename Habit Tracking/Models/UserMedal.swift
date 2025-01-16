import SwiftUI

struct UserMedal: Identifiable, Codable {
    let id: UUID
    let medalID: UUID // Relaciona com a medalha
    let userID: UUID // Relaciona com o usuário
    var unlockedDate: Date
}
