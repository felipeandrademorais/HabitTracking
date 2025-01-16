import SwiftUI

class HabitDataStore: ObservableObject {
    @Published var habits: [Habit] = []
    
    private let habitsKey = "habitsKey"

    init() {
        loadHabits()
    }

    func loadHabits() {
        guard let data = UserDefaults.standard.data(forKey: habitsKey) else { return }
        do {
            let decoded = try JSONDecoder().decode([Habit].self, from: data)
            self.habits = decoded
        } catch {
            print("Erro ao decodificar habits: \(error)")
        }
    }

    func saveHabits() {
        do {
            let encoded = try JSONEncoder().encode(habits)
            UserDefaults.standard.set(encoded, forKey: habitsKey)
        } catch {
            print("Erro ao codificar habits: \(error)")
        }
    }

    func addHabit(_ habit: Habit) {
        habits.append(habit)
        saveHabits()
    }

    func updateHabit(_ habit: Habit) {
        if let index = habits.firstIndex(where: { $0.id == habit.id }) {
            habits[index] = habit
            saveHabits()
        }
    }
    
    func habits(for date: Date) -> [Habit] {
        let startOfSelectedDate = Calendar.current.startOfDay(for: date)
        
        return habits.filter { habit in
            let startOfHabitDate = Calendar.current.startOfDay(for: habit.dataInicio)
            return startOfHabitDate <= startOfSelectedDate
        }
        .sorted { $0.datesCompleted.isEmpty && !$1.datesCompleted.isEmpty }
    }

    func removeHabit(_ habit: Habit) {
        habits.removeAll { $0.id == habit.id }
        saveHabits()
    }
    
    func debugClearAllData() {
        UserDefaults.standard.removeObject(forKey: habitsKey)
        self.habits = []
    }
}

extension HabitDataStore {
    static var sampleDataStore: HabitDataStore {
        let store = HabitDataStore()
        store.habits = [
            Habit(
                nome: "Read",
                cor: "Color1",
                dataInicio: Date().addingTimeInterval(-86400),
                repeticoes: .diario,
                datesCompleted: [],
                icon: "⭐️"
            ),
            Habit(
                nome: "Exercise",
                cor: "Color2",
                dataInicio: Date(),
                repeticoes: .diario,
                datesCompleted: [],
                icon: "🔥"
            )
        ]
        return store
    }
}
