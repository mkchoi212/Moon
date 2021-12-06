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

struct RuleCreatorSheetHeader: View {
    @Binding var searchText: String
    
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
            TextField("Search for actions", text: $searchText)
        }
        .foregroundColor(Color(uiColor: .secondaryLabel))
        .padding(.vertical, 8)
        .padding(.horizontal, 5)
        .background(RoundedRectangle(cornerRadius: 10).fill(Color(uiColor: .tertiarySystemFill)))
        .padding(.bottom)
    }
}

struct RuleCell: View {
    var image: AnyView
    var color: Color
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 12)
                .foregroundColor(color)
                .frame(width: 60, height: 60)
            
            image
        }
    }
}

struct RuleSheetHeaderModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .foregroundColor(Color(uiColor: .secondaryLabel))
            .font(.system(size: 15, weight: .semibold, design: .rounded))
    }
}

struct RuleSheetDescriptionLabelModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.system(size: 14, weight: .regular))
            .multilineTextAlignment(.center)
            .lineLimit(2)
    }
}

struct RuleOperatorRow: View {
    var body: some View {
        Text("Logical operators")
            .modifier(RuleSheetHeaderModifier())
        
        HStack(spacing: 15) {
            ForEach(LogicalOperator.allCases, id: \.self) { op in
                VStack {
                    RuleCell(image: AnyView(Text(op.description)
                                                .foregroundColor(.white)
                                                .font(.system(size: 17, weight: .bold, design: .monospaced))),
                             color: op.color)
                    
                    Text(op.rawValue.capitalized)
                        .modifier(RuleSheetDescriptionLabelModifier())
                }
            }
        }
    }
}

struct RulePropertyRow: View {
    var body: some View {
        Text("Property")
            .modifier(RuleSheetHeaderModifier())
        
        HStack(spacing: 15) {
            ForEach(Condition.allCases, id: \.self) { cond in
                VStack(alignment: .center) {
                    RuleCell(image: AnyView(cond.icon
                                                .foregroundColor(.white)
                                                .font(.system(size: 24, weight: .bold))),
                             color: cond.color)
                    
                    Text(cond.description)
                        .modifier(RuleSheetDescriptionLabelModifier())
                    
                    Spacer()
                }
            }
        }
    }
}

struct RuleCalendarRow: View {
    var body: some View {
        Text("Calendar")
            .modifier(RuleSheetHeaderModifier())
        
        HStack(spacing: 15) {
            ForEach(CalendarRule.allCases, id: \.self) { op in
                VStack(alignment: .center) {
                    RuleCell(image: AnyView(Text(op.abbreviation)
                                                .foregroundColor(.white)
                                                .font(.system(size: 24, weight: .bold, design: .rounded))),
                             color: op.color)
                    
                    Text(op.description)
                        .modifier(RuleSheetDescriptionLabelModifier())
                    
                    Spacer()
                }
            }
        }
    }
}

struct RuleCreatorSheet: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            RuleOperatorRow()
            Divider()
            RulePropertyRow()
            Divider()
            RuleCalendarRow()
            Divider()
            
            Button {
            } label: {
                Label("Add suggestions", systemImage: "plus.circle.fill")
                    .font(.system(size: 18, weight: .medium))
                    .padding()
                    .tint(.blue)
                    .frame(maxWidth: .infinity)
                    .background(RoundedRectangle(cornerRadius: 12).foregroundColor(Color(hex: "e3e6f5")))
            }
            .padding(.trailing)
        }
        .padding(.leading)
    }
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
                    ActionList(actions: [
                        Condition.percentageChange(.eth, .greater, 0.1),
                        LogicalOperator.and,
                        Condition.gasEth(.less, 100),
                        LogicalOperator.and,
                        Condition.wallet(Wallet(name: "Mike's Metamask", address: "0xf103eab10"), .eth, .greater, 1.45)
                    ])
                        .padding(.top, 15)
                } else {
                    ActionList(actions: [
                        Action.notification("foo"),
                        Action.buy(.eth, 1.0)
                    ])
                        .padding(.top, 15)
                }
            }
            .frame(maxHeight: .infinity)
            
        }
        .bottomSheet(bottomSheetPosition: self.$bottomSheetPosition, options: [.appleScrollBehavior, .background(AnyView(Color(uiColor: .systemGroupedBackground))), .animation(.spring(response: 0.2, dampingFraction: 1, blendDuration: 0.4))], headerContent: {
            RuleCreatorSheetHeader(searchText: $searchText)
                .onTapGesture {
                    self.bottomSheetPosition = .top
                }
        }) {
            RuleCreatorSheet()
                .frame(width: .infinity, height: .infinity, alignment: .leading)
                .transition(.opacity)
                .animation(.easeInOut)
        }
    }
}

struct RuleCreatorView_Previews: PreviewProvider {
    static var previews: some View {
        RuleCreatorView()
    }
}
