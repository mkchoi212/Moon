//
//  ComposerHeader.swift
//  Woof
//
//  Created by Mike Choi on 12/11/21.
//

import Foundation
import SwiftUI

struct ComposerHeaderView: View {
    @Binding var name: String
    @Binding var iconColor: Color
    @Binding var iconName: String
    @State var showIconSelector = false
    
    var dismiss: () -> ()
    
    var body: some View {
        HStack(spacing: 12) {
            Button {
                showIconSelector = true
            } label: {
                ZStack {
                    RoundedRectangle(cornerRadius: 8)
                        .frame(width: 32, height: 32)
                        .foregroundColor(iconColor)
                    
                    Image(systemName: iconName)
                        .tint(.white)
                }.padding(2)
                    .overlay {
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(.purple)
                    }
            }
            
            TextField("Action name", text: $name)
                .font(.system(size: 20, weight: .semibold))
            
            Button {
                dismiss()
            } label: {
                Image(systemName: "xmark.circle.fill")
                    .resizable()
                    .frame(width: 28, height: 28)
                    .tint(Color(uiColor: .lightGray))
            }
        }
        .sheet(isPresented: $showIconSelector) {
            NavigationView {
                IconPicker(selectedColor: $iconColor, selectedIconName: $iconName)
                    .navigationBarTitleDisplayMode(.inline)
            }
        }
    }
}
