//
//  GenericActionCell.swift
//  Woof
//
//  Created by Mike Choi on 12/6/21.
//

import SwiftUI

struct GenericActionCell: View {
    var icon: Image?
    var color: Color
    var title: String
    var description: Text
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack(spacing: 12) {
                ZStack {
                    RoundedRectangle(cornerRadius: 6)
                                    .foregroundColor(color)
                    
                    if let icon = icon {
                        icon
                            .resizable()
                            .foregroundColor(.white)
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 16, height: 16)
                    } else {
                        Text(title)
                    }
                }
                .frame(width: 25, height: 25)
                
                Text(title)
                    .font(.system(size: 15, weight: .medium, design: .rounded))
                    .foregroundColor(.gray)
                
                Spacer()
                
                Button {
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .resizable()
                        .symbolRenderingMode(.hierarchical)
                        .tint(.gray)
                        .frame(width: 20, height: 20)
                }
            }
            
            description
        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 12)
                        .foregroundColor(Color(.systemBackground))
                        .shadow(color: .black.opacity(0.1), radius: 25, x: 8, y: 8))
        .padding(.horizontal)
    }
}

struct GenericActionCell_Previews: PreviewProvider {
    static let dummyCondition = MarketCapChange(crypto: .eth, comparator: .less, price: 1000)
    
    static var previews: some View {
        GenericActionCell(icon: dummyCondition.type.icon,
                          color: dummyCondition.type.color,
                          title: dummyCondition.type.description,
                          description: dummyCondition.description)
    }
}
