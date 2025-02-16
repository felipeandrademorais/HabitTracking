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
        let calendar = Calendar.current
        let weekday = calendar.component(.weekday, from: date)

        return habits.filter { habit in
            let startOfHabitDate = calendar.startOfDay(for: habit.dataInicio)

            switch habit.repeticoes {
            case .daily:
                return startOfHabitDate <= startOfSelectedDate

            case .weekly:
                return startOfHabitDate <= startOfSelectedDate && habit.diasDoHabito.contains(weekday)

            case .monthly:
                let startDay = calendar.component(.day, from: startOfHabitDate)
                let selectedDay = calendar.component(.day, from: startOfSelectedDate)
                return startOfHabitDate <= startOfSelectedDate && startDay == selectedDay
            }
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
    
    func createdHabitsCount() -> Int {
        return habits.count
    }

    func completedHabitsCount() -> Int {
        return habits.filter { !$0.datesCompleted.isEmpty }.count
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
                repeticoes: .daily,
                datesCompleted: [],
                icon: "⭐️"
            ),
            Habit(
                nome: "Exercise",
                cor: "Color2",
                dataInicio: Date(),
                repeticoes: .daily,
                datesCompleted: [],
                icon: "🔥"
            )
        ]
        return store
    }
}
