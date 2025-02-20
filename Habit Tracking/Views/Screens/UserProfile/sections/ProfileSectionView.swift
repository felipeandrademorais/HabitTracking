import SwiftUI

struct ProfileSectionView: View {
    @ObservedObject var profileStore: UserProfileStore
    @Binding var showEditNameModal: Bool
    @State private var showEditAvatarModal = false
    
    var body: some View {
        Section {
            VStack(spacing: 16) {
                Image(profileStore.user.avatar.isEmpty ? "no-avatar" : profileStore.user.avatar)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100)
                    .clipShape(Circle())
                    .onTapGesture {
                        showEditAvatarModal = true
                    }
                
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
        .sheet(isPresented: $showEditAvatarModal) {
            EditAvatarModalView()
                .environmentObject(profileStore)
                .presentationDetents([.fraction(0.5)])
                .presentationDragIndicator(.visible)
        }
    }
}
