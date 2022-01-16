//
//  WalletHomeView.swift
//  Woof
//
//  Created by Mike Choi on 1/8/22.
//

import SwiftUI
import Shimmer
import AlertToast

struct ScrollOffsetPreferenceKey: PreferenceKey {
    static var defaultValue: CGPoint = .zero
    static func reduce(value: inout CGPoint, nextValue: () -> CGPoint) {}
}

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

struct CoinCell: View {
    var token: Token
    
    @EnvironmentObject var wallet: WalletModel
    @EnvironmentObject var coinViewModel: CoinViewModel
    
    var body: some View {
        HStack(spacing: 12) {
            CircleImageView(backgroundColor: Color(uiColor: .secondarySystemBackground),
                            url: token.iconUrl == nil ? nil : URL(string: token.iconUrl!),
                            icon: Image("generic.coin"),
                            iconPadding: 6)
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

struct PureCell: ViewModifier {
    func body(content: Content) -> some View {
        content
            .listRowSeparator(.hidden)
            .listRowBackground(Color.clear)
            .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
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
                            value: proxy.frame(in: .named("scrollView")).origin
                        )
                }
                .modifier(PureCell())
                .padding(.horizontal)
                .padding(.bottom, 40)
                .onPreferenceChange(ScrollOffsetPreferenceKey.self) { value in
                    withAnimation(.easeInOut(duration: 0.18)) {
                        self.offset = value.y
                    }
                }
                
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
                            .environmentObject(wallet)
                            .environmentObject(coinViewModel)
                            .padding(.horizontal)
                            .redacted(reason: .placeholder)
                            .shimmering()
                            .modifier(PureCell())
                    } else {
                        NavigationLink {
                            CoinDetailView(token: token)
                                .environmentObject(coinViewModel)
                        } label: {
                            CoinCell(token: token)
                                .environmentObject(wallet)
                                .environmentObject(coinViewModel)
                                .padding(.horizontal)
                        }
                        .buttonStyle(.plain)
                        .modifier(PureCell())
                    }
                }
            }
            .listStyle(.plain)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar(content: {
                ToolbarItem(placement: .principal) {
                    Text(coinViewModel.formatCurrency(double: wallet.portfolio?.totalValue))
                        .opacity(offset < 40  ? 1 : 0)
                        .font(.system(size: 15, weight: .semibold, design: .rounded))
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
