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
            let decoded = try Migration.migrateIfNeeded(data)
            self.habits = decoded
        } catch {
            print("Error decoding habits: \(error)")
        }
    }

    func saveHabits() {
        do {
            let encoded = try JSONEncoder().encode(habits)
            UserDefaults.standard.set(encoded, forKey: habitsKey)
        } catch {
            print("Error encoding habits: \(error)")
        }
    }

    func addHabit(_ habit: Habit) {
        habits.append(habit)
        saveHabits()
        if habit.notificationsEnabled {
            NotificationManager.shared.scheduleNotification(for: habit) { success, error in
                if !success, let errorMessage = error {
                    NotificationCenter.default.post(
                        name: NSNotification.Name("ShowNotificationError"),
                        object: nil,
                        userInfo: ["message": errorMessage]
                    )
                } else if success {
                    NotificationCenter.default.post(
                        name: NSNotification.Name("ShowNotificationSuccess"),
                        object: nil
                    )
                }
            }
        }
    }

    func updateHabit(_ habit: Habit) {
        if let index = habits.firstIndex(where: { $0.id == habit.id }) {
            habits[index].nome = habit.nome
            habits[index].cor = habit.cor
            habits[index].dataInicio = habit.dataInicio
            habits[index].repeticoes = habit.repeticoes
            habits[index].diasDoHabito = habit.diasDoHabito
            habits[index].icon = habit.icon
            habits[index].notificationsEnabled = habit.notificationsEnabled
            habits[index].notificationTime = habit.notificationTime
            if !habit.datesCompleted.isEmpty {
                habits[index].datesCompleted = habit.datesCompleted
            }

            saveHabits()
            if habit.notificationsEnabled {
                NotificationManager.shared.scheduleNotification(for: habit) { success, error in
                    if !success, let errorMessage = error {
                        NotificationCenter.default.post(
                            name: NSNotification.Name("ShowNotificationError"),
                            object: nil,
                            userInfo: ["message": errorMessage]
                        )
                    } else if success {
                        NotificationCenter.default.post(
                            name: NSNotification.Name("ShowNotificationSuccess"),
                            object: nil
                        )
                    }
                }
            } else {
                NotificationManager.shared.removeNotifications(for: habit)
            }
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
        NotificationManager.shared.removeNotifications(for: habit)
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
    
    func getCompletionRateForDate(_ date: Date) -> Double {
        let startOfSelectedDate = Calendar.current.startOfDay(for: date)
        
        let activeHabits = habits.filter {
            Calendar.current.startOfDay(for: $0.dataInicio) <= startOfSelectedDate
            && $0.diasDoHabito.contains(Calendar.current.component(.weekday, from: startOfSelectedDate))
        }
        
        let totalHabits = activeHabits.count
        let completedHabits = activeHabits.filter { $0.isCompleted(on: date) }.count
        
        return totalHabits > 0 ? Double(completedHabits) / Double(totalHabits) : 0.001
    }
}

extension HabitDataStore {
    static var sampleDataStore: HabitDataStore {
        let store = HabitDataStore()
        store.habits = [
            Habit(
                nome: "Read",
                cor: "color1",
                dataInicio: Date().addingTimeInterval(-86400),
                repeticoes: .daily,
                datesCompleted: [],
                icon: "⭐️"
            ),
            Habit(
                nome: "Exercise",
                cor: "color2",
                dataInicio: Date(),
                repeticoes: .daily,
                datesCompleted: [],
                icon: "🔥"
            )
        ]
        return store
    }
}
