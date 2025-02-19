import SwiftUI

class UserProfileStore: ObservableObject {
    @Published var user: User = User(id: UUID(), name: "Click para alterar o seu nome", avatar: "person.circle.fill")
    @Published var medals: [Medal] = [
            Medal(id: UUID(), name: "Iniciante", description: "Complete 1 hábito", icon: "star.fill", unlockCondition: "Complete 1 hábito", criteria: .habitsQuantity(1)),
            Medal(id: UUID(), name: "Progresso", description: "Complete 10 hábitos", icon: "trophy.fill", unlockCondition: "Complete 10 hábitos", criteria: .habitsQuantity(10))
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
    
    
    func getMedalsStatus() -> [MedalStatus] {
        return medals.map { medal in
            let isUnlocked = validateMedal(medal)
            return MedalStatus(medal: medal, isUnlocked: isUnlocked)
        }
    }

    private func validateMedal(_ medal: Medal) -> Bool {
        switch medal.criteria {
        case .habitsQuantity(let quantity):
            return completedHabitsCount() >= quantity
        case .custom(_):
            return false
        }
    }
    
    /// Retorna uma lista de medalhas com status habilitado/desabilitado
    func getMedalsStatus(habitDataStore: HabitDataStore) -> [MedalStatus] {
        return medals.map { medal in
            let isUnlocked = validateMedal(medal, habitDataStore: habitDataStore)
            return MedalStatus(medal: medal, isUnlocked: isUnlocked)
        }
    }

    /// Valida se uma medalha deve ser habilitada
    private func validateMedal(_ medal: Medal, habitDataStore: HabitDataStore) -> Bool {
        switch medal.criteria {
        case .habitsQuantity(let quantity):
            return habitDataStore.completedHabitsCount() >= quantity
        case .custom(_):
            // Regras customizadas podem ser adicionadas aqui no futuro
            return false
        }
    }
}

struct MedalStatus {
    let medal: Medal
    let isUnlocked: Bool
}
