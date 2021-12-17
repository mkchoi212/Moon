//
//  CoinSelector.swift
//  Woof
//
//  Created by Mike Choi on 12/16/21.
//

import SwiftUI

struct CoinTable: View {
    @EnvironmentObject var viewModel: CoinViewModel
    @Binding var selectedCryptoSymbol: String?
    
    var body: some View {
        List {
            ForEach(viewModel.coins, id: \.id) { coin in
                HStack(spacing: 12) {
                    let url = URL(string: coin.image)
                    
                    AsyncImage(url: url) { image in
                        image
                            .resizable()
                            .clipShape(Circle())
                    } placeholder: {
                        Circle()
                            .foregroundColor(.gray)
                    }
                    .frame(width: 30, height: 30)
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text(coin.name)
                            .font(.system(size: 14, weight: .semibold, design: .rounded))
                        
                        Text(coin.symbol.uppercased())
                            .font(.system(size: 14, design: .rounded))
                            .foregroundColor(.secondary)
                    }
                    
                    Spacer()
                    
                    VStack(alignment: .trailing, spacing: 4) {
                        Text(coin.currentPrice.currencyFormatted)
                            .font(.system(size: 14, design: .rounded))
                        Text(coin.priceChangePercentage24H?.signedPercentage ?? "0")
                            .font(.system(size: 14, design: .rounded))
                            .foregroundColor(coin.priceChangePercentage24H?.percentageColor ?? .secondary)
                    }
                }
                .padding(.vertical, 6)
            }
        }
        .listStyle(.inset)
    }
}

struct ActivityIndicator: UIViewRepresentable {
    @Binding var isAnimating: Bool
    let style: UIActivityIndicatorView.Style
    
    func makeUIView(context: UIViewRepresentableContext<ActivityIndicator>) -> UIActivityIndicatorView {
        return UIActivityIndicatorView(style: style)
    }
    
    func updateUIView(_ uiView: UIActivityIndicatorView, context: UIViewRepresentableContext<ActivityIndicator>) {
        isAnimating ? uiView.startAnimating() : uiView.stopAnimating()
    }
}

struct CoinSelector: View {
    @EnvironmentObject var viewModel: CoinViewModel
    @State var selectedCryptoSymbol: String?
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            if viewModel.coins.isEmpty {
                Spacer()
                
                ActivityIndicator(isAnimating: .constant(true), style: .large)
                    .frame(maxWidth: .infinity)
                
                Spacer()
            } else {
                HStack {
                    VStack(alignment: .leading, spacing: 6) {
                        Text("Select a coin")
                            .modifier(EditorHeaderModifier())
                        
                        Text("Prices are updated every 30 minutes")
                            .font(.system(size: 14))
                            .foregroundColor(.secondary)
                    }
                   
                    Spacer()
                    BigXButton()
                }
                .padding(.horizontal)
                
                CoinTable(selectedCryptoSymbol: $selectedCryptoSymbol)
            }
        }
        .padding(.top)
        .background(Color(uiColor: .systemGroupedBackground))
    }
}

struct CoinSelector_Previews: PreviewProvider {
    static var previews: some View {
        let vm = CoinViewModel()
        CoinSelector(selectedCryptoSymbol: "BTC")
            .environmentObject(vm)
    }
}
