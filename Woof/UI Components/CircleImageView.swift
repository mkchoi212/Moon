//
//  CircleImageView.swift
//  Woof
//
//  Created by Mike Choi on 1/8/22.
//

import Foundation
import SwiftUI

struct CircleImageView: View {
    var backgroundColor: Color?
    var url: URL?
    var icon: Image?
    
    var body: some View {
        ZStack {
            Circle()
                .foregroundColor(backgroundColor ?? .white)
           
            if let icon = icon {
                icon
            } else if let url = url {
                AsyncImage(url: url) { image in
                   image
                } placeholder: {
                    Circle()
                        .foregroundColor(.gray)
                }
            }
        }
    }
}
