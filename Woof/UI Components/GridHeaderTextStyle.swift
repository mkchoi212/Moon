//
//  GridHeaderTextStyle.swift
//  Woof
//
//  Created by Mike Choi on 1/11/22.
//

import SwiftUI

struct GridHeaderTextStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.system(size: 25, weight: .medium))
    }
}
