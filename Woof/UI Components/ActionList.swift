//
//  ActionList.swift
//  Woof
//
//  Created by Mike Choi on 12/6/21.
//

import SwiftUI

struct ActionViewModel {
    func description(for action: CardRepresentable) -> AttributedString {
        var res = AttributedString()
        
        action.entities.enumerated().forEach { (i, entity) in
            if let action = entity.action {
                var sub: AttributedString
                
                if let filledText = entity.text {
                    sub = AttributedString(filledText)
                    sub.foregroundColor = .blue
                    sub.backgroundColor = .lightBlue
                } else {
                    sub = AttributedString(action.placeholder)
                    sub.foregroundColor = .gray
                    sub.backgroundColor = .lightBlue
                }
                
                sub.link = URL(string: "woof://\(action.rawValue)")!
                sub.font = .system(size: 18, weight: .semibold, design: .rounded)
                res += sub
            } else {
                var sub = AttributedString(entity.text ?? "")
                sub.font = .system(size: 18)
                res += sub
            }
            
            if i < action.entities.count - 1 {
                res += AttributedString(" ")
            }
        }
        
        return res
    }
}

struct ActionList: View {
    @Binding var actions: [CardRepresentable]
    let viewModel = ActionViewModel()
    
    var body: some View {
        VStack(spacing: 18) {
            ForEach(actions, id: \.id) { action in
                if let action = action as? Operator {
                    Text(action.description)
                        .font(.system(size: 13, weight: .bold, design: .monospaced))
                        .foregroundColor(.white)
                        .padding(6)
                        .background(RoundedRectangle(cornerRadius: 4)
                                        .foregroundColor(Color(uiColor: .lightGray)))
                } else {
                    GenericActionCell(iconName: action.iconName,
                                      color: action.color,
                                      title: action.description,
                                      description: viewModel.description(for: action),
                                      backgroundColor: Color(uiColor: .secondarySystemGroupedBackground))
                }
            }
        }
        .onOpenURL { url in
            print(url)
        }
    }
}


struct ActionList_Previews: PreviewProvider {
    static var previews: some View {
        ActionList(actions: .constant([Transfer(crypto: .eth, fromWallet: nil, toWallet: .mike, amount: 50), And()]))
    }
}

