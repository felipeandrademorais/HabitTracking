import SwiftUI

struct TaskCycleCardView: View {
    // Em vez de @State, agora usamos @Binding
    @Binding var selectedCycle: Repeticao
    @Binding var selectedDays: [String]

    var body: some View {
        VStack(alignment: .center, spacing: 16) {
            // Título
            Text("Defina o ciclo do seu Hábito")
                .font(Font.custom("Poppins-Regular", size: 14))
                .foregroundColor(.fontSoft)

            // Seleção do ciclo (Diário, Semanal, Mensal)
            ZStack(alignment: .leading) {
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color.grayLigth)
                    .frame(height: 40)

                GeometryReader { geometry in
                    let segmentWidth = geometry.size.width / CGFloat(Repeticao.allCases.count)
                    // Índice do ciclo selecionado
                    let index = Repeticao.allCases.firstIndex(of: selectedCycle) ?? 0

                    // Retângulo de fundo que se move até o botão selecionado
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color.color3)
                        .frame(width: segmentWidth, height: 40)
                        // Desloca conforme o índice selecionado
                        .offset(x: segmentWidth * CGFloat(index))
                        .animation(.spring(), value: selectedCycle)
                }
                .frame(height: 40)

                HStack(spacing: 0) {
                    ForEach(Repeticao.allCases, id: \.self) { cycle in
                        Button(action: {
                            withAnimation(.spring()) {
                                selectedCycle = cycle
                            }
                        }) {
                            Text(cycle.rawValue)
                                .font(Font.custom("Poppins-Medium", size: 14))
                                .frame(maxWidth: .infinity)
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
        .padding(.vertical, 8)
        .listRowInsets(EdgeInsets())       // Remove padding adicional do Form
        .buttonStyle(PlainButtonStyle())   // Impede que a linha do Form "roube" o toque
    }

    private func toggleDaySelection(_ day: String) {
        if selectedDays.contains(day) {
            selectedDays.removeAll { $0 == day }
        } else {
            selectedDays.append(day)
        }
    }
}

// Preview
struct TaskCycleCardView_Previews: PreviewProvider {
    static var previews: some View {
        // Usamos .constant(...) pois aqui no preview não temos um @State real
        TaskCycleCardView(
            selectedCycle: .constant(.weekly),
            selectedDays: .constant(["Seg", "Ter", "Qua", "Qui", "Sex"])
        )
        .previewLayout(.sizeThatFits)
    }
}
