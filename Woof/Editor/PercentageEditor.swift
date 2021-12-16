//
//  PercentageEditor.swift
//  Woof
//
//  Created by Mike Choi on 12/15/21.
//

import Foundation
import SwiftUI

struct PercentageEditor: View {
    @State var percentage: Double
    @FocusState var isInputActive: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            Text("Enter a percentage")
                .modifier(EditorHeaderModifier())
            
            HStack(alignment: .center, spacing: 1) {
                TextField("0.0%", value: $percentage, formatter: NumberFormatter.percentage, prompt: nil)
                    .font(.system(size: 32, weight: .semibold, design: .rounded))
                    .keyboardType(.decimalPad)
                    .multilineTextAlignment(.center)
                    .toolbar {
                        ToolbarItemGroup(placement: .automatic) {
                            Button("+/-") {
                                print("Clicked")
                            }
                            Button("Done") {
                                isInputActive = false
                            }
                        }
                    }
            }
            .padding()
        }
    }
}

struct PercentageEditor_Previews: PreviewProvider {
    static var previews: some View {
        PercentageEditor(percentage: 0)
    }
}
