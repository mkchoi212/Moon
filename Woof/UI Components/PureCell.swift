//
//  PureCell.swift
//  Woof
//
//  Created by Mike Choi on 1/15/22.
//

import SwiftUI

struct PureCell: ViewModifier {
   
    let zeroInsets: Bool
    
    init(zeroInsets: Bool = true) {
        self.zeroInsets = zeroInsets
    }
    
    func body(content: Content) -> some View {
        content
            .buttonStyle(BorderlessButtonStyle())
            .listRowSeparator(.hidden)
            .listRowInsets(zeroInsets ? EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0) : nil )
    }
}
