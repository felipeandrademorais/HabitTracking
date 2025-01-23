import SwiftUI

struct WatchHabitsTodayView: View {
    @EnvironmentObject var dataStore: HabitDataStore
    // Poderíamos deixar fixo ou criar um datePicker, mas no Watch
    // costuma-se simplificar para "hoje" mesmo.
    private let currentDate = Date()

    var body: some View {
        VStack {
            Text("Hábitos de Hoje")
                .font(.headline)
                .padding(.top, 8)

            if todaysHabits.isEmpty {
                Text("Nenhum hábito para hoje.")
                    .font(.footnote)
                    .padding()
            } else {
                // No watchOS, List funciona de forma parecida com iOS
                List(todaysHabits) { habit in
                    // Usamos uma versão adaptada do row
                    WatchHabitRowView(
                        habit: habit,
                        selectedDate: currentDate
                    )
                }
            }
        }
    }

    private var todaysHabits: [Habit] {
        dataStore.habits(for: currentDate)
    }
}

struct WatchHabitsTodayView_Previews: PreviewProvider {
    static var previews: some View {
        // Exemplo de preview, usando dados fictícios
        let dataStore = HabitDataStore.sampleDataStore
        return WatchHabitsTodayView()
            .environmentObject(dataStore)
    }
}