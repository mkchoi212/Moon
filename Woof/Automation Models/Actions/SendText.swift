//
//  SendText.swift
//  Woof
//
//  Created by Mike Choi on 12/6/21.
//

import SwiftUI

struct SendText: CardRepresentable, Action {
    let type: TypeRepresentable = ActionType.text
    
    let id: UUID = .init()
    let phoneNumber: String
    
    var description: Text {
        return Text("Text ")
            .font(.system(size: 18))
        + Text(phoneNumber)
            .foregroundColor(.blue)
            .font(.system(size: 18, weight: .semibold))
    }
}
