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
            Text(wallet.loadingPortfolio ?  "Loading wallet..." : "Good morning")
                .font(.system(size: 15, weight: .medium))
                .foregroundColor(Color(uiColor: .secondaryLabel))
    
            HStack {
                Text("junsoo.eth")
                    .font(.system(size: 28, weight: .semibold))
                
                Spacer()
                
                Button {
                    presentWalletSelector = true
                } label: {
                    CircleImageView(backgroundColor: Color(uiColor: .secondarySystemBackground),
                                    icon: Image(systemName: "person.fill"))
                }
                .frame(width: 38, height: 38)
            }
        }
    }
}
