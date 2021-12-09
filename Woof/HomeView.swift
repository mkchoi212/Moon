//
//  HomeView.swift
//  Woof
//
//  Created by Mike Choi on 12/5/21.
//

import SwiftUI

struct HomeView: View {
    let automations: [Automation]
    @State var presentedAutomation: Automation? = nil
    
    let column = [GridItem(.flexible())]
    
    var body: some View {
        NavigationView {
            ScrollView {
                LazyVGrid(columns: column, spacing: 15) {
                    ForEach(automations) { automation in
                        Button {
                            presentedAutomation = automation
                        } label: {
                            AutomationSummaryCell(automation: automation)
                        }
                        .buttonStyle(.plain)
                        .padding(.vertical)
                    }
                }
                .padding(.horizontal, 15)
                .padding(.top, 15)
            }
            .navigationTitle("Home")
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button {
                        presentedAutomation = .empty
                    } label: {
                        HStack(spacing: 4) {
                            Image(systemName: "plus")
                                .tint(.blue)
                                .font(.system(size: 13, weight: .bold, design: .rounded))
                            
                            Text("New")
                                .foregroundColor(.blue)
                                .font(.system(size: 15, weight: .semibold))
                        }
                        .padding(6)
                        .background(Color(hex: "e3e6f5"))
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                    }
                }
            }
        }
        .fullScreenCover(item: $presentedAutomation, onDismiss: {
            presentedAutomation = nil
        }) { automation in
            RuleCreatorView(automation: automation)
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView(automations: Automation.dummy)
    }
}
