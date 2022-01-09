//
//  WalletConnectButton.swift
//  Woof
//
//  Created by Mike Choi on 12/21/21.
//

import Foundation
import SwiftUI

struct WalletConnectButton: View {
    @EnvironmentObject var viewModel: WalletConnectionViewModel
    let image: Image
    let title: String
    let generateUniversalURL: (String) -> (String?)
    
    @State var isLoading = false
    
    var body: some View {
        Button {
            let uri = viewModel.connect()
            if let universalLink = universalLink(from: uri) {
                if UIApplication.shared.canOpenURL(universalLink) {
                    isLoading = true
                    
                    viewModel.openWalletWithDelay(url: universalLink) {
                        isLoading = false
                    }
                } else {
                    
                }
            } else {
                
            }
        } label: {
            HStack(spacing: 14) {
                if isLoading {
                    ProgressView()
                        .progressViewStyle(.circular)
                        .frame(height: 30)
                        .frame(maxWidth: .infinity)
                } else {
                    image
                        .resizable()
                        .frame(width: 30, height: 30)
                    Text(title)
                        .font(.system(size: 18, weight: .medium))
                        .frame(maxWidth: .infinity)
                }
            }
            .padding()
            .background(RoundedRectangle(cornerRadius: 50).foregroundColor(Color(uiColor: .secondarySystemBackground)))
        }
        .buttonStyle(.plain)
    }
    
    func universalLink(from uri: String?) -> URL? {
        guard let uri = uri,
              let rawUniversalLink = generateUniversalURL(uri)else {
                  return nil
              }
        
        return URL(string: rawUniversalLink)
    }
}
