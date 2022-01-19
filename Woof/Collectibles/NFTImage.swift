//
//  NFTImage.swift
//  Woof
//
//  Created by Mike Choi on 1/17/22.
//

import SwiftUI

extension Image {
    var nftCellImageModifier: some View {
        self
            .resizable()
            .aspectRatio(1, contentMode: .fill)
            .clipShape(RoundedRectangle(cornerRadius: 6))
    }
}

struct NFTImage: View {
    let resource: ImageResource
    
    var body: some View {
        switch resource {
            case .url(let url):
                AsyncImage(url: url) { image in
                    image.nftCellImageModifier
                } placeholder: {
                    RoundedRectangle(cornerRadius: 6)
                        .aspectRatio(1, contentMode: .fit)
                        .shimmering()
                }
            case .systemImageName(let string):
                Image(systemName: string).nftCellImageModifier
            case .imageName(let string):
                RoundedRectangle(cornerRadius: 6)
                    .aspectRatio(1, contentMode: .fill)
                    .foregroundColor(.white)
                    .overlay(Image(string).resizable().aspectRatio(contentMode: .fit))
        }
    }
}
    
struct NFTImage_Previews: PreviewProvider {
    static var previews: some View {
        NFTImage(resource: .imageName("ens"))
            .frame(width: 100, height: 100, alignment: .center)
    }
}

