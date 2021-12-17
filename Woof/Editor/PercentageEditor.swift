//
//  PercentageEditor.swift
//  Woof
//
//  Created by Mike Choi on 12/15/21.
//

import Combine
import SwiftUI
import Introspect

final class TextFieldToolbarState: ObservableObject {
    @Published var showMinus = false
    @Published var isInputActive = true
    var sinks = Set<AnyCancellable>()
    
    @objc func didPressDone() {
        isInputActive = false
    }
    
    @objc func didPressSignToggle() {
        showMinus.toggle()
    }
}

struct PercentageEditor: View {
    @State var percentageString: String
    var percentage: Double
    @State var didTapNegate = false
    @FocusState var isInputActive: Bool
    @StateObject var toolbarState = TextFieldToolbarState()
    
    init(percentage: Double) {
        self.percentage = percentage
        _percentageString = State(initialValue: String(percentage.percentage.dropLast()))
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            HStack {
                Text("Enter a percentage")
                    .modifier(EditorHeaderModifier())
                Spacer()
                BigXButton()
            }
            
            Spacer()
            
            HStack(alignment: .center, spacing: 1) {
                Spacer()
                TextField("0", text: $percentageString)
                    .font(.system(size: 32, weight: .semibold, design: .rounded))
                    .keyboardType(.decimalPad)
                    .multilineTextAlignment(.center)
                    .focused($isInputActive)
                    .introspectTextField { textField in
                        let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: textField.frame.size.width, height: 44))
                        let doneButton = UIBarButtonItem(title: "Done", style: .done, target: toolbarState, action: #selector(toolbarState.didPressDone))
                        let toggleSignButton = UIBarButtonItem(title: "+/-", style: .plain, target: toolbarState, action: #selector(toolbarState.didPressSignToggle))
                        
                        let flexibleSpace = UIBarButtonItem.flexibleSpace()
                        toolBar.items = [doneButton, flexibleSpace, toggleSignButton]
                        textField.inputAccessoryView = toolBar
                    }
                    .fixedSize(horizontal: true, vertical: false)
                
                Text("%")
                    .font(.system(size: 32, weight: .semibold, design: .rounded))
                
                Spacer()
            }
            
            Spacer()
            
            Button {
            } label: {
                Text("Save")
                    .modifier(SaveButtonModifier())
            }
        }
        .padding()
        .onAppear {
            isInputActive = true
            
            toolbarState.$isInputActive
                .assign(to: \.isInputActive, on: self)
                .store(in: &toolbarState.sinks)
            
             toolbarState.$showMinus
                .sink(receiveValue: { negate in
                    if negate, !percentageString.contains("-") {
                        percentageString = "-\(percentageString)"
                    } else if !negate {
                        percentageString = percentageString.filter { $0 != "-" && $0 != "." }
                    }
                })
                .store(in: &toolbarState.sinks)
        }
    }
    
    func didPressDone() {
        isInputActive = false
    }
}

struct PercentageEditor_Previews: PreviewProvider {
    static var previews: some View {
        PercentageEditor(percentage: 0)
    }
}
