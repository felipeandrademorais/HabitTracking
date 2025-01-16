//
//  TaskCycleCardView.swift
//  Habit Tracking
//
//  Created by Felipe Morais on 15/01/25.
//
import SwiftUI

struct TaskCycleCardView: View {
    @State private var selectedCycle: CycleType = .weekly
    @State private var selectedDays: [String] = ["Seg", "Ter", "Qua", "Qui", "Sex"]

    let days = ["Dom", "Seg", "Ter", "Qua", "Qui", "Sex", "Sab"]

    var body: some View {
        VStack {
            Text("Set a cycle for your task")
                .font(Font.custom("Poppins-Regular", size: 14))
                .foregroundColor(.fontSoft)
            
            Divider()

            ZStack(alignment: .leading) {
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color.grayLigth)
                    .frame(height: 40)

                RoundedRectangle(cornerRadius: 20)
                    .fill(Color.color3)
                    .frame(width: UIScreen.main.bounds.width / 3 - 10, height: 40)
                    .animation(.spring(), value: selectedCycle)

                HStack(spacing: 0) {
                    ForEach(CycleType.allCases, id: \.self) { cycle in
                        Button(action: {
                            withAnimation(.spring()) {
                                selectedCycle = cycle
                            }
                        }) {
                            Text(cycle.rawValue)
                                .font(Font.custom("Poppins-Medium", size: 14))
                                .frame(width: buttonWidth())
                        }
                        .foregroundColor(.black)
                    }
                }
            }
            .frame(height: 40)

            Divider()

            // Days of the week
            HStack {
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
        .padding(8)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.calendarBackground)
        )
        .padding()
    }

    private func toggleDaySelection(_ day: String) {
        if selectedDays.contains(day) {
            selectedDays.removeAll { $0 == day }
        } else {
            selectedDays.append(day)
        }
    }
    
    // Calcula o deslocamento com base no ciclo selecionado
    private func getOffset(for cycle: CycleType) -> CGFloat {
        switch cycle {
        case .daily:
            return 0
        case .weekly:
            return (UIScreen.main.bounds.width / 3 - 20)
        case .monthly:
            return 2 * (UIScreen.main.bounds.width / 3 - 20)
        }
    }
    
    private func buttonWidth() -> CGFloat {
        (UIScreen.main.bounds.width - 32) / CGFloat(CycleType.allCases.count)
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
        TaskCycleCardView()
            .previewLayout(.sizeThatFits)
    }
}
