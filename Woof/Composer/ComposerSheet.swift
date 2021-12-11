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
            .font(.system(size: 14, weight: .regular))
            .multilineTextAlignment(.center)
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
                             color: op.color,
                             title: op.rawValue.capitalized)
                }
            }
        }
    }
}

struct RulePropertyRow: View {
    var body: some View {
        Text("Property")
            .modifier(RuleSheetHeaderModifier())
        
        ScrollView {
            HStack(spacing: 15) {
                ForEach(ConditionType.allCases, id: \.self) { cond in
                    VStack(alignment: .center) {
                        RuleCell(image: AnyView(Image(systemName: cond.iconName ?? "questionmark")
                                                    .foregroundColor(.white)
                                                    .font(.system(size: 24, weight: .bold))),
                                 color: cond.color,
                                 title: cond.description)
                        
                        Spacer()
                    }
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
                             color: op.color,
                             title: op.description)
                    
                    Spacer()
                }
            }
        }
    }
}

struct ComposerSheet: View {
    
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
    }
}
