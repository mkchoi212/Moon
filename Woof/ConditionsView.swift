//
//  ConditionsView.swift
//  Woof
//
//  Created by Mike Choi on 12/6/21.
//

import SwiftUI

struct ConditionCell: View {
    let condition: Condition
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack(spacing: 12) {
                condition.icon
                    .foregroundColor(.white)
                    .frame(width: 14, height: 14)
                    .background(RoundedRectangle(cornerRadius: 4)
                                    .foregroundColor(condition.color)
                                    .frame(width: 22, height: 22))
                
                Text(condition.description)
                    .font(.system(size: 15, weight: .medium, design: .rounded))
                    .foregroundColor(.gray)
                
                Spacer()
                
                Button {
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .resizable()
                        .symbolRenderingMode(.hierarchical)
                        .tint(.gray)
                        .frame(width: 20, height: 20)
                }
            }
            
            condition.humanizedDescription
        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 12)
                        .foregroundColor(Color(.systemBackground))
                        .shadow(color: .black.opacity(0.1), radius: 25, x: 8, y: 8))
        .padding(.horizontal)
    }
}

struct ConditionView: View {
    
    var conditions: [ConditionDisplayable] = [
        Condition.percentageChange(.eth, .greater, 0.1),
        LogicalOperator.and,
        Condition.gasEth(.less, 100),
        LogicalOperator.and,
        Condition.wallet(Wallet(name: "Mike's Metamask", address: "0xf103eab10"), .eth, .greater, 1.45)
    ]
    
    var body: some View {
        VStack(spacing: 18) {
            ForEach(conditions, id: \.id) { displayable in
                if let condition = displayable as? Condition {
                    ConditionCell(condition: condition)
                } else if let logicalOperator = displayable as? LogicalOperator {
                    Text(logicalOperator.description)
                        .font(.system(size: 13, weight: .bold, design: .monospaced))
                        .foregroundColor(.white)
                        .padding(6)
                        .background(RoundedRectangle(cornerRadius: 4)
                                        .foregroundColor(Color(uiColor: .lightGray)))
                }
            }
        }
    }
}

struct ConditionsView_Previews: PreviewProvider {
    static var previews: some View {
        ConditionView()
        
        RuleCreatorView()
    }
}
