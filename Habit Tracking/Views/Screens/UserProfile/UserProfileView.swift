import SwiftUI

struct UserProfileView: View {
    @EnvironmentObject private var habitDataStore: HabitDataStore
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

    // MARK: - Seção de Estatísticas (Tasks Created / Completed)
    private var statsSection: some View {
        VStack(spacing: 16) {
            Text("Estatísticas")
                .font(.custom("Poppins-SemiBold", size: 16))
                .foregroundColor(.fontSoft)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            HStack(spacing: 16) {
                statCard(title: "Hábitos Criados", value: habitDataStore.createdHabitsCount())
                statCard(title: "Habitos Completos", value: habitDataStore.completedHabitsCount())
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
                .foregroundColor(.fontSoft)
                .frame(maxWidth: .infinity, alignment: .leading)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    ForEach(profileStore.getMedalsStatus(habitDataStore: habitDataStore), id: \.medal.id) { medalStatus in
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
                        .background(.calendarBackground)
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
            .environmentObject(HabitDataStore.sampleDataStore)
    }
}
