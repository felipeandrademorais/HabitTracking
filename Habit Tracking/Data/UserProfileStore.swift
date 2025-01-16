import SwiftUI

class UserProfileStore: ObservableObject {
    @Published var user: User = User(id: UUID(), name: "John Doe", avatar: "person.circle.fill")
    @Published var medals: [Medal] = [
        Medal(id: UUID(), name: "Iniciante", description: "Complete 1 hábito", icon: "star.fill", unlockCondition: "1 hábito concluído"),
        Medal(id: UUID(), name: "Progresso", description: "Complete 10 hábitos", icon: "trophy.fill", unlockCondition: "10 hábitos concluídos")
    ]
    @Published var userMedals: [UserMedal] = []
    @Published var habits: [Habit] = []
    private let userKey = "userKey"

    init() {
        loadUser()
    }
    
    func loadUser() {
        guard let data = UserDefaults.standard.data(forKey: userKey) else { return }
        do {
            let decodedUser = try JSONDecoder().decode(User.self, from: data)
            self.user = decodedUser
        } catch {
            print("Erro ao decodificar user: \(error)")
        }
    }

    func saveUser() {
        do {
            let encoded = try JSONEncoder().encode(user)
            UserDefaults.standard.set(encoded, forKey: userKey)
        } catch {
            print("Erro ao codificar user: \(error)")
        }
    }
    
    func updateUserName(_ newName: String) {
           user.name = newName
       saveUser()
    }

    func addMedalToUser(medal: Medal) {
        let userMedal = UserMedal(id: UUID(), medalID: medal.id, userID: user.id, unlockedDate: Date())
        userMedals.append(userMedal)
        saveUser()
    }

    func completedHabitsCount() -> Int {
        habits.filter { !$0.datesCompleted.isEmpty }.count
    }

    func createdHabitsCount() -> Int {
        habits.count
    }
}
