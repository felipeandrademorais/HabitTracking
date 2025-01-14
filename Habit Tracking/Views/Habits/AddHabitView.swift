import SwiftUI

struct AddHabitView: View {
    @EnvironmentObject var dataStore: HabitDataStore
    @Environment(\.presentationMode) var presentationMode

    @State private var nome: String = ""
    @State private var cor: Color = .color1
    @State private var dataInicio = Date()
    @State private var repeticao: Repeticao = .diario

    var body: some View {
        ZStack {
            Color.blue.edgesIgnoringSafeArea(.all)
            
            Form {
                Section() {
                    TextField("Nome do hábito", text: $nome)
                        .background(Color.white)
                        .padding(.vertical, 10)
                        .overlay(
                            Rectangle()
                                .frame(height: 1.8)
                                .foregroundColor(.blackSoft.opacity(0.4))
                                .padding(.top, 40),
                            alignment: .bottom
                        )
                        .padding(.bottom, 12)
                }
                
                Section() {
                    DatePicker(
                        "Data de Início",
                        selection: $dataInicio,
                        displayedComponents: .date
                    )
                }
                
                Picker("Frequência", selection: $repeticao) {
                    ForEach(Repeticao.allCases, id: \.self) { freq in
                        Text(freq.rawValue).tag(freq)
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
            .background(Color.blue)
        }
    }

    private func addHabit() {
        guard let index = predefinedColors.firstIndex(of: cor) else { return }
        let colorName = "color\(index + 1)"
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
            .frame(width: 32, height: 32)
            .overlay(
                Circle()
                    .stroke(isSelected ? Color.black.opacity(0.5) : Color.white, lineWidth: 2)
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
