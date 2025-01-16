import SwiftUI

struct TabItem: Identifiable {
    let id = UUID()
    let tag: String
    let icon: String
    let content: AnyView
}
