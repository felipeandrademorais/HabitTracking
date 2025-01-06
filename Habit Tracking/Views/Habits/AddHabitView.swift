import SwiftUI

struct AddHabitView: View {
    @EnvironmentObject var dataStore: HabitDataStore
    @Environment(\.presentationMode) var presentationMode

    @State private var nome: String = ""
    @State private var cor: Color = .color1
    @State private var dataInicio = Date()
    @State private var repeticao: Repeticao = .diario

    var body: some View {
        Form {
            Section(header: Text("Informações do Hábito")) {
                TextField("Nome do hábito", text: $nome)

                DatePicker("Data de Início", selection: $dataInicio, displayedComponents: .date)

                Picker("Frequência", selection: $repeticao) {
                    ForEach(Repeticao.allCases, id: \.self) { freq in
                        Text(freq.rawValue).tag(freq)
                    }
                }
            }

            Section(header: Text("Cor")) {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        ForEach(predefinedColors, id: \.self) { color in
                            ColorCircleSelector(
                                color: color,
                                isSelected: cor == color
                            ) {
                                cor = color
                            }
                        }
                    }
                    .padding(4)
                }
            }

            Button(action: addHabit) {
                Text("Adicionar Hábito")
                    .frame(maxWidth: .infinity)
            }
            .disabled(nome.isEmpty)
        }
        .navigationTitle("Novo Hábito")
    }

    private func addHabit() {
        // Obtemos o índice da cor selecionada
        guard let index = predefinedColors.firstIndex(of: cor) else { return }
        
        // Convertemos para o nome associado ao índice
        let colorName = "color\(index + 1)" // Exemplo: "color1", "color2", etc.
        
        let newHabit = Habit(
            nome: nome,
            cor: colorName,
            dataInicio: dataInicio,
            repeticoes: repeticao
        )
        dataStore.addHabit(newHabit)
        presentationMode.wrappedValue.dismiss()
    }
}

struct ColorCircleSelector: View {
    let color: Color
    let isSelected: Bool
    let onTap: () -> Void

    var body: some View {
        Circle()
            .fill(color)
            .frame(width: 36, height: 36)
            .overlay(
                Circle()
                    .stroke(isSelected ? Color.black.opacity(0.5) : Color.clear, lineWidth: 2)
            )
            .padding(.trailing, 4)
            .onTapGesture {
                onTap()
            }
    }
}

// MARK: - Preview
struct AddHabitView_Previews: PreviewProvider {
    static var previews: some View {
        let dataStore = HabitDataStore()

        return NavigationView {
            AddHabitView()
                .environmentObject(dataStore)
        }
    }
}
