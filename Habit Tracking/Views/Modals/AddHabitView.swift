import SwiftUI

struct AddHabitView: View {
    @EnvironmentObject var dataStore: HabitDataStore
    @Environment(\.presentationMode) var presentationMode

    @State private var nome: String = ""
    @State private var cor: Color = predefinedColors.first ?? .clear
    @State private var dataInicio = Date()
    @State private var repeticao: Repeticao = .diario

    // Ícone
    @State private var iconName: String = "⭐️"
    @State private var showIconPicker: Bool = false

    // Novas variáveis para o ciclo e para os dias
    @State private var selectedCycle: CycleType = .weekly
    @State private var selectedDays: [String] = ["Seg", "Ter", "Qua", "Qui", "Sex"]

    var body: some View {
        ZStack {
            Color.color2.ignoresSafeArea()
            
            Form {
                // Seção do Ícone
                Section {
                    VStack(spacing: 2) {
                        // Emoji principal
                        Text(iconName) // Usa o emoji selecionado
                            .font(.system(size: 65)) // Define o tamanho do emoji

                        // Texto de instrução
                        Text("Clique no ícone para alterá-lo")
                            .font(.system(size: 8))
                    }
                    .frame(maxWidth: .infinity)
                    .onTapGesture {
                        showIconPicker = true
                    }
                    
                    .popover(isPresented: $showIconPicker, arrowEdge: .bottom) {
                        IconPickerView(
                            selectedIcon: $iconName,
                            isPresented: $showIconPicker
                        )
                    }
                }
                .listRowBackground(Color.clear)
                
                // Seção do TextField (nome)
                Section {
                    TextField("Nome do hábito", text: $nome)
                        .font(Font.custom("Poppins-Regular", size: 14))
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
                
                // Seção do TaskCycleCardView
                Section {
                    TaskCycleCardView(
                        selectedCycle: $selectedCycle,
                        selectedDays: $selectedDays
                    )
                    .padding()
                }
                
                // Seção das cores
                Section(header: Text("")) {
                    ScrollView(.horizontal, showsIndicators: false) {
                        LazyHGrid(
                            rows: [GridItem(.fixed(40), spacing: 20)],
                            spacing: 20
                        ) {
                            ForEach(predefinedColors, id: \.self) { color in
                                ColorCircleSelector(
                                    color: color,
                                    isSelected: cor == color
                                ) {
                                    cor = color
                                }
                            }
                        }
                        .frame(maxWidth: .infinity)
                        .padding(4)
                    }
                }
                .listRowBackground(Color.clear)
                
                // Botão para adicionar Hábito
                Button(action: addHabit) {
                    Text("Adicionar Hábito")
                        .frame(maxWidth: .infinity)
                }
                .disabled(nome.isEmpty)
            }
        }
        .scrollContentBackground(.hidden)
    }

    private func addHabit() {
        // Converte a cor para o nome do asset
        guard let index = predefinedColors.firstIndex(of: cor) else { return }
        let colorName = "color\(index + 1)"

        let newHabit = Habit(
            nome: nome,
            cor: colorName,
            dataInicio: dataInicio,
            repeticoes: repeticao,
            icon: iconName
        )

        dataStore.addHabit(newHabit)
        presentationMode.wrappedValue.dismiss()
    }
}

// MARK: - Exemplo de ColorCircleSelector (inalterado)
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
                    .stroke(isSelected ? Color.black.opacity(0.5) : Color.white, lineWidth: 3)
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
