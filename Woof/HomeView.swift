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
    let icon: Image
    let condition: [Condition]
    let actions: [Action]
    
    static let dummy: [Automation] =
    [
        Automation(title: "Buy the dip", color: .red, icon: Image(systemName: "arrow.down"),
                   condition: [
                    TransactionFee(wallet: .mike, crypto: .eth, comparator: .less, price: 100),
                    PriceChange(crypto: .eth, comparator: .less, price: 5000)
                   ],
                   actions: [
                    SendNotification(message: ""),
                    Buy(crypto: .eth, amount: 100, wallet: .mike)
                   ]),
        Automation(title: "Stake Olympus", color: .purple, icon: Image(systemName: "lock.fill"),
                   condition: [
                    TransactionFee(wallet: .mike, crypto: .eth, comparator: .less, price: 100),
                    PriceChange(crypto: .eth, comparator: .less, price: 5000)
                   ],
                   actions: [
                    SendNotification(message: ""),
                    Swap(wallet: .mike, fromCrypto: .eth, toCrypto: .ohm, amount: 4)
                   ])
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
