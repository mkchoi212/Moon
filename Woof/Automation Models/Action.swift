//
//  Action.swift
//  Woof
//
//  Created by Mike Choi on 12/6/21.
//

import SwiftUI

enum Action: Hashable, ConditionDisplayable {
    case notification(String)
    case text(String)
    case email(String)
    case buy(Crypto, Double)
    case sell(Crypto, Double)
    case transfer(Wallet, Wallet, Crypto, Double)
    case swap(Wallet, Crypto, Crypto, Double)
    
    var icon: Image {
        switch self {
            case .notification(_):
                return Image(systemName: "bell.badge.fill")
            case .text(_):
                return Image(systemName: "message.fill")
            case .email(_):
                return Image(systemName: "envelope.fill")
            case .buy(_, _):
                return Image(systemName: "cart.fill")
            case .sell(_, _):
                return Image(systemName: "sparkle")
            case .transfer(_, _, _, _):
                return Image(systemName: "arrow.left")
            case .swap(_, _, _, _):
                return Image(systemName: "arrow.left.arrow.right")
        }
    }
    
    var color: Color {
        switch self {
            case .notification(_):
                return .red
            case .text(_):
                return .green
            case .email(_):
                return Color(uiColor: .lightGray)
            case .buy(_, _):
                return .blue
            case .sell(_, _):
                return .green
            case .transfer(_, _, _, _):
                return .mint
            case .swap(_, _, _, _):
                return .cyan
        }
    }
    
    var description: String {
        switch self {
            case .notification(_):
                return "Send notification"
            case .text(_):
                return "Text message"
            case .email(_):
                return "Email"
            case .buy(_, _):
                return "Buy"
            case .sell(_, _):
                return "Sell"
            case .transfer(_, _, _, _):
                return "Transfer"
            case .swap(_, _, _, _):
                return "Swap"
        }
    }
    
    var humanizedDescription: Text {
        switch self {
            case .notification(_):
                return Text("Send notification")
                    .font(.system(size: 18))
            case .text(let phoneNumber):
                return Text("Text ")
                    .font(.system(size: 18))
                + Text(phoneNumber)
                    .foregroundColor(.blue)
                    .font(.system(size: 18, weight: .semibold))
            case .email(let email):
                return Text("Email ")
                    .font(.system(size: 18))
                + Text(email)
                    .foregroundColor(.blue)
                    .font(.system(size: 18, weight: .semibold))
            case .buy(let crypto, let double):
                return Text("Buy ")
                    .font(.system(size: 18))
                + Text("\(double.price) \(crypto.description)")
                    .foregroundColor(.blue)
                    .font(.system(size: 18, weight: .semibold))
            case .sell(let crypto, let double):
                return Text("Sell ")
                    .font(.system(size: 18))
                + Text("\(double.price) \(crypto.description)")
                    .foregroundColor(.blue)
                    .font(.system(size: 18, weight: .semibold))
            case .transfer(let fromWallet, let toWallet, let crypto, let double):
                return Text("Transfer ")
                    .font(.system(size: 18))
                + Text("\(double.price) \(crypto.description)")
                    .foregroundColor(.blue)
                    .font(.system(size: 18, weight: .semibold))
                + Text(" from ")
                    .font(.system(size: 18))
                +  Text(fromWallet.name)
                    .foregroundColor(.blue)
                    .font(.system(size: 18, weight: .semibold))
                + Text(" to ")
                    .font(.system(size: 18))
                +  Text(toWallet.name)
                    .foregroundColor(.blue)
                    .font(.system(size: 18, weight: .semibold))
            case .swap(let wallet, let fromCrypto, let toCrypto, let double):
                return Text("Swap ")
                    .font(.system(size: 18))
                + Text("\(double.price) \(fromCrypto.description)")
                    .foregroundColor(.blue)
                    .font(.system(size: 18, weight: .semibold))
                + Text(" to ")
                    .font(.system(size: 18))
                +  Text(toCrypto.description)
                    .foregroundColor(.blue)
                    .font(.system(size: 18, weight: .semibold))
                + Text(" in ")
                    .font(.system(size: 18))
                +  Text(wallet.name)
                    .foregroundColor(.blue)
                    .font(.system(size: 18, weight: .semibold))
        }
    }
    
    var id: String {
        String(hashValue)
    }
}
