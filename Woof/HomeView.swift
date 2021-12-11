//
//  HomeView.swift
//  Woof
//
//  Created by Mike Choi on 12/5/21.
//

import SwiftUI

struct EmptyHomeView: View {
    @Binding var presentedAutomation: Automation?
    
    var body: some View {
        VStack(spacing: 18) {
            Image(systemName: "plus.square.dashed")
                .font(.system(size: 44, weight: .regular))
                .foregroundColor(.lightGray)

            Text("No automations")
                .font(.system(size: 18, weight: .semibold, design: .rounded))
                .foregroundColor(.lightGray)
        }
        .onTapGesture {
            presentedAutomation = .empty
        }
    }
}

struct HomeContentView: View {
    
    let column = [GridItem(.flexible())]
    let automations: [Automation]
    @Binding var presentedAutomation: Automation?
    
    var body: some View {
        if automations.isEmpty {
            EmptyHomeView(presentedAutomation: $presentedAutomation)
        } else {
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
        }
    }
}

struct HomeView: View {
    let automations: [Automation]
    @State var presentedAutomation: Automation? = nil
    
    var body: some View {
        NavigationView {
            HomeContentView(automations: automations, presentedAutomation: $presentedAutomation)
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
                            .background(Color.lightBlue)
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
            .preferredColorScheme(.light)
        HomeView(automations: Automation.dummy)
            .preferredColorScheme(.dark)
    }
}
