//
//  Condition.swift
//  Woof
//
//  Created by Mike Choi on 12/6/21.
//

import SwiftUI

protocol CardRepresentable {
    var id: UUID { get }
    var type: TypeRepresentable { get }
    var description: Text { get }
}

protocol TypeRepresentable {
    var icon: Image? { get }
    var color: Color { get }
    var description: String { get }
}

protocol ConditionRepresentable { }

