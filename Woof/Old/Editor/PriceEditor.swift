//
//  PriceEditor.swift
//  Woof
//
//  Created by Mike Choi on 12/18/21.
//

import SwiftUI

struct PriceEditor: View {
    @EnvironmentObject var viewModel: ActionViewModel
    let propertyId: String
    let cryptoSymbol: String?
    let amount: Double?
    @State var amountString: String
    
    init(property: CryptoAmountProperty) {
        amount = property.amount
        _amountString = State(initialValue: amount?.price ?? "")

        propertyId = property.id.uuidString
        cryptoSymbol = property.cryptoSymbol
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            HStack {
                Text("Enter an amount")
                    .modifier(EditorHeaderModifier())
                Spacer()
                BigXButton()
            }
            
            Spacer()
            
            NumberEntryContentView(string: $amountString, suffix: cryptoSymbol ?? "")
            
            Spacer()
            
            Button {
            } label: {
                Text("Save")
                    .modifier(SaveButtonModifier())
            }
        }
        .padding()
    }
}

struct PriceEditor_Previews: PreviewProvider {
    static var previews: some View {
        PriceEditor(property: .init(cryptoSymbol: "BTC", amount: 2))
    }
}
