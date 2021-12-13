//
//  ComposerSheet.swift
//  Woof
//
//  Created by Mike Choi on 12/9/21.
//

import SwiftUI
import Introspect

struct RuleSheetHeaderModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .foregroundColor(Color(uiColor: .secondaryLabel))
            .font(.system(size: 15, weight: .semibold, design: .rounded))
    }
}

struct RuleOperatorRow: View {
    @EnvironmentObject var viewModel: ComposerViewModel
    
    var body: some View {
        Text("Logical operators")
            .modifier(RuleSheetHeaderModifier())
        
        HStack(alignment: .top, spacing: 15) {
            ForEach(OperatorType.allCases, id: \.self) { op in
                Button {
//                    viewModel.addCondition(op)
                } label: {
                    VStack {
                        RuleCell(image: AnyView(Text(op.description)
                                                    .foregroundColor(.white)
                                                    .font(.system(size: 17, weight: .bold, design: .monospaced))),
                                 color: op.color,
                                 title: op.rawValue.capitalized)
                    }
                }
                .buttonStyle(.plain)
            }
        }
    }
}

struct RulePropertyRow: View {
    @EnvironmentObject var viewModel: ComposerViewModel
    
    var body: some View {
        Text("Property")
            .modifier(RuleSheetHeaderModifier())
        
        HStack(alignment: .top, spacing: 15) {
            ForEach(ConditionType.allCases, id: \.self) { cond in
                Button {
                    viewModel.addCondition(cond)
                } label: {
                    VStack(alignment: .center) {
                        RuleCell(image: AnyView(Image(systemName: cond.iconName ?? "questionmark")
                                                    .foregroundColor(.white)
                                                    .font(.system(size: 24, weight: .bold))),
                                 color: cond.color,
                                 title: cond.description)
                    }
                }
                .buttonStyle(.plain)
            }
        }
    }
}

struct RuleCalendarRow: View {
    @EnvironmentObject var viewModel: ComposerViewModel
    
    var body: some View {
        Text("Calendar")
            .modifier(RuleSheetHeaderModifier())
        
        HStack(alignment: .top, spacing: 15) {
            ForEach(CalendarRule.allCases, id: \.self) { op in
                Button {
//                    viewModel.addCondition(op)
                } label: {
                    VStack(alignment: .center) {
                        RuleCell(image: AnyView(Text(op.abbreviation)
                                                    .foregroundColor(.white)
                                                    .font(.system(size: 24, weight: .bold, design: .rounded))),
                                 color: op.color,
                                 title: op.description)
                    }
                }
                .buttonStyle(.plain)
            }
        }
    }
}

struct ComposerSheet: View {
    @EnvironmentObject var viewModel: ComposerViewModel
    @Binding var mode: Int
    @State private var searchText = ""
    @State private var isShowingCancelButton = false
    var proxy: FloatingPanelProxy?
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                SearchBar(
                    "Search for \(mode == 0 ? "a condition" : "an action")",
                    text: $searchText,
                    isShowingCancelButton: $isShowingCancelButton
                ) { isFocused in
                    proxy?.move(to: isFocused ? .full : .half, animated: true)
                    isShowingCancelButton = isFocused
                } onCancel: {
                    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                }
                
                VStack(alignment: .leading, spacing: 12) {
                    RuleOperatorRow()
                    
                    if mode == ComposerViewMode.condition.rawValue {
                        Divider()
                        RulePropertyRow()
                        Divider()
                        RuleCalendarRow()
                        Divider()
                    } else {
                        
                    }
                    
                    Button {
                    } label: {
                        Label("Add suggestions", systemImage: "plus.circle.fill")
                            .font(.system(size: 18, weight: .medium))
                            .padding()
                            .tint(.blue)
                            .frame(maxWidth: .infinity)
                            .background(RoundedRectangle(cornerRadius: 12).foregroundColor(.lightBlue))
                    }
                    .padding(.trailing)
                }
                .padding(.leading)
            }
        }
        .introspectScrollView { scrollView in
            proxy?.track(scrollView: scrollView)
        }
        .padding(.top, 6)
        .background(Color(uiColor: .tertiarySystemBackground))
        .ignoresSafeArea()
    }
}

struct ComposerSheet_Previews: PreviewProvider {
    static var previews: some View {
        ComposerView(viewModel: ComposerViewModel(automation: .empty))
            .preferredColorScheme(.dark)
        
        ComposerView(viewModel: ComposerViewModel(automation: .empty))
            .preferredColorScheme(.light)
        
    }
}
