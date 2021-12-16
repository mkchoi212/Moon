//
//  PercentageEditor.swift
//  Woof
//
//  Created by Mike Choi on 12/15/21.
//

import Foundation
import SwiftUI

struct TestTextfield: UIViewRepresentable {
    @Binding var text: String
    var keyType: UIKeyboardType
    
    func makeUIView(context: Context) -> UITextField {
        let textfield = UITextField()
        textfield.keyboardType = keyType
        let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: textfield.frame.size.width, height: 44))
        let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(textfield.doneButtonTapped(button:)))
        toolBar.items = [doneButton]
        toolBar.setItems([doneButton], animated: true)
        textfield.inputAccessoryView = toolBar
        return textfield
    }
    
    func updateUIView(_ uiView: UITextField, context: Context) {
        uiView.text = text
    }
}

extension  UITextField{
    @objc func doneButtonTapped(button:UIBarButtonItem) -> Void {
        self.resignFirstResponder()
    }
    
}

struct PercentageEditor: View {
    var percentage: Double
    @State var percentageString: String
    
    init(percentage: Double) {
        _percentageString = State(initialValue: percentage.percentage)
        self.percentage = percentage
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            Text("Enter a percentage")
                .modifier(EditorHeaderModifier())
            
            HStack(alignment: .center, spacing: 1) {
                TestTextfield(text: $percentageString, keyType: .numbersAndPunctuation)
                    .font(.system(size: 32, weight: .semibold, design: .rounded))
                    .keyboardType(.decimalPad)
                    .multilineTextAlignment(.center)
                    .textFieldStyle(.roundedBorder)
            }
        }
        .padding()
    }
}

struct PercentageEditor_Previews: PreviewProvider {
    static var previews: some View {
        PercentageEditor(percentage: 0)
    }
}
