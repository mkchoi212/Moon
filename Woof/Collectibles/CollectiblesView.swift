//
//  CollectiblesView.swift
//  Woof
//
//  Created by Mike Choi on 1/16/22.
//

import Shimmer
import SwiftUI

struct CollectiblesDetailView: View {
    @Binding var selectedCollection: NFTCollection?
    @Binding var selectedNFT: NFTModel?
    @Binding var isDisplayingDetail: Bool
        
    @EnvironmentObject var viewModel: NFTViewModel
    var namespace: Namespace.ID
    
    var body: some View {
        ZStack(alignment: .topTrailing) {
            ScrollView {
                GeometryReader { proxy in
                    VStack(alignment: .center) {
                        let imageResource = viewModel.imageResource(for: selectedNFT!.nft, parentCollection: selectedCollection!)
                        
                        NFTImage(resource: imageResource)
                            .matchedGeometryEffect(id: selectedNFT!.nft.tokenId, in: namespace)
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
                
                withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                    selectedNFT?.isShowing = false
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

struct CollectiblesContentView: View {
    @StateObject var viewModel = NFTViewModel()
    @StateObject var listviewModel = NFTViewModel()
    @EnvironmentObject var openSea: OpenSea
    
    @State var selectedCollection: NFTCollection?
    @State var selectedNFT: NFTModel?
    @State var isDisplayingDetail = false
    
    @Binding var isStatusBarHidden: Bool
    @Namespace var namespace
    
    var body: some View {
        if openSea.isLoading {
            ActivityIndicator()
                .progressViewStyle(.circular)
        } else {
            ZStack {
                if !isDisplayingDetail {
                    listView
                }
                
                if isDisplayingDetail {
                    CollectiblesDetailView(selectedCollection: $selectedCollection, selectedNFT: $selectedNFT, isDisplayingDetail: $isDisplayingDetail, namespace: namespace)
                        .environmentObject(viewModel)
                }
            }
            .onChange(of: isDisplayingDetail) { newValue in
                isStatusBarHidden = newValue
            }
            .introspectTabBarController { tabBarController in
                tabBarController.tabBar.isHidden = isStatusBarHidden
            }
        }
    }
    
    var listView: some View {
        List {
            Text("Collections")
                .font(.system(size: 17, weight: .semibold, design: .rounded))
                .background(Color(uiColor: .systemBackground))
                .frame(maxWidth: .infinity, alignment: .center)
                .frame(height: 44)
                .modifier(PureCell())
            
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
                                    .matchedGeometryEffect(id: nft.nft.tokenId, in: namespace)
                                    .onTapGesture {
                                        withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                                            selectedCollection = collection
                                            selectedNFT = nft
                                            isDisplayingDetail = true
                                            nft.isShowing.toggle()
                                        }
                                    }
                            }
                        }
                        .offset(x: 15, y: 0)
                        .frame(height: viewModel.sectionHeight(for: nfts.count))
                    }
                    
                }
                .modifier(PureCell())
                .zIndex(1)
            }
        }
        .listStyle(.plain)
    }
}

struct CollectiblesView: View {
    @State var initialFetch = false
    @Binding var isStatusBarHidden: Bool
    @EnvironmentObject var openSea: OpenSea
    
    var body: some View {
        CollectiblesContentView(isStatusBarHidden: $isStatusBarHidden)
            .navigationBarHidden(true)
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
    
    @Namespace static var namespace
    
    static var previews: some View {
        CollectiblesDetailView(selectedCollection: .constant(CollectiblesView_Previews.collection),
                               selectedNFT: .constant(CollectiblesView_Previews.nft),
                               isDisplayingDetail: .constant(true),
                               namespace: namespace)
            .environmentObject(CollectiblesView_Previews.viewModel)
        
        CollectiblesView(isStatusBarHidden: .constant(false))
            .environmentObject(CollectiblesView_Previews.openSea)
    }
}
