import SwiftUI
import WatchConnectivity

class WatchConnector: NSObject, WCSessionDelegate, ObservableObject {
    var session: WCSession

    // Referência fraca para evitar ciclos de retenção
    weak var habitDataStore: HabitDataStore?

    override init() {
        self.session = .default
        super.init()
        if WCSession.isSupported() {
            session.delegate = self
            session.activate()
        }
    }

    // MARK: - Envio de hábitos para o iPhone
    func sendHabitsToiPhone(_ habits: [Habit]) {
        guard session.isReachable else {
            print("iPhone não está disponível para mensagem imediata.")
            return
        }

        do {
            let data = try JSONEncoder().encode(habits)
            let message: [String: Any] = ["habits": data]
            print("Enviando hábitos para o iPhone: \(habits)")
            session.sendMessage(message, replyHandler: nil) { error in
                print("Erro ao enviar habits para iPhone: \(error)")
            }
        } catch {
            print("Erro ao codificar habits no Watch: \(error)")
        }
    }

    // MARK: - Recebendo dados do iPhone
    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        DispatchQueue.main.async {
            if let habitsData = message["habits"] as? Data {
                do {
                    let decodedHabits = try JSONDecoder().decode([Habit].self, from: habitsData)
                    // Atualize o HabitDataStore
                    self.habitDataStore?.habits = decodedHabits
                    self.habitDataStore?.saveHabits()

                    print("Habits recebidos no Watch: \(decodedHabits)")
                } catch {
                    print("Erro ao decodificar habits no Watch: \(error)")
                }
            } else {
                print("applicationContext data is nil ou key 'habits' não existe")
            }
        }
    }

    // MARK: - Recebendo Application Context
    func session(_ session: WCSession, didReceiveApplicationContext applicationContext: [String : Any]) {
        DispatchQueue.main.async {
            if let habitsData = applicationContext["habits"] as? Data {
                do {
                    let decodedHabits = try JSONDecoder().decode([Habit].self, from: habitsData)
                    self.habitDataStore?.habits = decodedHabits
                    self.habitDataStore?.saveHabits()

                    print("Habits recebidos no Watch via Application Context: \(decodedHabits)")
                } catch {
                    print("Erro ao decodificar habits no Watch via Application Context: \(error)")
                }
            } else {
                print("applicationContext data is nil ou key 'habits' não existe")
            }
        }
    }

    // MARK: - WCSessionDelegate
    func session(_ session: WCSession,
                 activationDidCompleteWith activationState: WCSessionActivationState,
                 error: Error?) {
        if let error = error {
            print("Erro na ativação do WCSession: \(error.localizedDescription)")
        } else {
            print("WCSession ativado, estado: \(activationState.rawValue)")
        }
    }

    // Implementar outros métodos WCSessionDelegate conforme necessário
}