//
//  CustomTabBar.swift
//  Habit Tracking
//
//  Created by Felipe Morais on 06/01/25.
//
import SwiftUI

struct CustomTabBar: View {
    @Binding var selectedTab: String
    let tabs: [TabItem]

    var body: some View {
        ZStack(alignment: .bottom) {
            HStack {
                ForEach(tabs) { tab in
                    Button(action: {
                        withAnimation {
                            selectedTab = tab.tag
                        }
                    }) {
                        VStack {
                            Image(systemName: tab.icon)
                                .resizable()
                                .scaledToFit()
                                .frame(height: 22)
                                .foregroundColor(selectedTab == tab.tag ? Color.defaultDark : .gray)
                        }
                        .padding(10)
                        .frame(maxWidth: .infinity)
                    }
                }
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color.white)
                    .shadow(color: Color.black.opacity(0.3), radius: 6, x: 0, y: -10)
            )
        }
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
