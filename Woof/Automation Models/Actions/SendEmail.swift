//
//  SendEmail.swift
//  Woof
//
//  Created by Mike Choi on 12/6/21.
//

import SwiftUI

struct SendEmail: CardRepresentable, Action {
    let type = ActionType.email
    
    let id: UUID = .init()
    let email: String
    
    var entities: [TextEntity] {
        [
            TextEntity(text: "Send mail to "),
            TextEntity(text: email, action: .email)
        ]
    }
}

extension SendEmail: Equatable {
    static func ==(lft: SendEmail, rht: SendEmail) -> Bool {
        lft.email == rht.email
    }
}

