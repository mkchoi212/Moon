//
//  ComparatorEditor.swift
//  Woof
//
//  Created by Mike Choi on 12/14/21.
//

import SwiftUI

struct ComparatorRow: View {
    var comparator: Comparator
    @Binding var selectedComparator: Comparator
    
    var body: some View {
        HStack {
            IconSquare(cornerRadius: 4, color: .lightBlue, iconName: comparator.imageName, iconFontSize: 14, iconTint: .blue)
                .frame(width: 20, height: 20)
            Spacer()
            Text(comparator.description.capitalized)
            Spacer()
            
            Image(systemName: "checkmark")
                .font(.system(size: 15, weight: .semibold))
                .foregroundColor(.blue)
                .opacity(comparator == selectedComparator ? 1 : 0)
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(RoundedRectangle(cornerRadius: 12)
                        .foregroundColor(Color(uiColor: .systemGroupedBackground)))
    }
}

struct ComparatorEditor: View {
    let columns = [GridItem(.flexible())]
    @State var selectedComparator: Comparator = .equal
    var save: (() -> ())?
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Choose a comparator")
                .modifier(EditorHeaderModifier())
            
            LazyVGrid(columns: columns, spacing: 15) {
                ForEach(Comparator.allCases, id: \.rawValue) { comp in
                    ComparatorRow(comparator: comp, selectedComparator: $selectedComparator)
                        .onTapGesture {
                            selectedComparator = comp
                        }
                }
            }
            
            Spacer()
            
            Button {
                save?()
            } label: {
                Text("Save")
                    .modifier(SaveButtonModifier())
            }
        }
        .padding()
    }
}

struct ComparatorEditor_Previews: PreviewProvider {
    static var previews: some View {
        ComparatorEditor(save: nil)
    }
}
