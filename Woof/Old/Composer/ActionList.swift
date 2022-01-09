//
//  ActionList.swift
//  Woof
//
//  Created by Mike Choi on 12/6/21.
//

import SwiftUI

struct ActionCell: View {
    let action: CardRepresentable
    var remove: () -> ()
    
    @EnvironmentObject var editorViewModel: EditorSheetViewModel
    @EnvironmentObject var viewModel: ActionViewModel
    
    var body: some View {
        GenericActionCell(iconName: action.iconName,
                          color: action.color,
                          title: action.description,
                          description: $viewModel.attributedString,
                          backgroundColor: Color(uiColor: .secondarySystemGroupedBackground)) {
            remove()
        }
                          .onOpenURL(perform: didOpenURL(url:))
    }
    
    func didOpenURL(url: URL) {
        guard let property = viewModel.resolve(deeplink: url) else {
            return
        }
        
        editorViewModel.selectedAction = action
        editorViewModel.selectedProperty = property
    }
}

struct ActionList: View {
    @Binding var mode: Int
    @Binding var actions: [CardRepresentable]
    @EnvironmentObject var editorViewModel: EditorSheetViewModel
    
    @Environment(\.managedObjectContext) private var viewContext
    let columns = [GridItem(.flexible())]
    
    init(mode: Binding<Int>, actions: Binding<[CardRepresentable]>) {
        _mode = mode
        _actions = actions
    }
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 18) {
                ForEach(actions, id: \.id) { action in
                    if let action = action as? Operator {
                        Text(action.description)
                            .font(.system(size: 13, weight: .bold, design: .monospaced))
                            .foregroundColor(.white)
                            .padding(6)
                            .background(RoundedRectangle(cornerRadius: 4).foregroundColor(Color(uiColor: .lightGray)))
                    } else {
                        ActionCell(action: action) {
                            remove(action: action)
                        }
                        .environmentObject(editorViewModel)
                        .environmentObject(editorViewModel.actionViewModel(for: action))
                    }
                }
            }
            .padding(.top, 15)
        }
        .systemBottomSheet(item: $editorViewModel.selectedProperty,
                           detents: $editorViewModel.detents,
                           prefersGrabberVisible: true,
                           prefersScrollingExpandsWhenScrolledToEdge: true,
                           isModalInPresentation: false) {
            if let property = editorViewModel.selectedProperty,
               let action = editorViewModel.selectedAction {
                editorViewModel.editor(for: property)
                    .environmentObject(editorViewModel.actionViewModel(for: action))
            }
        }
    }
    
    func remove(action: CardRepresentable) {
        guard let idx = actions.firstIndex(where: { $0.id == action.id }) else {
            return
        }
        
        let action = actions[idx]
        actions.remove(at: idx)
        
        do {
            if (action as? Condition)?.coreDataModel(with: viewContext) != nil {
                try viewContext.save()
            }
        }
        catch let err {
            print(err)
        }
    }
}


struct ActionList_Previews: PreviewProvider {
    static var previews: some View {
        ActionList(mode: .constant(0), actions: .constant([Transfer(cryptoSymbol: "ETH", fromWallet: nil, toWallet: .mike, amount: 50), And()]))
    }
}

