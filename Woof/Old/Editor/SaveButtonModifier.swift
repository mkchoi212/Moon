//
//  SaveButtonModifier.swift
//  Woof
//
//  Created by Mike Choi on 12/16/21.
//

import Foundation
import SwiftUI

struct SaveButtonModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding()
            .font(.system(size: 17, weight: .medium, design: .rounded))
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .background(RoundedRectangle(cornerRadius: 12)
                            .foregroundColor(.themePrimary))
    }
}
