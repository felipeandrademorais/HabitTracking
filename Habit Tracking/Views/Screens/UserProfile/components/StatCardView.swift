
import SwiftUI

struct StatCardView: View {
    let title: String
    let value: Int
    
    var body: some View {
        
        
        VStack(spacing: 8) {
            Text(title)
                .font(.custom("Poppins-Regular", size: 14))
                .foregroundColor(.fontSoft)
            Text("\(value)")
                .font(.custom("Poppins-Medium", size: 20))
                .foregroundColor(.fontSoft)
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(.calendarBackground)
        .cornerRadius(12)
    }
}
