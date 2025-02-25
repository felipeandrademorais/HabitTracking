import Foundation

class Migration {
    enum MigrationError: Error {
        case decodingError
    }
    
    static func migrateIfNeeded(_ data: Data) throws -> [Habit] {
        let decoder = JSONDecoder()
        
        // First, try to decode with the current model
        if let habits = try? decoder.decode([Habit].self, from: data) {
            return habits
        }
        
        // If current model fails, try to decode with a custom approach
        guard let json = try? JSONSerialization.jsonObject(with: data) as? [[String: Any]] else {
            throw MigrationError.decodingError
        }
        
        // Migrate each habit with default values for new properties
        return json.map { habitDict in
            let id = UUID(uuidString: habitDict["id"] as? String ?? "") ?? UUID()
            let nome = habitDict["nome"] as? String ?? "Untitled Habit"
            let cor = habitDict["cor"] as? String ?? "color1"
            let dataInicio = (habitDict["dataInicio"] as? Date) ?? Date()
            let repeticoesRaw = habitDict["repeticoes"] as? String ?? "daily"
            let repeticoes = Repeticao(rawValue: repeticoesRaw) ?? .daily
            let diasDoHabito = habitDict["diasDoHabito"] as? [Int] ?? []
            let datesCompleted = habitDict["datesCompleted"] as? [Date] ?? []
            let icon = habitDict["icon"] as? String ?? "⭐️"
            
            return Habit(
                id: id,
                nome: nome,
                cor: cor,
                dataInicio: dataInicio,
                repeticoes: repeticoes,
                diasDoHabito: diasDoHabito,
                datesCompleted: datesCompleted,
                icon: icon
            )
        }
    }
}
