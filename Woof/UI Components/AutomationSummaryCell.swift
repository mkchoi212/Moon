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
    var icon: String
    var iconFontSize: CGFloat
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: cornerRadius)
                .foregroundColor(color)
            
            Image(systemName: icon)
                .font(.system(size: iconFontSize, weight: .bold))
                .foregroundColor(.white)
        }
    }
}

struct ActionAbbreviationRow: View {
    var body: some View {
        HStack {
            IconSquare(cornerRadius: 4,
                       color: .blue,
                       icon: "circle",
                       iconFontSize: 12)
                .frame(width: 20, height: 20, alignment: .center)
            
            Text("ETH Gas")
                .font(.system(size: 12, design: .rounded))
        }
    }
}

struct ActionAbbreviation: View {
    var body: some View {
        VStack(alignment: .leading) {
            Text("Condition")
                .font(.system(size: 12, weight: .semibold, design: .rounded))
                .foregroundColor(.lightGray)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            ActionAbbreviationRow()
            ActionAbbreviationRow()
        }
        .frame(maxWidth: .infinity)
    }
}

struct AutomationSummaryCell: View {
    let automation: Automation
    
    var body: some View {
        ZStack(alignment: .leading) {
            RoundedRectangle(cornerRadius: 12)
                .foregroundColor(.white)
                .shadow(color: .black.opacity(0.08), radius: 20, x: 5, y: 5)
            
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    IconSquare(cornerRadius: 8,
                               color: automation.color,
                               icon: automation.icon,
                               iconFontSize: 20)
                        .frame(width: 30, height: 30, alignment: .center)
                    
                    Text(automation.title)
                        .font(.system(size: 18, weight: .semibold))
                        .lineLimit(2)
                    
                    Spacer()
                    
                    Button {
                        
                    } label: {
                        Image(systemName: "ellipsis.circle.fill")
                            .resizable()
                            .foregroundColor(.accentColor)
                    }
                    .frame(width: 24, height: 24)
                    
                }
                
                Spacer()
                
                HStack(alignment: .center) {
                    ActionAbbreviation()
                    Divider()
                    ActionAbbreviation()
                    
                    Spacer()
                }
                .frame(maxWidth: .infinity)
            }
            .padding()
        }
        .frame(height: 140)
    }
}

struct AutomationSummaryCell_Previews: PreviewProvider {
    static var previews: some View {
        AutomationSummaryCell(automation:  Automation.dummy.first!)
    }
}
