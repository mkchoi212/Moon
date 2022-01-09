//
//  SendNotification.swift
//  Woof
//
//  Created by Mike Choi on 12/6/21.
//

import SwiftUI

struct SendNotification: CardRepresentable, Action {
    let type = ActionType.notification
    
    let id: UUID = .init()
    let message: String
    
    var properties: [CardProperty] {
        [
            StaticText(text: "Send notification")
        ]
    }
}

extension SendNotification: Equatable {
    static func ==(lft: SendNotification, rht: SendNotification) -> Bool {
        lft.message == rht.message
    }
}
