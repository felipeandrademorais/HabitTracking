import SwiftUI

struct CustomTabBar: View {
    @Binding var selectedTab: String
    let tabs: [TabItem]

    var body: some View {
        ZStack(alignment: .bottom) {
            HStack {
                ForEach(tabs) { tab in
                    Button(action: {
                        selectedTab = tab.tag
                    }) {
                        VStack {
                            Image(systemName: tab.icon)
                                .resizable()
                                .scaledToFit()
                                .frame(height: 22)
                                .foregroundColor(selectedTab == tab.tag ? Color.defaultDark : .fontSoft)
                        }
                        .frame(maxWidth: .infinity)
                    }
                }
            }
            .frame(height: 100)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(.calendarBackground)
                    .shadow(color: Color.black.opacity(0.2), radius: 6, x: 0, y: -8)
            )
        }
        .zIndex(100)
        
    }
}

struct CustomTabBar_Previews: PreviewProvider {
    @State static private var selectedTab: String = "calendar"

    static var previews: some View {
        CustomTabBar(
            selectedTab: $selectedTab,
            tabs: [
                TabItem(tag: "calendar", icon: "calendar", content: AnyView(Text("Calendar"))),
                TabItem(tag: "habits", icon: "checklist.checked", content: AnyView(Text("Habits"))),
                TabItem(tag: "profile", icon: "person", content: AnyView(Text("Profile")))
            ]
        )
    }
}
