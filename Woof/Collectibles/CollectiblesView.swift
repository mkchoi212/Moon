//
//  CollectiblesView.swift
//  Woof
//
//  Created by Mike Choi on 1/16/22.
//

import Shimmer
import SwiftUI

struct NFTSelection: Equatable, Identifiable {
    let nft: NFT
    let collection: NFTCollection
    
    let id = UUID()
}

struct CollectiblesList: View {
    @StateObject var viewModel = NFTViewModel()
    @StateObject var listviewModel = NFTViewModel()
    @EnvironmentObject var openSea: OpenSea
    
    @Binding var isDisplayingDetail: Bool
    @Binding var selection: NFTSelection?

    @State var displayAll = false
    
    var body: some View {
        List {
            ForEach(openSea.collectionTable.keys.sorted()) { collection in
                let nfts = openSea.collectionTable[collection] ?? []
                
                VStack(alignment: .leading, spacing: 25) {
                    HStack {
                        Text(collection.name)
                            .modifier(GridHeaderTextStyle())
                        
                        Spacer()
                        
                        ZStack {
                            NavigationLink(destination: Text("asdf"), isActive: $displayAll) {
                                EmptyView()
                            }
                            .frame(width: 0)
                            .hidden()
                            
                            Button("View All") {
                                displayAll.toggle()
                            }
                            .foregroundColor(.secondary)
                        }
                    }
                    .padding(.horizontal)
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        LazyHGrid(rows: viewModel.rows(for: nfts.count), alignment: .top, spacing: 8) {
                            ForEach(nfts, id: \.self) { nft in
                                let imageResource = viewModel.imageResource(for: nft, parentCollection: collection)
                                Button {
                                    selection = NFTSelection(nft: nft, collection: collection)
                                } label: {
                                    NFTImage(resource: imageResource)
                                }
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
    }
}

struct CollectiblesContentView: View {
    @State var isDisplayingDetail = false
    @Binding var nftSelection: NFTSelection?
    @Binding var retry: Bool
    
    @EnvironmentObject var openSea: OpenSea
    
    var body: some View {
        if openSea.isLoading {
            ActivityIndicator()
                .progressViewStyle(.circular)
        } else if openSea.isNotAvailable {
            VStack(alignment: .center, spacing: 15) {
                LottieView(fileName: "broken", loopForever: false)
                    .frame(width: 120, height: 120, alignment: .center)
                Text("Oops.. Something went wrong\nTap to retry")
                    .font(.system(size: 17, weight: .medium))
                    .foregroundColor(Color(uiColor: .secondaryLabel))
                    .multilineTextAlignment(.center)
            }
            .onTapGesture {
                retry.toggle()
            }
        } else {
            CollectiblesList(isDisplayingDetail: $isDisplayingDetail,
                             selection: $nftSelection)
                .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct CollectiblesView: View {
    @State var initialFetch = false
    @State var retry = false
    
    @Binding var nftSelection: NFTSelection?
    @EnvironmentObject var openSea: OpenSea
    
    var body: some View {
        NavigationView {
            CollectiblesContentView(nftSelection: $nftSelection, retry: $retry)
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
        .onChange(of: retry) { _ in
            openSea.isLoading = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                openSea.fetch()
            }
        }
    }
}

struct CollectiblesView_Previews: PreviewProvider {
    static let nft = NFT(owner: .init(user: .init(username: "adamtrannews"), profileImageUrl: "https://storage.googleapis.com/opensea-static/opensea-profile/19.png", address: "0x7becee3d6a7c1b7355fc04af63ec9a2f0a583436"), creator: .init(user: .init(username: "adamtrannews"), profileImageUrl: "https://storage.googleapis.com/opensea-static/opensea-profile/19.png", address: "0x7becee3d6a7c1b7355fc04af63ec9a2f0a583436"),
                         tokenId: "asdf",
                         imageUrl: "https://lh3.googleusercontent.com/jAnoAAC4aNNREN2qzvwyKBsm0u-9r89J0WLKOvUML-7wYqSkd2eu3Q-pt1PsIDDeDuKcHPNITCTfODy6EMC4cVFNWQuxDPUQYbAeGg=s0",
                         backgroundColor: nil,
                         name: "CryptoPunk #7842",
                         externalLink: nil,
                         permalink: "https://opensea.io/assets/0x495f947276749ce646f68ac8c248420045cb7b5e/56053100554430904991517213092900507939703437358200320741647226733043910705153",
                         assetContract: nil,
                         description: "Welcome to the home of Desperate ApeWife on OpenSea. About 333 Desperate ApeWife CLUB laser eyes NFTs on the Ethereum blockchain. 🤩🤩\n\nDiscover the best items in this collection, Desperate ApeWife is a collection of female laser eyes. Come browsing and purchase your most favorite items at our store 😍💯\n\n🤎We love and value female very much. We do not hesitate to send various gifts to owners of more than one item.💟💟",
                         traits: [.init(traitType: "Upper body", value: "Gangster", displayType: nil, maxValue: nil, traitCount: nil, order: nil), .init(traitType: "Skin Color", value: "Tycon", displayType: nil, maxValue: nil, traitCount: nil, order: nil), .init(traitType: "Hand", value: "Jules", displayType: nil, maxValue: nil, traitCount: 538, order: nil)])
    
    
    static let collection = NFTCollection(name: "hello", description: nil, createdDate: "123", slug: "asdf", imageUrl: "https://lh3.googleusercontent.com/faRTnT7NgJ3mawHlRlpb9o7-_uSrPAeWt2FNPkPuymbIbXryZIAvT1yXR-nxZK7ZCW-oPuLfWuQmf-EmsJGXbZCzbOW-3UU4L_hy_MQ=s0", largeImageUrl: nil, bannerImageUrl: nil, safelistRequestStatus: .approved, payoutAddress: nil, stats: NFTStats(oneDayVolume: 0, oneDayChange: 0, oneDaySales: 0, oneDayAveragePrice: 0, totalSupply: 0, totalSales: 0, totalVolume: 0, count: 0, floorPrice: 0, marketCap: 0, numOwners: 0), chatUrl: nil, discordUrl: nil, featuredImageUrl: nil, mediumUserName: nil, telegramUrl: nil, twitterUsername: nil, instagramUsername: nil, wikiUrl: nil, ownedAssetCount: 4)
    
    static var openSea: OpenSea = {
        let openSea = OpenSea()
        openSea.collectionTable = [CollectiblesView_Previews.collection: [CollectiblesView_Previews.nft]]
        openSea.isLoading = false
        return openSea
    }()
    
    static let viewModel = NFTViewModel()
    
    static var previews: some View {
        CollectiblesView(nftSelection: .constant(nil))
            .environmentObject(CollectiblesView_Previews.openSea)
    }
}
