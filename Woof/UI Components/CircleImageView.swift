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
        if let url = url {
            AsyncImage(url: url) { image in
                image
                    .resizable()
            } placeholder: {
                Circle()
                    .foregroundColor(.lightGray.opacity(0.4))
            }
            .clipShape(Circle())
        } else if let icon = icon {
            icon
                .resizable()
                .padding(6)
                .background(Circle().foregroundColor(backgroundColor ?? .gray))
        }
    }
}

struct CircleImageView_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            CircleImageView(backgroundColor: .lightBlue,
                            url: URL(string: "https://token-icons.s3.amazonaws.com/eth.png"),
                            icon: nil)
                .frame(width: 32, height: 32)
            
            CircleImageView(backgroundColor: .lightBlue,
                            url: nil,
                            icon: Image(systemName: "moon.fill"))
                .frame(width: 32, height: 32)
        }
    }
}
