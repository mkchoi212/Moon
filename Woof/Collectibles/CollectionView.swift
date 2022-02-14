//
//  CollectionView.swift
//  Woof
//
//  Created by Mike Choi on 2/14/22.
//

import SwiftUI

struct CollectionView: View {
    let collection: NFTCollection
    let nfts: [NFT]
    
    @State var selection: NFTSelection?
    @EnvironmentObject var viewModel: NFTViewModel
    
    let columns = [GridItem(.flexible()), GridItem(.flexible())]
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            LazyVGrid(columns: columns, alignment: .center) {
                ForEach(nfts, id: \.self) { nft in
                    let imageResource = viewModel.imageResource(for: nft, parentCollection: collection)
                    Button {
                        selection = NFTSelection(nft: nft, collection: collection)
                    } label: {
                        VStack(alignment: .leading, spacing: 4) {
                            NFTImage(resource: imageResource)
                            Text(nft.name)
                        }
                        .padding(4)
                    }
                }
            }
            .padding(.horizontal)
            .padding(.top)
            .navigationTitle(collection.name)
        }
        .navigationBarTitleDisplayMode(.large)
        .sheet(item: $selection, content: { nft in
            CollectiblesDetailView(nft: nft.nft,
                                   collection: nft.collection)
        })
    }
}

struct CollectionView_Previews: PreviewProvider {
    static let viewModel = NFTViewModel()
    
    static var previews: some View {
        NavigationView {
            CollectionView(collection: NFTCollection.dummy, nfts: [NFT.random, NFT.random, NFT.random])
                .environmentObject(CollectionView_Previews.viewModel)
        }
    }
}
