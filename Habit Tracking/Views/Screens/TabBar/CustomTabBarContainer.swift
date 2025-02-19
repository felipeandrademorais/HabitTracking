//
//  CustomTabBarContainer.swift
//  Habit Tracking
//
//  Created by Felipe Morais on 06/01/25.
//

import SwiftUI

struct CustomTabBarContainer<Content: View>: View {
    @State private var selectedTab: String
    let tabs: [TabItem]
    let content: Content

    init(tabs: [TabItem], @ViewBuilder content: () -> Content) {
        self.tabs = tabs
        self.content = content()
        self._selectedTab = State(initialValue: tabs.first?.tag ?? "")
    }

    var body: some View {
        VStack(spacing: -40) {
            ZStack {
                ForEach(tabs) { tab in
                    if selectedTab == tab.tag {
                        tab.content
                    }
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            
            CustomTabBar(selectedTab: $selectedTab, tabs: tabs)
        }
    }
}

struct CustomTabBarContainer_Previews: PreviewProvider {
    static var previews: some View {
        CustomTabBarContainer(tabs: [
            TabItem(tag: "calendar", icon: "calendar", content: AnyView(Text("Calendario"))),
            TabItem(tag: "habits", icon: "checklist.checked", content: AnyView(Text("Habitos"))),
            TabItem(tag: "profile", icon: "person", content: AnyView(Text("Perfil")))
        ]) {
            CalendarView()
        }
    }
}
