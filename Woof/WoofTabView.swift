//
//  WoofTabView.swift
//  Woof
//
//  Created by Mike Choi on 12/5/21.
//

import SwiftUI

struct WoofTabView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \AutomationContract.date, ascending: true)],
                  animation: .default)
    var automations: FetchedResults<AutomationContract>
    
    var body: some View {
        TabView {
            HomeView(automations: automations.map(\.automation))
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
