import SwiftUI

struct CalendarDayCell: View {
    @EnvironmentObject var dataStore: HabitDataStore

    let date: Date
    let isSelected: Bool
    let onSelect: () -> Void

    var body: some View {
        let completionOpacity = dataStore.getCompletionRateForDate(date)
        let shouldShowMedal = completionOpacity == 1.0

        ZStack(alignment: .topTrailing) {
            Text("\(Calendar.current.component(.day, from: date))")
                .frame(minWidth: 40, minHeight: 40)
                .background(
                    isSelected ? Color.blueSoft :
                        Color.green.opacity(completionOpacity)
                )
                .cornerRadius(20)
                .onTapGesture {
                    onSelect()
                }
                .foregroundColor(.fontSoft)
                .font(Font.custom("Poppins-Medium", size: 16))
            
            if shouldShowMedal {
                Image("reward1")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 15, height: 15)
                    .offset(x: 4, y: -4)
            }
        }
    }
}

struct CalendarDayCell_Previews: PreviewProvider {
    static var previews: some View {
        let mockDataStore = HabitDataStore()

        return Group {
            CalendarDayCell(
                date: Date(),
                isSelected: false,
                onSelect: {}
            )
            .environmentObject(mockDataStore)
            .previewDisplayName("Dia Normal")

            CalendarDayCell(
                date: Date(),
                isSelected: true,
                onSelect: {}
            )
            .environmentObject(mockDataStore)
            .previewDisplayName("Dia Selecionado")
        }
        .previewLayout(.sizeThatFits)
        .padding()
    }
}
