//
//  BigXButton.swift
//  Woof
//
//  Created by Mike Choi on 12/17/21.
//

import Foundation
import SwiftUI

struct BigXButton: View {
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        Button {
            presentationMode.wrappedValue.dismiss()
        } label: {
            Image(systemName: "xmark.circle.fill")
                .resizable()
                .frame(width: 28, height: 28)
                .tint(Color(uiColor: .lightGray))
        }
    }
}
