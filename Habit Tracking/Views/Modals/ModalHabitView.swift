import SwiftUI

struct ModalHabitView: View {
    @EnvironmentObject var dataStore: HabitDataStore
    @Environment(\.presentationMode) var presentationMode
    
    private let isEdit: Bool
    private let habitToEdit: Habit?
    
    @State private var nome: String
    @State private var cor: Color
    @State private var dataInicio: Date
    @State private var selectedCycle: Repeticao
    @State private var selectedDays: [Int]
    @State private var iconName: String
    @State private var showIconPicker: Bool = false
    
    init(habit: Habit? = nil, startDate: Date = Date()) {
        self.habitToEdit = habit
        self.isEdit = habit != nil
        
        _nome = State(initialValue: habit?.nome ?? "")
        
        if let habit = habit {
            if let index = predefinedColors.firstIndex(where: { "color\((predefinedColors.firstIndex(of: $0) ?? 0) + 1)" == habit.cor }) {
                _cor = State(initialValue: predefinedColors[index])
            } else {
                _cor = State(initialValue: predefinedColors.first ?? .clear)
            }
        } else {
            _cor = State(initialValue: predefinedColors.first ?? .clear)
        }
        
        _dataInicio = State(initialValue: habit?.dataInicio ?? startDate)
        _selectedCycle = State(initialValue: habit?.repeticoes ?? .daily)
        _selectedDays = State(initialValue: habit?.diasDoHabito ?? [1, 2, 3, 4, 5])
        _iconName = State(initialValue: habit?.icon ?? "⭐️")
    }
    
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
                
                Section {
                    TaskCycleCardView(
                        selectedCycle: $selectedCycle,
                        selectedDays: $selectedDays
                    )
                    .padding()
                }
                
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
                
                Button(action: addOrUpdateHabit) {
                    Text(isEdit ? "Salvar" : "Adicionar")
                        .frame(maxWidth: .infinity)
                        .foregroundStyle(.fontSoft)
                }
                .disabled(nome.isEmpty)
            }
        }
        .scrollContentBackground(.hidden)
    }
    
    private func addOrUpdateHabit() {
        let impactMed = UIImpactFeedbackGenerator(style: .medium)
        impactMed.impactOccurred()
        
        guard let index = predefinedColors.firstIndex(of: cor) else { return }
        let colorName = "color\(index + 1)"
        
        if isEdit, let habit = habitToEdit {
            let updatedHabit = Habit(
                id: habit.id,
                nome: nome,
                cor: colorName,
                dataInicio: dataInicio,
                repeticoes: selectedCycle,
                diasDoHabito: selectedDays,
                icon: iconName
            )
            dataStore.updateHabit(updatedHabit)
        } else {
            let newHabit = Habit(
                nome: nome,
                cor: colorName,
                dataInicio: dataInicio,
                repeticoes: selectedCycle,
                diasDoHabito: selectedDays,
                icon: iconName
            )
            dataStore.addHabit(newHabit)
        }
        presentationMode.wrappedValue.dismiss()
    }
}

// MARK: - Preview
struct ModalHabitView_Previews: PreviewProvider {
    static var previews: some View {
        let dataStore = HabitDataStore()
        
        return NavigationView {
            ModalHabitView()
                .environmentObject(dataStore)
        }
    }
}
