//
//  Condition.swift
//  Woof
//
//  Created by Mike Choi on 12/6/21.
//

import SwiftUI

protocol CardRepresentable {
    var id: UUID { get }
    var iconName: String? { get }
    var color: Color { get }
    var description: String { get }
    var properties: [CardProperty] { get }
}
