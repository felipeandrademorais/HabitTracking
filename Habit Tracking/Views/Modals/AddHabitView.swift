import SwiftUI

struct AddHabitView: View {
    @EnvironmentObject var dataStore: HabitDataStore
    @Environment(\.presentationMode) var presentationMode

    @State private var nome: String = ""
    @State private var cor: Color = predefinedColors.first ?? .clear
    @State private var dataInicio = Date()
    @State private var repeticao: Repeticao = .daily
    @State private var iconName: String = "⭐️"
    @State private var showIconPicker: Bool = false
    @State private var selectedCycle: Repeticao = .weekly
    @State private var selectedDays: [String] = ["Seg", "Ter", "Qua", "Qui", "Sex"]

    var body: some View {
        ZStack {
            Color.color2.ignoresSafeArea()
            
            Form {
                Section {
                    VStack(spacing: 2) {
                        Text(iconName)
                            .font(.system(size: 60))

                        Text("Clique no ícone para alterá-lo")
                            .font(Font.custom("Poppins-Regular", size: 10))
                    }
                    .frame(maxWidth: .infinity)
                    .onTapGesture {
                        showIconPicker = true
                    }
                    .sheet(isPresented: $showIconPicker) {
                        IconPickerView(
                            selectedIcon: $iconName,
                            isPresented: $showIconPicker
                        )
                        .presentationDetents([.fraction(0.4)])
                        .presentationDragIndicator(.visible)
                    }
                }
                .listRowBackground(Color.white.opacity(0.001))
                
                
                Section {
                    TextField("Nome do hábito", text: $nome)
                        .font(Font.custom("Poppins-Regular", size: 14))
                        .padding(.vertical, 10)
                        .overlay(
                            Rectangle()
                                .frame(height: 1.8)
                                .foregroundColor(.fontSoft)
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
                Section {
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
                    .padding()
                }
                .listRowBackground(Color.white.opacity(0.001))
                
                // Botão para adicionar Hábito
                Button(action: addHabit) {
                    Text("Adicionar")
                        .frame(maxWidth: .infinity)
                        .foregroundStyle(.fontSoft)
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
