import SwiftUI

struct TaskCycleCardView: View {
    @Binding var selectedCycle: Repeticao
    @Binding var selectedDays: [String]
    private var weekDays: [String] {
        var calendar = Calendar.current
        calendar.locale = Locale.current
        return calendar.shortWeekdaySymbols.map { $0.capitalized }
    }

    var body: some View {
        VStack(alignment: .center, spacing: 16) {
            Text("Defina o ciclo do seu Hábito")
                .font(Font.custom("Poppins-Regular", size: 14))
                .foregroundColor(.fontSoft)

            ZStack(alignment: .leading) {
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color.grayLigth)
                    .frame(height: 40)

                GeometryReader { geometry in
                    let segmentWidth = geometry.size.width / CGFloat(Repeticao.allCases.count)
                    let index = Repeticao.allCases.firstIndex(of: selectedCycle) ?? 0

                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color.color3)
                        .frame(width: segmentWidth, height: 40)
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

            HStack(spacing: 12) {
                ForEach(weekDays, id: \.self) { day in
                    Button(action: {
                        toggleDaySelection(day)
                    }) {
                        Text(day.capitalized)
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
        .listRowInsets(EdgeInsets())
        .buttonStyle(PlainButtonStyle())
    }

    private func toggleDaySelection(_ day: String) {
        if selectedDays.contains(day) {
            selectedDays.removeAll { $0 == day }
        } else {
            selectedDays.append(day)
        }
    }
}

struct TaskCycleCardView_Previews: PreviewProvider {
    static var previews: some View {
        TaskCycleCardView(
            selectedCycle: .constant(.weekly),
            selectedDays: .constant(["Seg", "Ter", "Qua", "Qui", "Sex"])
        )
        .previewLayout(.sizeThatFits)
    }
}
