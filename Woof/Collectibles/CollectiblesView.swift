//
//  CollectiblesView.swift
//  Woof
//
//  Created by Mike Choi on 1/16/22.
//

import Shimmer
import SwiftUI

struct CollectionDetailView: View {
    
    let collection: NFTCollection
    let nft: NFT
    
    @EnvironmentObject var viewModel: NFTViewModel
    
    var body: some View {
        ScrollView {
            let imageResource = viewModel.imageResource(for: nft, parentCollection: collection)
            NFTImage(resource: imageResource)
        }
    }
}

struct CollectionCell: View {
    let title: String
    let collection: NFTCollection
    let nfts: [NFT]
    
    let rows: [GridItem]
    let height: CGFloat
    
    @Binding var selectedCollection: NFTCollection?
    @Binding var selectedNFT: NFT?
    @Binding var isShowingDetail: Bool
    
    @EnvironmentObject var viewModel: NFTViewModel
    
    init(title: String, collection: NFTCollection, nfts: [NFT], selectedCollection: Binding<NFTCollection?>, selectedNFT: Binding<NFT?>, isShowingDetail: Binding<Bool>) {
        self.title = title
        self.collection = collection
        self.nfts = nfts
        self._selectedNFT = selectedNFT
        self._selectedCollection = selectedCollection
        self._isShowingDetail = isShowingDetail
        
        if nfts.count > 4 {
            rows = [GridItem(.fixed(180)), GridItem(.fixed(180))]
            height = 400
        } else {
            rows = [GridItem(.fixed(180))]
            height = 200
        }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 25) {
            HStack {
                Text(title)
                    .modifier(GridHeaderTextStyle())
                
                Spacer()
                
                Button("View All") {
                }
                .foregroundColor(.secondary)
            }
            .padding(.horizontal)
            
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHGrid(rows: rows, alignment: .top, spacing: 8) {
                    ForEach(nfts, id: \.self) { nft in
                        let imageResource = viewModel.imageResource(for: nft, parentCollection: collection)
                        NFTImage(resource: imageResource)
                            .onTapGesture {
                                withAnimation(.spring(response: 0.4, dampingFraction: 0.9)) {
                                    selectedCollection = collection
                                    selectedNFT = nft
                                    isShowingDetail.toggle()
                                }
                            }
                    }
                }
                .offset(x: 15, y: 0)
                .frame(height: height)
            }
        }
    }
}

struct CollectiblesContentView: View {
    @StateObject var viewModel = NFTViewModel()
    @EnvironmentObject var openSea: OpenSea
    
    @State var selectedCollection: NFTCollection?
    @State var selectedNFT: NFT?
    @State var isShowingDetail = false
    
    @Namespace var namespace
    
    var body: some View {
        if openSea.isLoading {
            ActivityIndicator()
                .progressViewStyle(.circular)
        } else {
            ZStack {
                if isShowingDetail {
                    CollectionDetailView(collection: selectedCollection!, nft: selectedNFT!)
                        .environmentObject(viewModel)
                        .matchedGeometryEffect(id: "shape", in: namespace)
                } else {
                    List {
                        ForEach(openSea.collectionTable.keys.sorted()) { collection in
                            CollectionCell(title: collection.name,
                                           collection: collection,
                                           nfts: openSea.collectionTable[collection] ?? [],
                                           selectedCollection: $selectedCollection,
                                           selectedNFT: $selectedNFT,
                                           isShowingDetail: $isShowingDetail)
                                .environmentObject(viewModel)
                                .modifier(PureCell())
                                .matchedGeometryEffect(id: "shape", in: namespace)
                        }
                    }
                    .listStyle(.plain)
                }
            }
        }
    }
}

struct CollectiblesView: View {
    @State var initialFetch = false
    @EnvironmentObject var openSea: OpenSea

    var body: some View {
        NavigationView {
            CollectiblesContentView()
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .principal, content: {
                        Text("Collectibles")
                            .font(.system(size: 17, weight: .semibold, design: .rounded))
                    })
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
    
    static var openSea: OpenSea = {
        let openSea = OpenSea()
        openSea.collectionTable = [.init(name: "hello", description: nil, createdDate: "123", slug: "ens", imageUrl: nil, largeImageUrl: nil, bannerImageUrl: nil, safelistRequestStatus: .approved, payoutAddress: nil, stats: NFTStats(oneDayVolume: 0, oneDayChange: 0, oneDaySales: 0, oneDayAveragePrice: 0, totalSupply: 0, totalSales: 0, totalVolume: 0, count: 0, floorPrice: 0, marketCap: 0, numOwners: 0), chatUrl: nil, discordUrl: nil, featuredImageUrl: nil, mediumUserName: nil, telegramUrl: nil, twitterUsername: nil, instagramUsername: nil, wikiUrl: nil, ownedAssetCount: 4): [NFT(tokenId: "asdf", imageUrl: nil, backgroundColor: nil, name: "hello", externalLink: nil, assetContract: nil)]]
        openSea.isLoading = false
        return openSea
    }()
    
    static var previews: some View {
        CollectiblesView()
            .environmentObject(CollectiblesView_Previews.openSea)
    }
}
