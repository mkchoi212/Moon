//
//  TransactionDetailView.swift
//  Woof
//
//  Created by Mike Choi on 2/2/22.
//

import SwiftUI
import BetterSafariView

extension String {
    func longPressCopyContextMenuModifier() -> some View {
        Text(self)
            .contextMenu(ContextMenu(menuItems: {
                Button("Copy", action: {
                    UIPasteboard.general.string = self
                })
            }))
    }
}

struct LongPressCopy: ViewModifier {
    
    var string: String
    
    func body(content: Content) -> some View {
        content
            .contextMenu(ContextMenu(menuItems: {
                Button("Copy", action: {
                    UIPasteboard.general.string = string
                })
            }))
    }
}

struct TransactionDetailView: View {
    
    var transaction: Transaction
    
    @State var copyFromAddress = false
    @State var presentEtherscan = false
    @EnvironmentObject var viewModel: CoinViewModel
    
    var body: some View {
        List {
            Section {
                VStack(alignment: .center, spacing: 20) {
                    Text(viewModel.humanTokenQuantityString(quantity: transaction.transactionQuantity(), symbol: transaction.change?.asset.symbol ?? ""))
                        .font(.system(size: 42, weight: .semibold, design: .rounded))
                        .lineLimit(1)
                        .minimumScaleFactor(0.5)
                    
                    VStack(spacing: 8) {
                        Text("Payment from")
                            .font(.system(size: 17, weight: .regular))
                            .foregroundColor(.secondary)
                        Button {
                            copyFromAddress = true
                        } label: {
                            Text("0x1209..123")
                                .font(.system(size: 17, weight: .regular, design: .monospaced))
                                .foregroundColor(.secondary)
                        }
                    }
                }
            }
            .frame(maxWidth: .infinity)
            .listRowBackground(Color(uiColor: .systemGroupedBackground))
            .buttonStyle(BorderlessButtonStyle())
            
            Section {
                HStack {
                    Text("Status")
                    Spacer()
                    
                    HStack(spacing: 8) {
                        Image(systemName: "circle.fill")
                            .resizable()
                            .frame(width: 8, height: 8, alignment: .center)
                            .foregroundColor(.green)
                        
                        Text(transaction.status.capitalized)
                            .fontWeight(.semibold)
                    }
                }
                
                HStack {
                    Text("Amount")
                    Spacer()
                    Text("\(viewModel.formatCurrency(double: transaction.transactionValue()))")
                        .lineLimit(1)
                        .textSelection(.enabled)
                }
            }
            
            Section() {
                if let from = transaction.addressFrom {
                    HStack {
                        Text("From")
                        Spacer()
                        Text(viewModel.truncatedAddress(addr: from))
                            .font(.system(size: 17, weight: .regular, design: .monospaced))
                    }
                }
                
                if let to = transaction.addressTo {
                    HStack {
                        Text("To")
                        Spacer()
                        Text(viewModel.truncatedAddress(addr: to))
                            .font(.system(size: 17, weight: .regular, design: .monospaced))
                    }
                }
                
                HStack {
                    Text("Fee")
                    Spacer()
                    VStack(alignment: .trailing, spacing: 8) {
                        Text("0.02 ETH")
                            .textSelection(.enabled)
                        Text("$13.24")
                            .textSelection(.enabled)
                    }
                }
                .padding(.vertical, 4)
            }
            
            Section {
                Button {
                    presentEtherscan = true
                } label: {
                    Text("View on Etherscan")
                        .fontWeight(.semibold)
                }
                
                Button {
                } label: {
                    Text("Report an Issue")
                        .fontWeight(.semibold)
                }
            }
        }
        .listStyle(.insetGrouped)
        .safariView(isPresented: $presentEtherscan) {
            SafariView(url: URL(string: "https://www.google.com")!)
        }
        .toast(isPresenting: $copyFromAddress) {
            AlertToast(displayMode: .hud, type: .regular, title: "Copied sender address")
        }
    }
}

struct TransactionDetailView_Previews: PreviewProvider {
    
    static let viewModel = CoinViewModel()
    
    static var previews: some View {
        TransactionDetailView(transaction: .dummy)
            .preferredColorScheme(.dark)
            .environmentObject(viewModel)
        
        TransactionDetailView(transaction: .dummy)
            .preferredColorScheme(.light)
            .environmentObject(viewModel)
    }
}

