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

struct RuleCreatorView: View {
    @Environment(\.presentationMode) var presentationMode
    
    @State var tabSelection = 0
    @State var name: String = ""
    @State var imageName = "moon.fill"
    @State var searchText = ""
    @State var bottomSheetPosition: CustomBottomSheetPosition = .bottom
    
    var body: some View {
        VStack(spacing: 0) {
            VStack(spacing: 12) {
                HStack(spacing: 12) {
                    Button {
                    } label: {
                        ZStack {
                            RoundedRectangle(cornerRadius: 8)
                                .frame(width: 32, height: 32)
                            
                            Image(systemName: imageName)
                                .tint(.white)
                        }.padding(2)
                            .overlay {
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(.purple)
                            }
                    }
                    
                    TextField("Action name", text: $name)
                    
                    Button {
                        presentationMode.wrappedValue.dismiss()
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .resizable()
                            .frame(width: 28, height: 28)
                            .tint(Color(uiColor: .lightGray))
                    }
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
                if tabSelection == RuleCreatorViewMode.condition.rawValue {
                    ConditionView()
                        .padding(.top, 15)
                } else {
                    Text("action")
                }
            }
            .frame(maxHeight: .infinity)
            
        }
        .bottomSheet(bottomSheetPosition: self.$bottomSheetPosition, options: [.appleScrollBehavior, .background(AnyView(Color(uiColor: .systemGroupedBackground))), .animation(.spring(response: 0.2, dampingFraction: 1, blendDuration: 0.4))], headerContent: {
            HStack {
                Image(systemName: "magnifyingglass")
                TextField("Search for actions", text: self.$searchText)
            }
            .foregroundColor(Color(uiColor: .secondaryLabel))
            .padding(.vertical, 8)
            .padding(.horizontal, 5)
            .background(RoundedRectangle(cornerRadius: 10).fill(Color(uiColor: .tertiarySystemFill)))
            .padding(.bottom)
            .onTapGesture {
                self.bottomSheetPosition = .top
            }
        }) {
            Text("sadf")
        }
    }
}

struct RuleCreatorView_Previews: PreviewProvider {
    static var previews: some View {
        RuleCreatorView()
    }
}
