//
//  CollectiblesView.swift
//  Woof
//
//  Created by Mike Choi on 1/16/22.
//

import Shimmer
import SwiftUI


struct CollectiblesList: View {
    @StateObject var viewModel = NFTViewModel()
    @StateObject var listviewModel = NFTViewModel()
    @EnvironmentObject var openSea: OpenSea
    
    @State var selectedCollection: NFTCollection?
    @State var selectedNFT: NFTModel?
    @State var isDisplayingDetail = false
    
    @Binding var isStatusBarHidden: Bool
    
    var body: some View {
        List {
            ForEach(openSea.collectionTable.keys.sorted()) { collection in
                let nfts = openSea.collectionTable[collection] ?? []
                
                VStack(alignment: .leading, spacing: 25) {
                    HStack {
                        Text(collection.name)
                            .modifier(GridHeaderTextStyle())
                        
                        Spacer()
                        
                        Button("View All") {
                        }
                        .foregroundColor(.secondary)
                    }
                    .padding(.horizontal)
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        LazyHGrid(rows: viewModel.rows(for: nfts.count), alignment: .top, spacing: 8) {
                            ForEach(nfts, id: \.self) { nft in
                                let imageResource = viewModel.imageResource(for: nft.nft, parentCollection: collection)
                                NFTImage(resource: imageResource)
                            }
                        }
                        .frame(height: viewModel.sectionHeight(for: nfts.count))
                        .offset(x: 15)
                    }
                }
                .modifier(PureCell())
            }
        }
        .listStyle(.plain)
        .onChange(of: isDisplayingDetail) { newValue in
            isStatusBarHidden = newValue
        }
        .introspectTabBarController { tabBarController in
            tabBarController.tabBar.isHidden = isStatusBarHidden
        }
    }
}

struct CollectiblesContentView: View {
    @Binding var isStatusBarHidden: Bool
    @EnvironmentObject var openSea: OpenSea
    
    var body: some View {
        if openSea.isLoading {
            ActivityIndicator()
                .progressViewStyle(.circular)
        } else {
            CollectiblesList(isStatusBarHidden: $isStatusBarHidden)
                .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct CollectiblesView: View {
    @State var initialFetch = false
    @Binding var isStatusBarHidden: Bool
    @EnvironmentObject var openSea: OpenSea
    
    var body: some View {
        NavigationView {
            CollectiblesContentView(isStatusBarHidden: $isStatusBarHidden)
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .principal) {
                        Text("Collectibles")
                            .font(.system(size: 17, weight: .semibold, design: .rounded))
                    }
                }
        }
        .onAppear {
            if !initialFetch {
                openSea.fetch()
                initialFetch.toggle()
            }
        }
    }
}

struct CollectiblesView_Previews: PreviewProvider {
    static let nft: NFTModel = NFTModel(nft: NFT(tokenId: "asdf", imageUrl: nil, backgroundColor: nil, name: "hello", externalLink: nil, assetContract: nil))
    
    static let collection = NFTCollection(name: "hello", description: nil, createdDate: "123", slug: "asdf", imageUrl: "https://lh3.googleusercontent.com/faRTnT7NgJ3mawHlRlpb9o7-_uSrPAeWt2FNPkPuymbIbXryZIAvT1yXR-nxZK7ZCW-oPuLfWuQmf-EmsJGXbZCzbOW-3UU4L_hy_MQ=s0", largeImageUrl: nil, bannerImageUrl: nil, safelistRequestStatus: .approved, payoutAddress: nil, stats: NFTStats(oneDayVolume: 0, oneDayChange: 0, oneDaySales: 0, oneDayAveragePrice: 0, totalSupply: 0, totalSales: 0, totalVolume: 0, count: 0, floorPrice: 0, marketCap: 0, numOwners: 0), chatUrl: nil, discordUrl: nil, featuredImageUrl: nil, mediumUserName: nil, telegramUrl: nil, twitterUsername: nil, instagramUsername: nil, wikiUrl: nil, ownedAssetCount: 4)
    
    static var openSea: OpenSea = {
        let openSea = OpenSea()
        openSea.collectionTable = [CollectiblesView_Previews.collection: [CollectiblesView_Previews.nft]]
        openSea.isLoading = false
        return openSea
    }()
    
    static let viewModel = NFTViewModel()
    
    static var previews: some View {
        CollectiblesView(isStatusBarHidden: .constant(false))
            .environmentObject(CollectiblesView_Previews.openSea)
    }
}
