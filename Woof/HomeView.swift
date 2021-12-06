//
//  HomeView.swift
//  Woof
//
//  Created by Mike Choi on 12/5/21.
//

import SwiftUI

struct Automation: Identifiable {
    let id = UUID()
    let title: String
    let color: Color
    let icon: String
    let condition: String
    let actions: [String]
    
    static let dummy: [Automation] = [
        Automation(title: "Stake Olympus", color: .purple, icon: "wind", condition: "if gas price is lower than $100", actions: ["Buy 0.98741 ETH", "Text"]),
        Automation(title: "Buy the dip", color: .red, icon: "arrow.down", condition: "if ETH price is lower than $4,000", actions: ["Buy 2 ETH", "Email"]),
    ]
}

struct HomeView: View {
    
    let automations: [Automation]
    @State var presentCreator = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 30) {
                    ForEach(automations) { automation in
                        NavigationLink {
                            Text("asdf")
                        } label: {
                            AutomationSummaryCell(automation: automation)
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(.horizontal, 15)
                .padding(.top, 15)
            }
            .navigationTitle("Home")
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button {
                        presentCreator = true
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
        }
        .fullScreenCover(isPresented: $presentCreator) {
        } content: {
            RuleCreatorView()
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView(automations: Automation.dummy)
    }
}
