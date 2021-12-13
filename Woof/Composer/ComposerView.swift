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

struct ComposerView: View {
    @State var tabSelection = 0
    @State var showDismissConfirmation = false
    @StateObject var viewModel = ComposerViewModel()
    let panelDelegate = PanelDelegate()
    var automation: Automation
    
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack(spacing: 0) {
            VStack(spacing: 12) {
                ComposerHeaderView(name: $viewModel.name, iconColor: $viewModel.iconColor, iconName: $viewModel.iconName) {
                    dismiss()
                }
                
                Picker("View mode", selection: $tabSelection) {
                    Text("Condition").tag(0)
                    Text("Action").tag(1)
                }
                .pickerStyle(.segmented)
            }
            .padding()
            .background(.thinMaterial)
            
            ScrollView {
                if tabSelection == ComposerViewMode.condition.rawValue {
                    ActionList(actions: $viewModel.conditions)
                        .padding(.top, 15)
                } else {
                    ActionList(actions: $viewModel.actions)
                        .padding(.top, 15)
                }
            }
            .frame(maxHeight: .infinity)
        }
        .floatingPanel(delegate: panelDelegate) { proxy in
            ComposerSheet(proxy: proxy)
                .environmentObject(viewModel)
        }
        .floatingPanelSurfaceAppearance(.phone)
        .onAppear(perform: {
            viewModel.set(automation: automation)
        })
        .background(Color(uiColor: .systemGroupedBackground))
        .actionSheet(isPresented: $showDismissConfirmation) {
            ActionSheet(title: Text("Discard changes?"), buttons: [
                .destructive(Text("Discard"), action: forceDismiss),
                .cancel(Text("Cancel"))
            ])
         }
    }
    
    func dismiss() {
        if !viewModel.hasChanges() {
            forceDismiss()
        } else {
           showDismissConfirmation = true
        }
    }
    
    func forceDismiss() {
        presentationMode.wrappedValue.dismiss()
    }
}

struct ComposerView_Previews: PreviewProvider {
    static var previews: some View {
        ComposerView(automation: Automation.dummy[0])
            .preferredColorScheme(.light)
    }
}
