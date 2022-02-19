//
//  CardView.swift
//  Woof
//
//  Created by Mike Choi on 1/13/22.
//

import SwiftUI
import Shimmer

extension Image {
    func cardCornerButtonModifier() -> some View {
        self
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 20, height: 20, alignment: .trailing)
   }
}

struct CardBalanceView: View {
    var flipCard: () -> ()
    @Binding var showPasteboardCopiedToast: Bool
    
    @EnvironmentObject var wallet: WalletModel
    @EnvironmentObject var coinViewModel: CoinViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            HStack {
                Spacer()
                
                Button {
                    flipCard()
                } label: {
                    Image(systemName: "qrcode")
                        .cardCornerButtonModifier()
                        .foregroundColor(.white)
                }
            }
            
            Spacer()
            
            if wallet.loadingPortfolio {
                RoundedRectangle(cornerRadius: 4)
                        .frame(width: 150, height: 24, alignment: .leading)
                        .foregroundColor(.gray)
                        .shimmering()
            } else {
                Text(coinViewModel.formatCurrency(double: wallet.portfolio?.totalValue))
                    .font(.system(size: 30, weight: .bold, design: .rounded))
                    .shiny(.iridescent)
            }
            
            Spacer()
            
            Button {
                wallet.copyAddressToPasteboard()
                showPasteboardCopiedToast = true
            } label: {
                Text("0x9f8523C4DF59724Db6F1990aA064735cfDcd2EA1")
                    .lineLimit(1)
                    .foregroundColor(.white.opacity(0.7))
                    .font(.system(size: 12, weight: .semibold, design: .monospaced))
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
    }
}

struct CardQRView: View {
    var flipCard: () -> ()
    
    @Binding var showPasteboardCopiedToast: Bool
    @EnvironmentObject var wallet: WalletModel
    @EnvironmentObject var coinViewModel: CoinViewModel
    
    var body: some View {
        GeometryReader { proxy in
            ZStack {
                VStack(alignment: .leading, spacing: 15) {
                    HStack {
                        Spacer()
                        
                        Button {
                            flipCard()
                        } label: {
                            Image(systemName: "arrow.uturn.left")
                                .cardCornerButtonModifier()
                                .foregroundColor(.gray)
                        }
                    }
                    
                    Spacer()
                }
                
                HStack(alignment: .center, spacing: 25) {
                    Image(uiImage: UIImage(data: wallet.walletQRCodeData!)!)
                        .resizable()
                        .scaledToFit()
                        .frame(width: proxy.size.height * 0.7, height: proxy.size.height * 0.7)
                   
                    VStack(alignment: .leading, spacing: 30) {
                        Button {
                            wallet.copyAddressToPasteboard()
                            showPasteboardCopiedToast = true
                        } label: {
                            Label("Copy Address", systemImage: "square.on.square")
                                .font(.system(size: 14, weight: .semibold, design: .rounded))
                                .foregroundColor(Color(uiColor: .label))
                        }
                        
                        Button {
                            presentShareSheet(with: wallet.currentWalletAddress)
                        } label: {
                            Label("Share", systemImage: "square.and.arrow.up")
                                .font(.system(size: 14, weight: .semibold, design: .rounded))
                                .foregroundColor(Color(uiColor: .label))
                        }
                    }
                }
                .frame(maxHeight: .infinity, alignment: .center)
            }
        }
    }
    
    func presentShareSheet(with addr: String) {
        let vc = UIActivityViewController(activityItems: [addr], applicationActivities: nil)
        UIApplication.shared.windows.first?.rootViewController?.present(vc, animated: true)
    }
}

struct CardView: View {
    @State var isCardRotated = false
    @State var isContentRotated = false
    @State var isFlipped = false
    
    @Binding var showPasteboardCopiedToast: Bool
     
    @EnvironmentObject var wallet: WalletModel
    @EnvironmentObject var coinViewModel: CoinViewModel
    
    let impactMed = UIImpactFeedbackGenerator(style: .medium)
    
    var backgroundCard: some View {
        if isContentRotated {
            return AnyView(RoundedRectangle(cornerRadius: 20)
                            .foregroundStyle(Color(uiColor: .systemBackground)))
        } else {
            return AnyView(RoundedRectangle(cornerRadius: 20)
                .foregroundStyle(LinearGradient(colors: [Color(hex: "#191919"), Color(hex: "#050505")],
                                  startPoint: .top,
                                  endPoint: .bottom)))
        }
    }
    
    var body: some View {
        ZStack {
            if isFlipped {
                CardQRView(flipCard: flipCard, showPasteboardCopiedToast: $showPasteboardCopiedToast)
                    .environmentObject(wallet)
                    .environmentObject(coinViewModel)
            } else {
                CardBalanceView(flipCard: flipCard, showPasteboardCopiedToast: $showPasteboardCopiedToast)
                    .environmentObject(wallet)
                    .environmentObject(coinViewModel)
            }
        }
        .rotation3DEffect(Angle(degrees: isContentRotated ? 180 : 0), axis: (x: 0.0, y: 1.0, z: 0.0))
        .padding(20)
        .background(backgroundCard
                        .overlay(RoundedRectangle(cornerRadius: 20)
                        .stroke(Color(hex: "#2a2a2a"), lineWidth: 0.4)))
        .frame(height: 220)
        .rotation3DEffect(Angle(degrees: isCardRotated ? 180 : 0), axis: (x: CGFloat(0), y: CGFloat(10), z: CGFloat(0)))
        .shadow(color: Color.black.opacity(0.15), radius: 10, x: 10, y: 10)
        .onChange(of: showPasteboardCopiedToast) { isShowing in
            if isShowing {
                impactMed.impactOccurred()
            }
        }
    }
    
    func flipCard() {
        let duration = 0.49
        
        DispatchQueue.main.asyncAfter(deadline: .now() + duration / 2) {
            isFlipped.toggle()
            isContentRotated.toggle()
        }
        
        withAnimation(.easeInOut(duration: duration)) {
            isCardRotated.toggle()

        }
    }
}

struct CardView_Previews: PreviewProvider {
    static let wallet = WalletModel()
    static let viewModel = CoinViewModel()
    
    static var previews: some View {
        CardView(showPasteboardCopiedToast: .constant(false))
            .environmentObject(wallet)
            .environmentObject(viewModel)
    }
}
