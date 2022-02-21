//
//  WalletHomeView.swift
//  Woof
//
//  Created by Mike Choi on 1/8/22.
//

import SwiftUI
import Shimmer
import PartialSheet

struct ScrollOffsetPreferenceKey: PreferenceKey {
    static var defaultValue: CGPoint = .zero
    static func reduce(value: inout CGPoint, nextValue: () -> CGPoint) {}
}

struct CoinCell: View {
    var token: Token
    var loading = false
    
    @EnvironmentObject var wallet: WalletModel
    @EnvironmentObject var coinViewModel: CoinViewModel
    
    var body: some View {
        HStack(spacing: 12) {
            CoinImageView(iconUrl: token.iconUrl, loading: loading)
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
    // unique initial value to prevent initial flashing of the title
    @State var offset: CGFloat = 10000
    @State var showPasteboardCopiedToast = false
    @State var presentWalletSelector = false
    @State var presentWalletConnector = false
    
    @StateObject var coinViewModel = CoinViewModel()
    @EnvironmentObject var walletViewModel: WalletConnectionViewModel
    @EnvironmentObject var wallet: WalletModel
    @EnvironmentObject var sheetManager: PartialSheetManager
    
    let columnItem = [GridItem(.flexible())]
    
    var body: some View {
        NavigationView {
            List {
                VStack {
                    HomeHeader(presentWalletSelector: $presentWalletSelector)
                        .environmentObject(wallet)
                    
                    CardView(showPasteboardCopiedToast: $showPasteboardCopiedToast)
                        .environmentObject(wallet)
                        .environmentObject(coinViewModel)
                        .zIndex(1)
                }
                .modifier(PureCell())
                .padding(.horizontal)
                .padding(.bottom, 20)
                
                GeometryReader { proxy in
                    Text("Assets")
                        .modifier(GridHeaderTextStyle())
                        .modifier(PureCell())
                        .preference(
                            key: ScrollOffsetPreferenceKey.self,
                            value: proxy.frame(in: .named("scroll")).origin
                        )
                        .onPreferenceChange(ScrollOffsetPreferenceKey.self) { value in
                            if self.offset == 10000 {
                                self.offset = 1000
                            } else {
                                self.offset = value.y
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                
                assetList()
            }
            .listStyle(.plain)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar(content: {
                ToolbarItem(placement: .principal) {
                    Text(coinViewModel.formatCurrency(double: wallet.portfolio?.totalValue))
                        .opacity(offset < 340 ? 1 : 0)
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
        .sheet(isPresented: $presentWalletConnector, content: {
            WalletConnectionView()
                .environmentObject(walletViewModel)
        })
        .onChange(of: presentWalletSelector) { presentSheet in
            if presentSheet {
                sheetManager.showPartialSheet {
                    StackedWalletSelectorView(presentSheet: $presentWalletSelector) {
                        presentWalletConnector = true
                    }
                    .environmentObject(walletViewModel)
                }
            } else {
                sheetManager.closePartialSheet()
            }
        }
    }
    
    @ViewBuilder func assetList() -> some View {
        ForEach(wallet.loadingTokens ? coinViewModel.dummyTokenPlaceHolders : wallet.tokens, id: \.self.id) { token in
            if wallet.loadingTokens {
                CoinCell(token: token, loading: true)
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
}

struct WalletHomeView_Previews: PreviewProvider {
    static let env = WalletModel()
    
    static var previews: some View {
        CoinView()
            .environmentObject(env)
    }
}
