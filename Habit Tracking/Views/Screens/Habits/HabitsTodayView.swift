import SwiftUI

struct HabitsTodayView: View {
    @EnvironmentObject var dataStore: HabitDataStore
    @State private var selectedDate: Date = Date()
    @State private var isShowingAddHabit: Bool = false

    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            VStack {
                WeekView(onDaySelected: { date in
                    selectedDate = date
                })
                .frame(maxHeight: 85)
                
                if (todaysHabits.isEmpty) {
                    Spacer()
                    Image("Woman")
                        .resizable()
                        .scaledToFit()
                        .padding(40)
                    
                    Spacer()
                } else {
                    List {
                        ForEach(todaysHabits) { habit in
                            HabitRowView(
                                habit: habit,
                                selectedDate: selectedDate
                            )
                                .padding(.vertical, 8)
                                .listRowInsets(EdgeInsets())
                                .listRowBackground(
                                    Color.white.opacity(0.001)
                                )
                                .listRowSeparator(.hidden)
                        }
                        .onDelete(perform: deleteHabits)
                    }
                    .listStyle(.plain)
                    .listRowSeparator(.hidden)
                    .padding()
                }
            }
            
            Button(action: {
                isShowingAddHabit = true
            }) {
                Image(systemName: "plus")
                    .font(.title)
                    .foregroundColor(.white)
                    .padding()
                    .background(.defaultDark)
                    .clipShape(Circle())
                    .shadow(radius: 5)
            }
            .padding(.trailing, 20)
            .padding(.bottom, 60)
            
        }.sheet(isPresented: $isShowingAddHabit) {
            AddHabitView()
                .environmentObject(dataStore)
        }
    }

    private var todaysHabits: [Habit] {
        dataStore.habits(for: selectedDate)
    }

    private func deleteHabits(at offsets: IndexSet) {
        offsets.forEach { index in
            let habit = todaysHabits[index]
            dataStore.removeHabit(habit)
        }
    }
}

struct HabitsTodayView_Previews: PreviewProvider {
    static var previews: some View {
        return HabitsTodayView()
            .environmentObject(HabitDataStore.sampleDataStore)
    }
}
