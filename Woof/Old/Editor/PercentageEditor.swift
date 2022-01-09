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

struct NumberEntryContentView: View {
    @Binding var string: String
    var suffix: String
    @FocusState var isInputActive: Bool
    @StateObject var toolbarState = TextFieldToolbarState()
    
    var body: some View {
        HStack(alignment: .center, spacing: 1) {
            Spacer()
            
            TextField("0", text: $string)
                .font(.system(size: 32, weight: .semibold, design: .rounded))
                .keyboardType(.decimalPad)
                .multilineTextAlignment(.center)
                .focused($isInputActive)
                .introspectTextField { textField in
                    let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: textField.frame.size.width, height: 44))
                    let doneButton = UIBarButtonItem(title: "Done", style: .done, target: toolbarState, action: #selector(toolbarState.didPressDone))
                    let toggleSignButton = UIBarButtonItem(image: UIImage(systemName: "plusminus"), style: .done, target: toolbarState, action: #selector(toolbarState.didPressSignToggle))
                    
                    let flexibleSpace = UIBarButtonItem.flexibleSpace()
                    toolBar.items = [doneButton, flexibleSpace, toggleSignButton]
                    textField.inputAccessoryView = toolBar
                }
                .fixedSize(horizontal: true, vertical: false)
            
            Text(suffix)
                .font(.system(size: 32, weight: .semibold, design: .rounded))
            
            Spacer()
        }
        .onAppear {
            isInputActive = true
            
            toolbarState.$isInputActive
                .assign(to: \.isInputActive, on: self)
                .store(in: &toolbarState.sinks)
            
            toolbarState.$showMinus
                .sink(receiveValue: { negate in
                    if negate, !string.contains("-") {
                        string = "-\(string)"
                    } else if !negate {
                        string = string.filter { $0 != "-" && $0 != "." }
                    }
                })
                .store(in: &toolbarState.sinks)
        }
    }
}

struct PercentageEditor: View {
    @State var percentageString: String
    var percentage: Double?
    let propertyId: UUID
    
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var viewModel: ActionViewModel
    
    init(property: PercentageProperty) {
        self.percentage = property.value
        self.propertyId = property.id
        
        _percentageString = State(initialValue: String(percentage?.percentage.dropLast() ?? ""))
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
            NumberEntryContentView(string: $percentageString, suffix: "%")
            Spacer()
            
            Button {
                if let percentage = Double(percentageString) {
                    ((viewModel.action as? AnyEquatableCondition)?.condition as? PercentSettable)?.set(percent: percentage / 100.0, for: propertyId)
                    viewModel.generateDescription()
                    
                    presentationMode.wrappedValue.dismiss()
                }
            } label: {
                Text("Save")
                    .modifier(SaveButtonModifier())
            }
        }
        .padding()
    }
}

struct PercentageEditor_Previews: PreviewProvider {
    static var previews: some View {
        PercentageEditor(property: .init(value: nil))
    }
}
