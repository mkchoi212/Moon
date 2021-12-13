//
//  RuleCell.swift
//  Woof
//
//  Created by Mike Choi on 12/9/21.
//

import SwiftUI

struct RuleSheetDescriptionLabelModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .lineLimit(2)
            .font(.system(size: 13, weight: .regular))
            .multilineTextAlignment(.center)
    }
}

struct RuleCell: View {
    var image: AnyView
    var color: Color
    var title: String
    
    var body: some View {
        VStack(alignment: .center, spacing: 8) {
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .foregroundColor(color)
                    .frame(width: 60, height: 60)
                
                image
            }
            
            Text(title)
                .modifier(RuleSheetDescriptionLabelModifier())
        }
    }
}

struct RuleCell_Previews: PreviewProvider {
    static var previews: some View {
        RuleCell(image: AnyView(Image(systemName: "moon.fill")), color: .blue, title: "to the moon")
    }
}
