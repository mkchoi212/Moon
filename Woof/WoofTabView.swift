//
//  WoofTabView.swift
//  Woof
//
//  Created by Mike Choi on 12/5/21.
//

import SwiftUI

struct WoofTabView: View {
    var body: some View {
        TabView {
            HomeView(automations: Automation.dummy)
                .tabItem {
                    Label("Home", systemImage: "house")
                }
            
            NotificationView()
                .tabItem {
                    Label("Notifications", systemImage: "bell")
                }
            
            SettingsView()
                .tabItem {
                    Label("Settings", systemImage: "gear")
                }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        WoofTabView()
    }
}
