//
//  ActionList.swift
//  Woof
//
//  Created by Mike Choi on 12/6/21.
//

import SwiftUI

struct ActionList: View {
    
    @Binding var actions: [CardRepresentable]
    
    var body: some View {
        VStack(spacing: 18) {
            ForEach(actions, id: \.id) { action in
                if action is OperatorRepresentable {
                    Text(action.type.description)
                        .font(.system(size: 13, weight: .bold, design: .monospaced))
                        .foregroundColor(.white)
                        .padding(6)
                        .background(RoundedRectangle(cornerRadius: 4)
                                        .foregroundColor(Color(uiColor: .lightGray)))
                } else {
                    GenericActionCell(iconName: action.type.iconName,
                                      color: action.type.color,
                                      title: action.type.description,
                                      description: action.description,
                                      backgroundColor: Color(uiColor: .secondarySystemGroupedBackground))
                }
            }
        }
    }
}


struct ActionList_Previews: PreviewProvider {
    static var previews: some View {
        ActionList(actions: .constant([And(), Or()]))
        
        RuleCreatorView(automation: .empty)
    }
}

