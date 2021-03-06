//
//  CoinDetailView.swift
//  Woof
//
//  Created by Mike Choi on 1/11/22.
//

import SwiftUI

class CoinViewModel: ObservableObject {
    lazy var dummyTokenPlaceHolders: [Token] = {
        (0...6).map { _ in
            Token(id: UUID().uuidString,
                  name: "Ethereum",
                  type: "crypto",
                  symbol: "ETH",
                  quantity: "1.4232",
                  price: Price(value: 2301.42, relativeChange24h: 0.1212),
                  iconUrl: nil)
        }
    }()
    
    func humanizedMineDate(minedAt: Int) -> String {
        Date(timeIntervalSince1970: TimeInterval(minedAt))
            .formatted(date: .abbreviated, time: .omitted)
    }
    
    func truncatedAddress(addr: String) -> String {
        addr.prefix(6) + "..." + addr.suffix(4)
    }
    
    func formatCurrency(double: Double?) -> String {
        guard let double = double else {
            // TODO: not alwasy dollar
            return "$0"
        }
        return NumberFormatter.currency.string(from: NSNumber(value: double)) ?? "$0"
    }
    
    func formatCurrency(token: Token) -> String {
        formatCurrency(double: token.value())
    }
    
    func humanTokenQuantityString(quantity: Double, symbol: String) -> String {
        let digits = NumberFormatter.eightSignificantPlaces.string(for: quantity) ?? "0.0"
        return digits + " \(symbol)"
    }
}

final class CoinDetailViewModel: ObservableObject {
    var token: Token
    var transactions: [Transaction]
    
    init(token: Token, transactions: [Transaction]) {
        self.token = token
        self.transactions = transactions
    }
}

struct TransactionCell: View {
    var token: Token
    var transaction: Transaction
    
    @EnvironmentObject var vieWModel: CoinViewModel
    
    var body: some View {
        HStack(spacing: 12) {
            CoinImageView(iconUrl: token.iconUrl)
                .frame(width: 40, height: 40)
            
            Spacer()
            
            VStack(alignment: .leading, spacing: 2) {
                HStack(spacing: 8) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(transaction.title())
                            .lineLimit(1)
                        
                        Text(Date(timeIntervalSince1970: TimeInterval(transaction.minedAt)).formatted(date: .abbreviated, time: .omitted))
                            .lineLimit(1)
                            .foregroundColor(.secondary)
                    }
                    
                    Spacer()
                    
                    VStack(alignment: .trailing, spacing: 4) {
                        Text("\(vieWModel.formatCurrency(double: transaction.transactionValue()))")
                            .lineLimit(1)
                        
                        Text(vieWModel.humanTokenQuantityString(quantity: transaction.transactionQuantity(), symbol: token.symbol))
                            .foregroundColor(Color(uiColor: .secondaryLabel))
                    }
                }
            }
        }
    }
}

struct CoinDetailView: View {
    @ObservedObject var token: Token
    @EnvironmentObject var wallet: WalletModel
    @EnvironmentObject var coinVieWModel: CoinViewModel
    
    let column = [GridItem(.flexible())]
    
    var body: some View {
        ScrollView {
            VStack(alignment: .center, spacing: 8) {
                Text(coinVieWModel.formatCurrency(token: token))
                    .font(.system(size: 38, weight: .semibold, design: .rounded))
                Text(coinVieWModel.humanTokenQuantityString(quantity: token.tokenQuantity(), symbol: token.symbol))
                    .foregroundColor(Color(uiColor: .secondaryLabel))
                    .font(.system(size: 22, weight: .regular, design: .rounded))
            }
            .padding(.vertical)
            
            LazyVGrid(columns: column, alignment: .leading) {
                Text("Transactions")
                    .padding()
                    .modifier(GridHeaderTextStyle())
                
                ForEach(wallet.transactions(for: token)) { transaction in
                    NavigationLink {
                        TransactionDetailView(transaction: transaction)
                            .environmentObject(coinVieWModel)
                    } label: {
                        TransactionCell(token: token, transaction: transaction)
                            .padding()
                    }
                }
            }
        }
    }
}

struct CoinDetailView_Previews: PreviewProvider {
    static let viewModel = CoinViewModel()
    static let wallet = WalletModel()
    static let token = Token(id: "abc", name: "Ethereum", type: "crypto", symbol: "ETH", quantity: "1.4232", price: Price(value: 2301.42, relativeChange24h: 0.1212), iconUrl: "https://token-icons.s3.amazonaws.com/eth.png")
    
    static var previews: some View {
        CoinDetailView(token: CoinDetailView_Previews.token)
            .environmentObject(viewModel)
            .environmentObject(wallet)
    }
}

