import SwiftUI

struct UserProfileView: View {
    @StateObject private var profileStore = UserProfileStore()
    @State private var showEditNameModal = false
    
    var body: some View {
        ZStack {
            Color(.color1).ignoresSafeArea()
            VStack(spacing: 0) {
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 24) {
                        profileSection
                        Spacer()
                        statsSection
                        medalsSection
                    }
                    .padding()
                }
            }
        }
        .sheet(isPresented: $showEditNameModal) {
            EditNameModalView()
                .environmentObject(profileStore)
                .presentationDetents([.fraction(0.4)])
                .presentationDragIndicator(.visible)
        }
    }

    // MARK: - Seção de Perfil (Avatar + Nome)
    private var profileSection: some View {
        Section {
            VStack(spacing: 16) {
                Image(systemName: profileStore.user.avatar)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100)
                    .clipShape(Circle())
                
                // Nome e botão de edição
                HStack(alignment: .center, spacing: 8) {
                    Text(profileStore.user.name)
                        .font(.custom("Poppins-Medium", size: 20))
                        .foregroundColor(.black)
                        .onTapGesture {
                            showEditNameModal = true
                        }
                        .overlay(
                            Rectangle()
                                .frame(height: 1.8)
                                .foregroundColor(.blackSoft.opacity(0.4))
                                .padding(.top, 40),
                            alignment: .bottom
                        )
                }
            }
        }
    }

    // MARK: - Seção de Estatísticas (Tasks Created / Completed)
    private var statsSection: some View {
        VStack(spacing: 16) {
            Text("Estatísticas")
                .font(.custom("Poppins-SemiBold", size: 16))
                .foregroundColor(.black)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            HStack(spacing: 16) {
                statCard(title: "Hábitos Criados", value: profileStore.createdHabitsCount())
                statCard(title: "Habitos Completos", value: profileStore.completedHabitsCount())
            }
        }
    }

    private func statCard(title: String, value: Int) -> some View {
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

    // MARK: - Seção de Medalhas
    private var medalsSection: some View {
        VStack(spacing: 16) {
            Text("Medalhas")
                .font(.custom("Poppins-SemiBold", size: 16))
                .foregroundColor(.black)
                .frame(maxWidth: .infinity, alignment: .leading)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    ForEach(profileStore.medals) { medal in
                        VStack(spacing: 8) {
                            Image(systemName: medal.icon)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 40, height: 40)
                                .foregroundColor(
                                    profileStore.userMedals.contains(where: { $0.medalID == medal.id })
                                    ? .yellow
                                    : .gray.opacity(0.4)
                                )
                            Text(medal.name)
                                .font(.custom("Poppins-Regular", size: 12))
                                .foregroundColor(profileStore.userMedals.contains(where: { $0.medalID == medal.id })
                                                 ? .fontSoft
                                                 : .gray.opacity(0.4))
                        }
                        .padding()
                        .background(Color.white)
                        .cornerRadius(10)
                        .shadow(color: .black.opacity(0.05), radius: 2, x: 0, y: 2)
                    }
                }
                .padding(.vertical, 4)
            }
        }
        .padding(.top, 12)
    }
}

// MARK: - Preview

struct UserProfileView_Previews: PreviewProvider {
    static var previews: some View {
        UserProfileView()
            .environmentObject(UserProfileStore())
    }
}
