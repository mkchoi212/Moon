//
//  CircleImageView.swift
//  Woof
//
//  Created by Mike Choi on 1/8/22.
//

import Foundation
import SwiftUI

struct CoinImageView: View {
    var iconUrl: String?
    
    var body: some View {
        CircleImageView(backgroundColor: Color(uiColor: .secondarySystemBackground),
                        url: iconUrl,
                        icon: Image("generic.coin"),
                        iconPadding: 6)
    }
}

struct CircleImageView: View {
    var backgroundColor: Color?
    var iconTintColor: Color?
    var url: URL?
    var icon: Image?
    var iconPadding: CGFloat
    
    init(backgroundColor: Color? = nil, iconTintColor: Color? = nil, url: String? = nil, icon: Image? = nil, iconPadding: CGFloat = 8.0) {
        self.backgroundColor = backgroundColor
        self.iconTintColor = iconTintColor
        self.iconPadding = iconPadding
        
        if let url = url {
            if url .contains("eth.png") {
                self.icon = Image("eth", bundle: nil)
            } else {
                self.url = URL(string: url )
            }
        } else {
            self.url = nil
            self.icon = icon
        }
    }
    
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
                .aspectRatio(contentMode: .fit)
                .foregroundColor(iconTintColor ?? .primary)
                .padding(iconPadding)
                .background(Circle().foregroundColor(backgroundColor ?? .gray))
        }
    }
}

struct CircleImageView_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            CircleImageView(backgroundColor: .lightBlue,
                            url: "https://token-icons.s3.amazonaws.com/eth.png")
                .frame(width: 32, height: 32)
            
            CircleImageView(backgroundColor: .lightBlue,
                            url: nil,
                            icon: Image(systemName: "moon.fill"))
                .frame(width: 32, height: 32)
            
            CircleImageView(backgroundColor: .lightBlue,
                            url: nil,
                            icon: Image("eth"))
                .frame(width: 32, height: 32)
        }
    }
}
