//
//  WalletHomeView.swift
//  Woof
//
//  Created by Mike Choi on 1/8/22.
//

import SwiftUI

struct CoinContentView: View {
    @EnvironmentObject var wallet: WalletModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            Spacer()
            
            Text(wallet.formatCurrency(value: wallet.portfolio?.totalValue))
                .font(.system(size: 30, weight: .bold, design: .rounded))
                .shiny(.iridescent)

            Spacer()
            
            Text("0x9f8523C4DF59724Db6F1990aA064735cfDcd2EA1")
                .lineLimit(1)
                .foregroundColor(.white.opacity(0.7))
                .font(.system(size: 12, weight: .semibold, design: .monospaced))
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(20)
        .background(RoundedRectangle(cornerRadius: 20)
                        .foregroundStyle(LinearGradient(colors: [Color(hex: "#191919"), Color(hex: "#050505")],
                                                        startPoint: .top,
                                                        endPoint: .bottom))
                        .overlay(RoundedRectangle(cornerRadius: 20)
                                    .stroke(Color(hex: "#2a2a2a"), lineWidth: 2)))
        .frame(height: 220)
        .shadow(color: Color.black.opacity(0.2), radius: 10, x: 10, y: 10)
        .padding()
    }
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
                    CircleImageView(backgroundColor: .themeText,
                                    icon: Image(systemName: "moon"))
                }
                .frame(width: 38, height: 38)
            }
        }
    }
}

struct CoinView: View {
    @State var scrollOffset: CGFloat = 0
    @Binding var presentWalletSelector: Bool
    
    @EnvironmentObject var wallet: WalletModel
    let columnItem = [GridItem(.flexible())]
    
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
                        
                        CoinContentView()
                            .environmentObject(wallet)
                        
                        LazyVGrid(columns: columnItem, alignment: .leading) {
                            Text("Assets")
                                .padding()
                                .font(.system(size: 25, weight: .medium))
                            
                            ForEach(wallet.tokens, id: \.self.id) { token in
                                HStack(spacing: 12) {
                                    CircleImageView(backgroundColor: .lightBlue,
                                                    url: URL(string: token.iconUrl ?? ""),
                                                    icon: Image(systemName: "questionmark"))
                                        .frame(width: 30, height: 30)
                                    
                                    Text(token.name)
                                        .font(.system(size: 18, weight: .semibold))
                                    
                                    Spacer()
                                    
                                    VStack(alignment: .trailing, spacing: 4) {
                                        Text("\(wallet.formatCurrency(value: token.value()))")
                                        Text("\(token.tokenQuantity())".prefix(8) + " \(token.symbol)")
                                            .foregroundColor(Color(uiColor: .secondaryLabel))
                                    }
                                }
                                .padding(.horizontal)
                            }
                        }
                    }
                }
                .offset(y: 44)
                
                Text(wallet.formatCurrency(value: wallet.portfolio?.totalValue))
                    .opacity(scrollOffset > -40 ? 0 : 1)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .frame(height: 44)
                    .background(Color(uiColor: .systemBackground))
            }
            .navigationBarHidden(true)
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
