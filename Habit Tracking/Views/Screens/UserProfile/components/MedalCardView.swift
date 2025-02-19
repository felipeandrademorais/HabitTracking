import SwiftUI

struct MedalCardView: View {
    let medalStatus: MedalStatus

    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: medalStatus.medal.icon)
                .resizable()
                .scaledToFit()
                .frame(width: 40, height: 40)
                .foregroundColor(medalStatus.isUnlocked ? .yellow : .fontSoft.opacity(0.4))
            Text(medalStatus.medal.name)
                .font(.custom("Poppins-Regular", size: 12))
                .foregroundColor(medalStatus.isUnlocked ? .fontSoft : .fontSoft.opacity(0.4))
        }
        .padding()
        .background(Color.calendarBackground)
        .cornerRadius(10)
        .shadow(color: Color.black.opacity(0.05), radius: 2, x: 0, y: 2)
    }
}
