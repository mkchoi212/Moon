//
//  ActionList.swift
//  Woof
//
//  Created by Mike Choi on 12/6/21.
//

import SwiftUI

final class ActionViewModel: ObservableObject {
    var entityMap: [String: TextEntity] = [:]
    
    func description(for action: CardRepresentable) -> AttributedString {
        var res = AttributedString()
        
        action.entities.enumerated().forEach { (i, entity) in
            let uuid = entity.id.uuidString
            
            if let action = entity.action {
                var sub: AttributedString
                
                if let filledText = entity.text {
                    sub = AttributedString(filledText)
                    sub.foregroundColor = .blue
                    sub.backgroundColor = .lightBlue
                    sub.font = .system(size: 18, weight: .semibold, design: .rounded)
                } else {
                    var placeholder = action.placeholder
                    if i > 0 {
                        placeholder = placeholder.lowercased()
                    }
                    sub = AttributedString(placeholder)
                    sub.foregroundColor = .gray
                    sub.backgroundColor = .lightBlue
                    sub.font = .system(size: 18, weight: .medium, design: .rounded)
                }
                
                sub.link = URL(string: "woof://\(uuid)")!
                res += sub
            } else {
                var sub = AttributedString(entity.text ?? "")
                sub.font = .system(size: 18)
                res += sub
            }
            
            entityMap[uuid] = entity
            
            if i < action.entities.count - 1 {
                res += AttributedString(" ")
            }
        }
        
        return res
    }
    
    func resolve(deeplink: URL) -> TextEntity? {
        if let id = deeplink.host {
            return entityMap[id]
        } else {
            return nil
        }
    }
    
    func editor(for entity: TextEntity) -> AnyView {
        switch entity.action {
            case .comparator(let comp):
                return AnyView(ComparatorEditor(selectedComparator: comp ?? .equal))
            default:
                return AnyView(EmptyView())
        }
    }
}

struct ActionCell: View {
    let action: CardRepresentable
    var remove: () -> ()
    
    @EnvironmentObject var viewModel: ActionViewModel
    @EnvironmentObject var editorViewModel: EditorSheetViewModel
    
    var body: some View {
        GenericActionCell(iconName: action.iconName,
                          color: action.color,
                          title: action.description,
                          description: viewModel.description(for: action),
                          backgroundColor: Color(uiColor: .secondarySystemGroupedBackground)) {
            remove()
        }
        .onOpenURL(perform: didOpenURL(url:))
    }

    func didOpenURL(url: URL) {
        guard let entity = viewModel.resolve(deeplink: url) else {
            return
        }
   
        editorViewModel.height = 340
        editorViewModel.content = viewModel.editor(for: entity)
        editorViewModel.presentSheet = true
    }
}

struct ActionList: View {
    @Binding var mode: Int
    @Binding var actions: [CardRepresentable]
    @StateObject var viewModel = ActionViewModel()
    @EnvironmentObject var editorViewModel: EditorSheetViewModel
    @Environment(\.managedObjectContext) private var viewContext
    
    let columns = [GridItem(.flexible())]
    
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
                        .environmentObject(viewModel)
                        .environmentObject(editorViewModel)
                    }
                }
            }
            .padding(.top, 15)
        }
    }
 
    func remove(action: CardRepresentable) {
        if let idx = actions.firstIndex(where: { $0.id == action.id }),
           let action = actions[idx] as? Condition {
            actions.remove(at: idx)
            
            do {
                viewContext.delete(action.entity!)
                try viewContext.save()
            }
            catch let err {
                print(err)
            }
        }
    }
}


struct ActionList_Previews: PreviewProvider {
    static var previews: some View {
        ActionList(mode: .constant(0), actions: .constant([Transfer(crypto: .eth, fromWallet: nil, toWallet: .mike, amount: 50), And()]))
    }
}

