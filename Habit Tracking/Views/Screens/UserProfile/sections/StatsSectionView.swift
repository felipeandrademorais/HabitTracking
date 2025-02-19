import SwiftUI

struct StatsSectionView: View {
    var habitDataStore: HabitDataStore
    var body: some View {
        
        
        VStack(spacing: 16) {
            Text("Estatísticas")
                .font(.custom("Poppins-SemiBold", size: 16))
                .foregroundColor(.fontSoft)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            HStack(spacing: 16) {
                StatCardView(title: "Hábitos Criados", value: habitDataStore.createdHabitsCount())
                StatCardView(title: "Habitos Completos", value: habitDataStore.completedHabitsCount())
            }
        }
    }
}

