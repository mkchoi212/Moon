//
//  ComposerView.swift
//  Woof
//
//  Created by Mike Choi on 12/5/21.
//

import SwiftUI
import FloatingPanel

enum ComposerViewMode: Int {
    case condition, action
}

struct ComposerContentView: View {
    @Binding var mode: Int
    @EnvironmentObject var viewModel: ComposerViewModel
    @EnvironmentObject var editorViewModel: EditorSheetViewModel

    var dismiss: () -> ()
    
    var body: some View {
        VStack(spacing: 0) {
            VStack(spacing: 12) {
                ComposerHeaderView(name: $viewModel.name, iconColor: $viewModel.iconColor, iconName: $viewModel.iconName) {
                    dismiss()
                }
                
                Picker("View mode", selection: $mode) {
                    Text("Condition").tag(0)
                    Text("Action").tag(1)
                }
                .pickerStyle(.segmented)
            }
            .padding()
            .background(.thinMaterial)
            
            ActionList(mode: $mode,
                       actions: mode == ComposerViewMode.condition.rawValue ?
                       $viewModel.conditions : $viewModel.actions)
                .environmentObject(editorViewModel)
        }
        .background(Color(uiColor: .systemGroupedBackground))
    }
}

struct ComposerView: View {
    @State var mode: Int = 0
    @StateObject var viewModel: ComposerViewModel
    @StateObject var editorViewModel = EditorSheetViewModel()
    
    let panelDelegate = PanelDelegate()
    
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.managedObjectContext) var viewContext
    
    var body: some View {
        ComposerContentView(mode: $mode, dismiss: dismiss)
            .floatingPanelSurfaceAppearance(.phone)
            .floatingPanel(delegate: panelDelegate) { proxy in
                ComposerSheet(mode: $mode, proxy: proxy)
                    .environmentObject(viewModel)
            }
            .onAppear {
                editorViewModel.setActions(actions: viewModel.actions)
            }
            .environmentObject(viewModel)
            .environmentObject(editorViewModel)
    }
    
    func dismiss() {
        if let err = save() {
            print(err)
        } else {
            presentationMode.wrappedValue.dismiss()
        }
    }
    
    func save() -> Error? {
        let automation = viewModel.newAutomation
        let _ = automation.coreDataModel(with: viewContext)
        
        do {
            try viewContext.save()
            return nil
        } catch let err {
            return err
        }
    }
}

struct ComposerView_Previews: PreviewProvider {
    static var previews: some View {
        ComposerView(viewModel: ComposerViewModel(automation: Automation.dummy[0]))
            .preferredColorScheme(.light)
    }
}
