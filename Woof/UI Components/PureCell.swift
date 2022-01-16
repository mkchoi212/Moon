//
//  PureCell.swift
//  Woof
//
//  Created by Mike Choi on 1/15/22.
//

import SwiftUI

struct PureCell: ViewModifier {
    func body(content: Content) -> some View {
        content
            .buttonStyle(BorderlessButtonStyle())
            .listRowSeparator(.hidden)
            .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
    }
}
