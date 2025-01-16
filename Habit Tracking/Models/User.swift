import SwiftUI

struct User: Identifiable, Codable {
    let id: UUID
    var name: String
    var avatar: String
}
