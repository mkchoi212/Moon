//
//  WalletHomeView.swift
//  Woof
//
//  Created by Mike Choi on 1/8/22.
//

import SwiftUI
import Shimmer

struct ScrollOffsetPreferenceKey: PreferenceKey {
    static var defaultValue: CGPoint = .zero
    static func reduce(value: inout CGPoint, nextValue: () -> CGPoint) {}
}

struct CoinCell: View {
    var token: Token
    
    @EnvironmentObject var wallet: WalletModel
    @EnvironmentObject var coinViewModel: CoinViewModel
    
    var body: some View {
        HStack(spacing: 12) {
            CoinImageView(iconUrl: token.iconUrl)
                .frame(width: 40, height: 40)
            
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
    @State var offset: CGFloat = 100
    @State var showPasteboardCopiedToast = false
    @Binding var presentWalletSelector: Bool
    
    @StateObject var coinViewModel = CoinViewModel()
    @EnvironmentObject var wallet: WalletModel
    
    let columnItem = [GridItem(.flexible())]
    
    var body: some View {
        NavigationView {
            List {
                GeometryReader { proxy in
                    HomeHeader(presentWalletSelector: $presentWalletSelector)
                        .environmentObject(wallet)
                        .preference(
                            key: ScrollOffsetPreferenceKey.self,
                            value: proxy.frame(in: .named("scroll")).origin
                        )
                        .onPreferenceChange(ScrollOffsetPreferenceKey.self) { value in
                            self.offset = value.y
                        }
                }
                .modifier(PureCell())
                .padding(.horizontal)
                .padding(.bottom, 50)

                CardView(showPasteboardCopiedToast: $showPasteboardCopiedToast)
                    .environmentObject(wallet)
                    .environmentObject(coinViewModel)
                    .modifier(PureCell())
                
                Text("Assets")
                    .padding()
                    .modifier(GridHeaderTextStyle())
                    .modifier(PureCell())
                
                ForEach(wallet.loadingTokens ? coinViewModel.dummyTokenPlaceHolders : wallet.tokens, id: \.self.id) { token in
                    if wallet.loadingTokens {
                        CoinCell(token: token)
                            .listRowSeparator(.hidden)
                            .listRowInsets(EdgeInsets(top: 10, leading: 0, bottom: 10, trailing: 0))
                            .environmentObject(wallet)
                            .environmentObject(coinViewModel)
                            .padding(.horizontal)
                            .redacted(reason: .placeholder)
                            .shimmering()
                    } else {
                        NavigationLink {
                            CoinDetailView(token: token)
                                .environmentObject(coinViewModel)
                        } label: {
                            CoinCell(token: token)
                                .environmentObject(wallet)
                                .environmentObject(coinViewModel)
                                .padding(.vertical, 8)
                        }
                        .modifier(PureCell(zeroInsets: true))
                    }
                }
            }
            .listStyle(.plain)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar(content: {
                ToolbarItem(placement: .principal) {
                    Text(coinViewModel.formatCurrency(double: wallet.portfolio?.totalValue))
                        .opacity(offset < 40  ? 1 : 0)
                        .animation(.easeInOut(duration: 0.18), value: offset)
                        .font(.system(size: 17, weight: .semibold, design: .rounded))
                        .frame(width: 300, alignment: .center)
                }
            })
            .refreshable {
                wallet.reload(reset: false, refresh: true)
            }
        }
        .toast(isPresenting: $showPasteboardCopiedToast) {
            AlertToast(displayMode: .hud, type: .regular, title: "Copied to Pasteboard")
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
