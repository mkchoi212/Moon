//
//  Separator.swift
//  Woof
//
//  Created by Mike Choi on 1/8/22.
//

import SwiftUI

struct Separator: View {
    var text: String?
    
    var line: some View {
        VStack { Divider() }
    }
    
    var body: some View {
        HStack(alignment: .center, spacing: 10) {
            line
            
            if let text = text {
                Text(text)
                    .font(.system(size: 14, weight: .medium, design: .rounded))
                    .foregroundColor(Color(uiColor: .separator))
                
                line
            }
        }
    }
}
