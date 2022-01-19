//
//  NFTViewModel.swift
//  Woof
//
//  Created by Mike Choi on 1/17/22.
//

import Foundation
import SwiftUI

enum ImageResource {
    case url(URL)
    case systemImageName(String)
    case imageName(String)
}

final class NFTViewModel: ObservableObject {
    init() { }
    
    func imageResource(for nft: NFT, parentCollection: NFTCollection) -> ImageResource {
        if let urlString = nft.imageUrl, let url = URL(string: urlString) {
            return .url(url)
        } else {
            // Add more hard coded images in the future
            switch parentCollection.slug {
                case "ens":
                    return .imageName("ens")
                default:
                    ()
            }
            
            let parentUrls = [parentCollection.imageUrl, parentCollection.largeImageUrl, parentCollection.bannerImageUrl].compactMap {
                $0
            }.compactMap(URL.init)
            
            if let first = parentUrls.first {
                return .url(first)
            } else {
                return .systemImageName("photo")
            }
        }
    }
}
