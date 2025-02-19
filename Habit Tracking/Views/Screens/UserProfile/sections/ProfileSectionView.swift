import SwiftUI

struct ProfileSectionView: View {
    @ObservedObject var profileStore: UserProfileStore
    @Binding var showEditNameModal: Bool
    
    var body: some View {
        Section {
            VStack(spacing: 16) {
                Image(systemName: profileStore.user.avatar)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100)
                    .clipShape(Circle())
                
                HStack(alignment: .center, spacing: 8) {
                    Text(profileStore.user.name)
                        .font(.custom("Poppins-Medium", size: 20))
                        .foregroundColor(.fontSoft)
                        .onTapGesture {
                            showEditNameModal = true
                        }
                        .overlay(
                            Rectangle()
                                .frame(height: 1.8)
                                .foregroundColor(.fontSoft.opacity(0.4))
                                .padding(.top, 40),
                            alignment: .bottom
                        )
                }
            }
        }
    }
}
