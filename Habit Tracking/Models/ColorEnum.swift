import SwiftUI

let predefinedColors: [Color] = [
    Color("color1"),
    Color("color2"),
    Color("color3"),
    Color("color4"),
    Color("color5")
]

enum ColorEnum: String, CaseIterable {
    case color1 = "color1"
    case color2 = "color2"
    case color3 = "color3"
    case color4 = "color4"
    case color5 = "color5"
    
    var color: Color {
        switch self {
            case .color1: return .color1
            case .color2: return .color2
            case .color3: return .color3
            case .color4: return .color4
            case .color5: return .color5
        }
    }
}
