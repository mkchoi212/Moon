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

struct AutomationSummaryCell: View {
    let automation: Automation
    
    var body: some View {
        ZStack(alignment: .leading) {
            RoundedRectangle(cornerRadius: 12)
                .foregroundColor(.white)
                .shadow(color: .black.opacity(0.08), radius: 20, x: 5, y: 5)
            
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    ZStack {
                        RoundedRectangle(cornerRadius: 8)
                            .foregroundColor(automation.color)
                            .frame(width: 30, height: 30, alignment: .center)
                        
                        Image(systemName: automation.icon)
                            .foregroundColor(.white)
                    }
                    
                    Spacer()
                    
                    Button {
                        
                    } label: {
                        Image(systemName: "ellipsis.circle.fill")
                            .resizable()
                            .foregroundColor(.accentColor)
                    }
                    .frame(width: 24, height: 24)
                }
                
                Spacer()

                Text(automation.title)
                    .font(.system(size: 18, weight: .semibold))
                    .lineLimit(2)
                
                Text("\(automation.actions.count) actions")
                    .font(.system(size: 15, weight: .regular, design: .rounded))
                    .foregroundColor(Color(uiColor: .secondaryLabel))
            }
            .padding()
        }
        .frame(height: 140)
    }
}

struct HomeView: View {
    
    let automations: [Automation]
    let gridItemLayout = [GridItem(.flexible()), GridItem(.flexible())]
    @State var presentCreator = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                LazyVGrid(columns: gridItemLayout, spacing: 15) {
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
