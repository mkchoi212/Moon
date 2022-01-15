//
//  WalletHomeView.swift
//  Woof
//
//  Created by Mike Choi on 1/8/22.
//

import SwiftUI
import AlertToast

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
                    CircleImageView(backgroundColor: .themeText,
                                    icon: Image(systemName: "moon"))
                }
                .frame(width: 38, height: 38)
            }
        }
    }
}

struct CoinCell: View {
    var token: Token
    @EnvironmentObject var wallet: WalletModel
    @EnvironmentObject var coinViewModel: CoinViewModel
    
    var body: some View {
        HStack(spacing: 12) {
            CircleImageView(backgroundColor: .lightBlue,
                            url: URL(string: token.iconUrl ?? ""),
                            icon: Image(systemName: "questionmark"))
                .frame(width: 30, height: 30)
            
            Text(token.name)
                .font(.system(size: 18, weight: .semibold))
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: 4) {
                Text(coinViewModel.formatCurrency(token: token))
                Text(coinViewModel.humanTokenQuantityString(quantity: token.tokenQuantity(), symbol: token.symbol))
                    .foregroundColor(Color(uiColor: .secondaryLabel))
            }
        }
    }
}

struct CoinView: View {
    @State var scrollOffset: CGFloat = 0
    @State var showPasteboardCopiedToast = false
    @Binding var presentWalletSelector: Bool
    
    @StateObject var coinViewModel = CoinViewModel()
    @EnvironmentObject var wallet: WalletModel
    
    let columnItem = [GridItem(.flexible())]
    let token = Token(id: "abc", name: "Ethereum", type: "crypto", symbol: "ETH", quantity: "1.4232", price: Price(value: 2301.42, relativeChange24h: 0.1212), iconUrl: "https://token-icons.s3.amazonaws.com/eth.png")
    
    var body: some View {
        NavigationView {
            ZStack(alignment: .top) {
                TrackableScrollView(axes: .vertical, showsIndicators: true) { offset in
                    withAnimation(.easeIn(duration: 0.15)) {
                        scrollOffset = offset.y
                    }
                } content: {
                    VStack(spacing: 0) {
                        HomeHeader(presentWalletSelector: $presentWalletSelector)
                            .environmentObject(wallet)
                            .padding(.horizontal)
                       
                        CardView(showPasteboardCopiedToast: $showPasteboardCopiedToast)
                            .environmentObject(wallet)
                            .environmentObject(coinViewModel)
                        
                        LazyVGrid(columns: columnItem, alignment: .leading) {
                            Text("Assets")
                                .padding()
                                .modifier(GridHeaderTextStyle())
                            
                            ForEach(wallet.loadingTokens ? [token] : wallet.tokens, id: \.self.id) { token in
                                NavigationLink {
                                    CoinDetailView(token: token)
                                        .environmentObject(coinViewModel)
                                } label: {
                                    CoinCell(token: token)
                                        .environmentObject(wallet)
                                        .environmentObject(coinViewModel)
                                        .padding(.horizontal)
                                        .redacted(reason: wallet.loadingTokens ? .placeholder : [])
                                }
                                .buttonStyle(.plain)
                            }
                        }
                    }
                }
                .offset(y: 44)
                
                Text(coinViewModel.formatCurrency(double: wallet.portfolio?.totalValue))
                    .opacity(scrollOffset > -40 ? 0 : 1)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .frame(height: 44)
                    .background(Color(uiColor: .systemBackground))
            }
            .navigationBarHidden(true)
            .toast(isPresenting: $showPasteboardCopiedToast) {
                AlertToast(displayMode: .hud, type: .regular, title: "Copied to Pasteboard")
            }
        }
    }
}

struct WalletHomeView_Previews: PreviewProvider {
    static let env = WalletModel()
    
    static var previews: some View {
        CoinView(presentWalletSelector: .constant(true))
            .environmentObject(env)
    }
}
