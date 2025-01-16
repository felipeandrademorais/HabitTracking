import SwiftUI

struct TaskCycleCardView: View {
    @State private var selectedCycle: CycleType = .weekly
    @State private var selectedDays: [String] = ["Seg", "Ter", "Qua", "Qui", "Sex"]

    let days = ["Dom", "Seg", "Ter", "Qua", "Qui", "Sex", "Sab"]

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Título
            Text("Set a cycle for your task")
                .font(Font.custom("Poppins-Regular", size: 14))
                .foregroundColor(.fontSoft)
            
            // Seleção do ciclo (diário, semanal, mensal)
            ZStack(alignment: .center) {
                // Fundo cinza
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color.grayLigth)
                    .frame(height: 40)

                GeometryReader { geometry in
                    // Calcula a largura de cada segmento dividindo a largura total
                    let segmentWidth = geometry.size.width / CGFloat(CycleType.allCases.count)
                    // Índice do enum selecionado
                    let index = CycleType.allCases.firstIndex(of: selectedCycle) ?? 0

                    // Retângulo laranja que “desliza” para o item selecionado
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color.color3)
                        .frame(width: segmentWidth, height: 40)
                        // offset de X para mover o retângulo
                        .offset(x: segmentWidth * CGFloat(index))
                        .animation(.spring(), value: selectedCycle)
                }
                .frame(height: 40)

                // Botões de seleção
                HStack(spacing: 0) {
                    ForEach(CycleType.allCases, id: \.self) { cycle in
                        Button(action: {
                            withAnimation(.spring()) {
                                selectedCycle = cycle
                            }
                        }) {
                            Text(cycle.rawValue)
                                .font(Font.custom("Poppins-Medium", size: 14))
                                .frame(maxWidth: .infinity) // cada botão ocupa espaço igual
                        }
                        .foregroundColor(.black)
                    }
                }
            }

            // Seleção de dias da semana
            HStack(spacing: 12) {
                ForEach(days, id: \.self) { day in
                    Button(action: {
                        toggleDaySelection(day)
                    }) {
                        Text(day)
                            .font(Font.custom("Poppins-Regular", size: 10))
                            .frame(width: 32, height: 32)
                            .background(
                                selectedDays.contains(day) ? Color.color3 : Color.grayLigth
                            )
                            .foregroundColor(.black)
                            .clipShape(Circle())
                    }
                }
            }
        }
        .padding(8)             // Margem vertical
        .listRowInsets(EdgeInsets())       // Remove padding adicional do Form
        .buttonStyle(PlainButtonStyle())   // Importante para não sobrescrever os botões
    }

    private func toggleDaySelection(_ day: String) {
        if selectedDays.contains(day) {
            selectedDays.removeAll { $0 == day }
        } else {
            selectedDays.append(day)
        }
    }
}

enum CycleType: String, CaseIterable {
    case daily = "Diario"
    case weekly = "Semanal"
    case monthly = "Mensal"
}

// Preview
struct TaskCycleCardView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            Form {
                TaskCycleCardView()
            }
        }
    }
}
