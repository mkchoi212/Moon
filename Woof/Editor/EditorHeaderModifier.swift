//
//  EditorHeaderModifier.swift
//  Woof
//
//  Created by Mike Choi on 12/15/21.
//

import SwiftUI

struct EditorHeaderModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.system(size: 22, weight: .semibold, design: .rounded))
    }
}
