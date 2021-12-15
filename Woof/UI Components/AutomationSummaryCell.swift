//
//  AutomationSummaryCell.swift
//  Woof
//
//  Created by Mike Choi on 12/6/21.
//

import SwiftUI

struct IconSquare: View {
    var cornerRadius: CGFloat
    var color: Color
    var iconName: String
    var iconFontSize: CGFloat
    var iconTint: Color = .white
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: cornerRadius)
                .foregroundColor(color)
            
            Image(systemName: iconName)
                .font(.system(size: iconFontSize, weight: .bold))
                .foregroundColor(iconTint)
        }
    }
}

struct ActionAbbreviationRow: View {
    var color: Color
    var iconName: String?
    var description: String
    
    var body: some View {
        HStack {
            IconSquare(cornerRadius: 4,
                       color: color,
                       iconName: iconName ?? "questionmark",
                       iconFontSize: 12)
                .frame(width: 22, height: 22, alignment: .center)
            
            Text(description)
                .font(.system(size: 12, design: .rounded))
        }
    }
}

struct ActionAbbreviation: View {
    var header: String
    var entities: [CardRepresentable]
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(header)
                .font(.system(size: 12, weight: .semibold, design: .rounded))
                .foregroundColor(.lightGray)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            ForEach(entities, id: \.id) { entity in
                ActionAbbreviationRow(color: entity.color,
                                      iconName: entity.iconName,
                                      description: entity.description)
            }
            
            Spacer()
        }
        .frame(maxWidth: .infinity)
    }
}

struct AutomationSummaryCell: View {
    let automation: Automation
    
    var body: some View {
        ZStack(alignment: .leading) {
            RoundedRectangle(cornerRadius: 12)
                .foregroundColor(Color(uiColor: .secondarySystemGroupedBackground))
                .shadow(color: .black.opacity(0.08), radius: 20, x: 5, y: 5)
            
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    IconSquare(cornerRadius: 8,
                               color: automation.color,
                               iconName: automation.iconName,
                               iconFontSize: 20)
                        .frame(width: 30, height: 30, alignment: .center)
                    
                    Text(automation.title)
                        .font(.system(size: 18, weight: .semibold))
                        .lineLimit(2)
                    
                    Spacer()
                    
                    Menu {
                        Button(action: share) {
                            Label("Share", systemImage: "square.and.arrow.up")
                        }
                        Button(role: .destructive, action: delete) {
                            Label("Delete", systemImage: "trash.fill")
                                .foregroundColor(.red)
                        }
                    } label: {
                        Image(systemName: "ellipsis.circle.fill")
                            .resizable()
                            .foregroundColor(.accentColor)
                            .frame(width: 24, height: 24)
                    }
                }
                
                Spacer()
                
                HStack(alignment: .center) {
                    ActionAbbreviation(header: "Conditions",
                                       entities: automation.conditions)
                    
                    Divider()
                    
                    ActionAbbreviation(header: "Actions",
                                       entities: automation.actions)
                    
                    Spacer()
                }
                .frame(maxWidth: .infinity)
            }
            .padding()
        }
        .frame(height: 140)
    }
    
    func delete() {
        
    }
    
    func share() {
        
    }
}

struct AutomationSummaryCell_Previews: PreviewProvider {
    static var previews: some View {
        AutomationSummaryCell(automation: Automation.dummy.first!)
            .preferredColorScheme(.dark)
        
        AutomationSummaryCell(automation: Automation.dummy.first!)
            .preferredColorScheme(.light)
    }
}
