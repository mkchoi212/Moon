//
//  ComposerSheet.swift
//  Woof
//
//  Created by Mike Choi on 12/9/21.
//

import SwiftUI

struct ComposerSheetHeader: View {
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
            .lineLimit(2)
            .font(.system(size: 13, weight: .regular))
            .multilineTextAlignment(.center)
    }
}

struct RuleOperatorRow: View {
    @EnvironmentObject var viewModel: ComposerViewModel
    
    var body: some View {
        Text("Logical operators")
            .modifier(RuleSheetHeaderModifier())
        
        HStack(alignment: .top, spacing: 15) {
            ForEach(LogicalOperator.allCases, id: \.self) { op in
                Button {
                    viewModel.addCondition(op)
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
                    viewModel.addCondition(op)
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
                    .background(RoundedRectangle(cornerRadius: 12).foregroundColor(.lightBlue))
            }
            .padding(.trailing)
        }
        .padding(.leading)
    }
}

struct ComposerSheet_Previews: PreviewProvider {
    static var previews: some View {
        ComposerSheet()
        ComposerView(bottomSheetPosition: .top, automation: .empty)
    }
}
