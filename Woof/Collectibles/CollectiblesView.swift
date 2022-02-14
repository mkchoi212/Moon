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
    @EnvironmentObject var openSea: OpenSea
    
    @Binding var isDisplayingDetail: Bool
    @Binding var selection: NFTSelection?

    @State var selectedCollection: NFTCollection?
    
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
                            NavigationLink("", tag: collection, selection: $selectedCollection) {
                                CollectionView(collection: collection, nfts: nfts)
                                    .environmentObject(viewModel)
                            }
                            .hidden()
                            .frame(width: 0)
                            
                            Button("View All") {
                                selectedCollection = collection
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
    static var openSea: OpenSea = {
        let openSea = OpenSea()
        openSea.collectionTable = [NFTCollection.dummy: [NFT.random]]
        openSea.isLoading = false
        return openSea
    }()
    
    static let viewModel = NFTViewModel()
    
    static var previews: some View {
        CollectiblesView(nftSelection: .constant(nil))
            .environmentObject(CollectiblesView_Previews.openSea)
    }
}
