//
//  ComposerView.swift
//  Woof
//
//  Created by Mike Choi on 12/5/21.
//

import SwiftUI
import BottomSheet

enum ComposerViewMode: Int {
    case condition, action
}

enum CustomBottomSheetPosition: CGFloat, CaseIterable {
    case top = 0.99
    case middle = 0.4
    case bottom = 0.125
}

struct BottomSheetModifier: ViewModifier {
    @Binding var searchText: String
    @Binding var bottomSheetPosition: CustomBottomSheetPosition
    
    func body(content: Content) -> some View {
        content
            .bottomSheet(bottomSheetPosition: $bottomSheetPosition,
                         options: [.appleScrollBehavior, .background(AnyView(Color(uiColor: .secondarySystemGroupedBackground))), .animation(.spring(response: 0.2, dampingFraction: 1, blendDuration: 0.4))],
                         headerContent: {
                ComposerSheetHeader(searchText: $searchText)
                    .onTapGesture {
                        self.bottomSheetPosition = .top
                    }
            }) {
                ComposerSheet()
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
                    .transition(.opacity)
                    .animation(.easeInOut, value: bottomSheetPosition)
            }
    }
}

struct ComposerView: View {
    @State var tabSelection = 0
    @State var searchText = ""
    @State var bottomSheetPosition: CustomBottomSheetPosition = .bottom
    @State var showDismissConfirmation = false
    @StateObject var viewModel = ComposerViewModel()
    
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
        .onAppear(perform: {
            viewModel.set(automation: automation)
        })
        .background(Color(uiColor: .systemGroupedBackground))
        .modifier(BottomSheetModifier(searchText: $searchText, bottomSheetPosition: $bottomSheetPosition))
    }
    
    func dismiss() {
        if !viewModel.hasChanges() {
            presentationMode.wrappedValue.dismiss()
        } else {
           showDismissConfirmation = true
        }
    }
}

struct ComposerView_Previews: PreviewProvider {
    static var previews: some View {
        ComposerView(automation: .empty)
            .preferredColorScheme(.dark)
        
        ComposerView(automation: .empty)
            .preferredColorScheme(.light)
    }
}
