//
//  RuleCreatorView.swift
//  Woof
//
//  Created by Mike Choi on 12/5/21.
//

import SwiftUI
import BottomSheet

enum RuleCreatorViewMode: Int {
    case condition, action
}

enum CustomBottomSheetPosition: CGFloat, CaseIterable {
    case top = 0.99
    case middle = 0.4
    case bottom = 0.125
}

struct RuleCreatorHeaderView: View {
    @Binding var name: String
    @Binding var iconColor: Color
    @Binding var imageName: String
    @Environment(\.presentationMode) var presentationMode
    
    @State var showIconSelector = false
    
    var body: some View {
        HStack(spacing: 12) {
            Button {
                showIconSelector = true
            } label: {
                ZStack {
                    RoundedRectangle(cornerRadius: 8)
                        .frame(width: 32, height: 32)
                        .foregroundColor(iconColor)
                    
                    Image(systemName: imageName)
                        .tint(.white)
                }.padding(2)
                    .overlay {
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(.purple)
                    }
            }
            
            TextField("Action name", text: $name)
                .font(.system(size: 20, weight: .semibold))
            
            Button {
                presentationMode.wrappedValue.dismiss()
            } label: {
                Image(systemName: "xmark.circle.fill")
                    .resizable()
                    .frame(width: 28, height: 28)
                    .tint(Color(uiColor: .lightGray))
            }
        }
        .sheet(isPresented: $showIconSelector) {
            NavigationView {
                IconPicker(selectedColor: $iconColor, selectedIconName: $imageName)
                    .navigationBarTitleDisplayMode(.inline)
            }
        }
    }
}

struct RuleCreatorView: View {
    @State var tabSelection = 0
    @State var name: String
    @State var iconColor: Color = .blue
    @State var imageName = "moon.fill"
    @State var searchText = ""
    @State var bottomSheetPosition: CustomBottomSheetPosition = .bottom
    
    var automation: Automation?
    
    init(automation: Automation?) {
        _name = State(initialValue: automation?.title ?? "")
        self.automation = automation
    }
    
    var body: some View {
        VStack(spacing: 0) {
            VStack(spacing: 12) {
                RuleCreatorHeaderView(name: $name, iconColor: $iconColor, imageName: $imageName)
                
                Picker("View mode", selection: $tabSelection) {
                    Text("Condition").tag(0)
                    Text("Action").tag(1)
                }
                .pickerStyle(.segmented)
            }
            .padding()
            .background(.thinMaterial)
            
            ScrollView {
                if tabSelection == RuleCreatorViewMode.condition.rawValue {
                    ActionList(actions: automation?.condition as? [CardRepresentable] ?? [])
                        .padding(.top, 15)
                } else {
                    ActionList(actions: automation?.actions as? [CardRepresentable] ?? [])
                        .padding(.top, 15)
                }
            }
            .frame(maxHeight: .infinity)
            
        }
        .background(Color(uiColor: .systemGroupedBackground))
        .bottomSheet(bottomSheetPosition: $bottomSheetPosition, options: [.appleScrollBehavior, .background(AnyView(Color(uiColor: .secondarySystemGroupedBackground))), .animation(.spring(response: 0.2, dampingFraction: 1, blendDuration: 0.4))], headerContent: {
            RuleCreatorSheetHeader(searchText: $searchText)
                .onTapGesture {
                    self.bottomSheetPosition = .top
                }
        }) {
            RuleCreatorSheet()
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
                .transition(.opacity)
                .animation(.easeInOut, value: bottomSheetPosition)
        }
    }
}

struct RuleCreatorView_Previews: PreviewProvider {
    static var previews: some View {
        RuleCreatorView(automation: .dummy.first)
            .preferredColorScheme(.dark)
        
        RuleCreatorView(automation: .dummy.first)
            .preferredColorScheme(.light)
    }
}
