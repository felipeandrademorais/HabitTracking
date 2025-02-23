import SwiftUI

@main
struct MetaFlowApp: App {
    @StateObject private var dataStore = HabitDataStore()
    @StateObject private var versionChecker = VersionChecker.shared

    var body: some Scene {
        WindowGroup {
            ZStack {
                ContentView()
                    .environmentObject(dataStore)
                    .font(Font.custom("Poppins-Regular", size: 16))
                    .preferredColorScheme(.light)
                
                UpdateAlertView()
            }
        }
    }
}

struct ContentView: View {
    var body: some View {
        CustomTabBarContainer(tabs: [
            TabItem(tag: "calendar", icon: "calendar", content: AnyView(CalendarView())),
            TabItem(tag: "habits", icon: "checklist.checked", content: AnyView(HabitsTodayView())),
            TabItem(tag: "profile", icon: "person", content: AnyView(UserProfileView()))
        ]){
            CalendarView()
        }
    }
    
}

//Preview
struct MetaFlowApp_Previews: PreviewProvider {
    static var previews: some View {

        return ContentView()
            .environmentObject(HabitDataStore.sampleDataStore)
    }
}
