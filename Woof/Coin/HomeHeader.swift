//
//  HomeHeader.swift
//  Woof
//
//  Created by Mike Choi on 1/15/22.
//

import SwiftUI

struct HomeHeader: View {
    @Binding var presentWalletSelector: Bool
    @EnvironmentObject var wallet: WalletModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 2) {
            Text(wallet.loadingPortfolio ?  "Loading wallet..." : greetings())
                .font(.system(size: 15, weight: .medium))
                .foregroundColor(Color(uiColor: .secondaryLabel))
    
            HStack {
                Text("junsoo.eth")
                    .font(.system(size: 28, weight: .semibold))
                
                Spacer()
                
                Button {
                    presentWalletSelector.toggle()
                } label: {
                    CircleImageView(backgroundColor: Color(uiColor: .secondarySystemBackground),
                                    icon: Image(systemName: "person.fill"))
                }
                .frame(width: 38, height: 38)
            }
        }
    }
    
    func greetings() -> String {
        let components = Calendar.current.dateComponents([.hour], from: Date())
        switch components.hour ?? 0 {
            case 0...11:
                return "Good morning"
            case 11...14:
                return "Good afternoon"
            case 14...24:
                return "Good evening"
            default:
                return "Good morning"
        }
    }
}
