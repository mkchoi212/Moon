//
//  CollectiblesDetailView.swift
//  Woof
//
//  Created by Mike Choi on 1/20/22.
//

import Foundation
import SwiftUI

struct CollectiblesDetailView: View {
    @Binding var selectedCollection: NFTCollection?
    @Binding var selectedNFT: NFT?
    @Binding var isDisplayingDetail: Bool
    @EnvironmentObject var viewModel: NFTViewModel
    
    var body: some View {
        ZStack(alignment: .topTrailing) {
            ScrollView {
                GeometryReader { proxy in
                    VStack(alignment: .center) {
                        let imageResource = viewModel.imageResource(for: selectedNFT!, parentCollection: selectedCollection!)
                        
                        NFTImage(resource: imageResource)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                            .frame(width: proxy.size.width * 0.8, height: proxy.size.width * 0.8)
                            .padding(.top)
                            .zIndex(10)
                        
                        Text("HELLO WORLD")
                    }
                    .frame(maxWidth: .infinity)
                }
            }
            
            Button {
                withAnimation {
                    isDisplayingDetail = false
                }
            } label: {
                Image(systemName: "xmark.circle.fill")
                    .resizable()
                    .frame(width: 30, height: 30, alignment: .trailing)
                    .symbolRenderingMode(.hierarchical)
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 19)
            .edgesIgnoringSafeArea(.all)
        }
        .background(.ultraThickMaterial)
    }
}

struct CollectiblesDetailView_Previews: PreviewProvider {
    static let nft = NFT(tokenId: "asdf", imageUrl: nil, backgroundColor: nil, name: "hello", externalLink: nil, assetContract: nil)
    
    static let collection = NFTCollection(name: "hello", description: nil, createdDate: "123", slug: "asdf", imageUrl: "https://lh3.googleusercontent.com/faRTnT7NgJ3mawHlRlpb9o7-_uSrPAeWt2FNPkPuymbIbXryZIAvT1yXR-nxZK7ZCW-oPuLfWuQmf-EmsJGXbZCzbOW-3UU4L_hy_MQ=s0", largeImageUrl: nil, bannerImageUrl: nil, safelistRequestStatus: .approved, payoutAddress: nil, stats: NFTStats(oneDayVolume: 0, oneDayChange: 0, oneDaySales: 0, oneDayAveragePrice: 0, totalSupply: 0, totalSales: 0, totalVolume: 0, count: 0, floorPrice: 0, marketCap: 0, numOwners: 0), chatUrl: nil, discordUrl: nil, featuredImageUrl: nil, mediumUserName: nil, telegramUrl: nil, twitterUsername: nil, instagramUsername: nil, wikiUrl: nil, ownedAssetCount: 4)
    
    static var openSea: OpenSea = {
        let openSea = OpenSea()
        openSea.collectionTable = [CollectiblesView_Previews.collection: [CollectiblesView_Previews.nft]]
        openSea.isLoading = false
        return openSea
    }()
    
    static let viewModel = NFTViewModel()
    
    static var previews: some View {
        CollectiblesDetailView(selectedCollection: .constant(CollectiblesView_Previews.collection),
                               selectedNFT: .constant(CollectiblesView_Previews.nft),
                               isDisplayingDetail: .constant(true))
            .environmentObject(CollectiblesView_Previews.viewModel)
    }
}
