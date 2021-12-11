//
//  SendNotification.swift
//  Woof
//
//  Created by Mike Choi on 12/6/21.
//

import SwiftUI

struct SendNotification: CardRepresentable, Action {
    let type: TypeRepresentable = ActionType.notification
    
    let id: UUID = .init()
    let message: String
    
    var description: Text {
        return Text("Send notification")
            .font(.system(size: 18))
    }
}

extension SendNotification: Equatable {
    static func ==(lft: SendNotification, rht: SendNotification) -> Bool {
        lft.message == rht.message
    }
}
