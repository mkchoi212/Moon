//
//  ActionList.swift
//  Woof
//
//  Created by Mike Choi on 12/6/21.
//

import SwiftUI

struct ActionList: View {
    
    var actions: [ConditionDisplayable]
    
    var body: some View {
        VStack(spacing: 18) {
            ForEach(actions, id: \.id) { action in
                if let condition = action as? Condition {
                    GenericActionCell(icon: condition.icon,
                                      color: condition.color,
                                      title: condition.description,
                                      description: condition.humanizedDescription)
                } else if let logicalOperator = action as? LogicalOperator {
                    Text(logicalOperator.description)
                        .font(.system(size: 13, weight: .bold, design: .monospaced))
                        .foregroundColor(.white)
                        .padding(6)
                        .background(RoundedRectangle(cornerRadius: 4)
                                        .foregroundColor(Color(uiColor: .lightGray)))
                } else if let action = action as? Action {
                    GenericActionCell(icon: action.icon,
                                      color: action.color,
                                      title: action.description,
                                      description: action.humanizedDescription)
                }
            }
        }
    }
}

struct ActionList_Previews: PreviewProvider {
    static var previews: some View {
        ActionList(actions: [])
        
        RuleCreatorView()
    }
}
