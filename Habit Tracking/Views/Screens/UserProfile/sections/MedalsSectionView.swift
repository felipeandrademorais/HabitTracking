import SwiftUI

struct MedalsSectionView: View {
    @ObservedObject var profileStore: UserProfileStore
    var habitDataStore: HabitDataStore

    var body: some View {
        VStack(spacing: 16) {
            Text("Medalhas")
                .font(.custom("Poppins-SemiBold", size: 16))
                .foregroundColor(.fontSoft)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    ForEach(profileStore.getMedalsStatus(habitDataStore: habitDataStore), id: \.medal.id) { medalStatus in
                        MedalCardView(medalStatus: medalStatus)
                    }
                }
                .padding(.vertical, 4)
            }
        }
        .padding(.top, 12)
    }
}


