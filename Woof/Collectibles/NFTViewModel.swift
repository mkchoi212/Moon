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
    
    func rows(for nftCount: Int) -> [GridItem] {
        if nftCount > 4 {
            return [GridItem(.fixed(180)), GridItem(.fixed(180))]
        } else {
            return [GridItem(.fixed(180))]
        }
    }
    
    func sectionHeight(for nftCount: Int) -> CGFloat {
        if nftCount > 4 {
            return 400
        } else {
            return 200
        }
    }
}
