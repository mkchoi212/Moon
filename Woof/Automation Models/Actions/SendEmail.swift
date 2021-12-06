//
//  SendEmail.swift
//  Woof
//
//  Created by Mike Choi on 12/6/21.
//

import SwiftUI

struct SendEmail: CardRepresentable, Action {
    let type: TypeRepresentable = ActionType.email
    
    let id: UUID = .init()
    let email: String
    
    var description: Text {
        return Text("Email ")
            .font(.system(size: 18))
        + Text(email)
            .foregroundColor(.blue)
            .font(.system(size: 18, weight: .semibold))
    }
}
