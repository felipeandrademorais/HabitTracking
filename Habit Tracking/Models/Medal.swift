import SwiftUI

struct Medal: Identifiable, Codable {
    let id: UUID
    let name: String
    let description: String
    let icon: String
    let unlockCondition: String
    let criteria: MedalCriteria
}

enum MedalCriteria: Codable {
    case habitsQuantity(Int)
    case custom(String)
}
