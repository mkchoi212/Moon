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
            
            ScrollView {
                if mode == ComposerViewMode.condition.rawValue {
                    ActionList(actions: $viewModel.conditions)
                        .padding(.top, 15)
                } else {
                    ActionList(actions: $viewModel.actions)
                        .padding(.top, 15)
                }
            }
        }
        .background(Color(uiColor: .systemGroupedBackground))
    }
    
}

struct ComposerView: View {
    @State var mode: Int = 0
    @StateObject var viewModel: ComposerViewModel
    let panelDelegate = PanelDelegate()
    
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        ComposerContentView(mode: $mode, dismiss: dismiss)
            .environmentObject(viewModel)
            .floatingPanel(delegate: panelDelegate) { proxy in
                ComposerSheet(mode: $mode, proxy: proxy)
                    .environmentObject(viewModel)
            }
            .floatingPanelSurfaceAppearance(.phone)
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
