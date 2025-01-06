import SwiftUI

@main
struct MetaFlowApp: App {
    @StateObject private var dataStore = HabitDataStore()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(dataStore)
        }
    }
}

struct ContentView: View {
    var body: some View {
        CustomTabBarContainer(tabs: [
            TabItem(tag: "calendar", icon: "calendar", content: AnyView(CalendarView())),
            TabItem(tag: "habits", icon: "checklist.checked", content: AnyView(HabitsTodayView())),
            TabItem(tag: "profile", icon: "person", content: AnyView(ProfileTabView()))
        ]){
            CalendarView()
        }
    }
    
}

struct ProfileTabView: View {
    var body: some View {
        VStack {
            Text("Profile View")
                .font(.largeTitle)
        }
    }
}

//Preview
struct MetaFlowApp_Previews: PreviewProvider {
    static var previews: some View {
        let exampleDataStore = HabitDataStore()
        exampleDataStore.habits = [
            Habit(nome: "Exercício", cor: Color.color1.description, dataInicio: Date(), repeticoes: .diario),
            Habit(nome: "Meditação", cor: Color.color2.description, dataInicio: Date().addingTimeInterval(-86400), repeticoes: .diario),
            Habit(nome: "Leitura", cor: Color.color3.description, dataInicio: Date().addingTimeInterval(-172800), repeticoes: .diario)
        ]

        return ContentView()
            .environmentObject(exampleDataStore)
    }
}
