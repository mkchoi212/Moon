//
//  PureCell.swift
//  Woof
//
//  Created by Mike Choi on 1/15/22.
//

import SwiftUI

struct PureCell: ViewModifier {
  
    let zeroInsets: Bool
    let sideInsets: CGFloat
    let bottomInset: CGFloat
    
    init(zeroInsets: Bool = false, sideInsets: CGFloat = 0, bottomInset: CGFloat = 0) {
        self.zeroInsets = zeroInsets
        self.sideInsets = sideInsets
        self.bottomInset = bottomInset
    }
    
    func body(content: Content) -> some View {
        content
            .buttonStyle(BorderlessButtonStyle())
            .listRowSeparator(.hidden)
            .listRowInsets(zeroInsets ? nil : EdgeInsets(top: 0, leading: sideInsets, bottom: bottomInset, trailing: sideInsets))
    }
}
