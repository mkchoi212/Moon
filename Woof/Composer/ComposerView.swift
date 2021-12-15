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

final class EditorSheetViewModel: ObservableObject {
    @Published var presentSheet = false
    @Published var height: CGFloat?
    var content: AnyView?
}

struct ComposerView: View {
    @State var mode: Int = 0
    
    @StateObject var viewModel: ComposerViewModel
    @StateObject var editorViewModel = EditorSheetViewModel()
    let panelDelegate = PanelDelegate()
    
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        ComposerContentView(mode: $mode, dismiss: dismiss)
            .environmentObject(viewModel)
            .environmentObject(editorViewModel)
            .floatingPanel(delegate: panelDelegate) { proxy in
                ComposerSheet(mode: $mode, proxy: proxy)
                    .environmentObject(viewModel)
                    .environmentObject(editorViewModel)
            }
            .floatingPanelSurfaceAppearance(.phone)
            .bottomSheet(isPresented: $editorViewModel.presentSheet, height: editorViewModel.height ?? 0) {
                editorViewModel.content ?? AnyView(EmptyView())
            }
    }
    
    func dismiss() {
        presentationMode.wrappedValue.dismiss()
    }
}

struct ComposerView_Previews: PreviewProvider {
    static var previews: some View {
        ComposerView(viewModel: ComposerViewModel(automation: Automation.dummy[0]))
            .preferredColorScheme(.light)
    }
}
