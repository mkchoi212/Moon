//
//  CollectiblesDetailView.swift
//  Woof
//
//  Created by Mike Choi on 1/20/22.
//

import Foundation
import SwiftUI

struct TextEntity: Identifiable {
    let id = UUID()
    let text: String
}

struct ScrollableModalTextView: View {
    var title: String
    var text: String
    
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            ScrollView {
                Text(text)
                    .padding(.horizontal)
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text(title)
                        .font(.system(size: 17, weight: .semibold, design: .rounded))
                }
                
                ToolbarItem(placement: .cancellationAction) {
                    Button("Close") {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            }
        }
    }
}

struct CollectiblesHeaderView: View {
   
    var nft: NFT
    var collection: NFTCollection
    var imageResource: ImageResource
    
    @Binding var toastPayload: ToastPayload?
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            NFTImage(resource: imageResource)
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .shadow(color: .black.opacity(0.2), radius: 18, x: 15, y: 15)
                .padding(.bottom, 10)
            
            HStack(alignment: .center) {
                Text(nft.name)
                    .font(.system(size: 32, weight: .semibold))
                
                Spacer()
                
                Menu {
                    Button {
                    } label: {
                        Label("Share", systemImage: "square.and.arrow.up")
                    }
                    
                    Button {
                    } label: {
                        Label("View on Etherscan", systemImage: "link")
                    }
                    
                    Button {
                        UIPasteboard.general.string = nft.tokenId
                        toastPayload = ToastPayload(message: "Token copied")
                    } label: {
                        Label("Copy Token ID", systemImage: "doc.on.doc")
                    }
                } label: {
                    
                    Image(systemName: "ellipsis.circle")
                        .resizable()
                        .frame(width: 24, height: 24)
                        .foregroundColor(.blue)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
            Text(collection.name)
                .font(.system(size: 18, weight: .semibold, design: .rounded))
                .foregroundColor(.blue)
            
            HStack {
                Text("by ") + Text(nft.creator.user?.username ?? "unknown artist")
                
                CircleImageView(url: nft.creator.profileImageUrl, icon: nil, iconPadding: 0)
                    .aspectRatio(1, contentMode: .fit)
                    .frame(width: 25)
            }
        }
    }
}

struct CollectiblesDetailView: View {
    var nft: NFT
    var collection: NFTCollection
    @State var showMoreText: TextEntity?
    @State var presentToast = false
    @State var toastPayload: ToastPayload?
    
    @StateObject var viewModel = NFTViewModel()
    let cellModifier = PureCell(sideInsets: 15, bottomInset: 15)
    
    var body: some View {
        List {
            VStack(alignment: .center) {
                RoundedRectangle(cornerRadius: 4)
                    .frame(width: 42, height: 6, alignment: .center)
                    .foregroundColor(.lightGray)
            }
            .frame(maxWidth: .infinity)
            .modifier(PureCell())
            
            CollectiblesHeaderView(nft: nft,
                                   collection: collection,
                                   imageResource: viewModel.imageResource(for: nft, parentCollection: collection),
                                   toastPayload: $toastPayload)
                .modifier(cellModifier)
            
            VStack(alignment: .leading, spacing: 15) {
                Separator()
                
                Text("Owner")
                    .font(.system(size: 20, weight: .semibold, design: .rounded))
                
                HStack {
                    CircleImageView(url: nft.owner.profileImageUrl, icon: nil, iconPadding: 0)
                        .aspectRatio(1, contentMode: .fit)
                        .frame(width: 50)
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text(nft.owner.user?.username ?? "unknown")
                        Text(nft.owner.address.prefix(8) + "...")
                            .foregroundColor(.secondary)
                    }
                }
            }
            .modifier(cellModifier)
            
            VStack(alignment: .leading, spacing: 15) {
                Text("Description")
                    .font(.system(size: 20, weight: .semibold, design: .rounded))
                
                CompactText(text: nft.description ?? "", didPressMore: {
                    showMoreText = TextEntity(text: nft.description ?? "")
                })
                    .lineLimit(3)
            }
            .modifier(cellModifier)
            
            VStack(alignment: .leading, spacing: 15) {
                Separator()
                
                Text("Attributes")
                    .font(.system(size: 20, weight: .semibold, design: .rounded))
                
                LazyHGrid(rows: [GridItem(.flexible())], alignment: .top, spacing: 15) {
                    ForEach(nft.traits, id: \.hashValue) { trait in
                        VStack(alignment: .leading, spacing: 4) {
                            Text(trait.traitType.uppercased())
                                .foregroundColor(.blue)
                                .font(.system(size: 13, weight: .semibold, design: .rounded))
                            Text(trait.value)
                                .font(.system(size: 17, weight: .regular))
                        }
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 8).foregroundColor(.lightBlue))
                    }
                }
            }
            .modifier(cellModifier)
        }
        .listStyle(.plain)
        .sheet(item: $showMoreText) { text in
            ScrollableModalTextView(title: nft.name, text: text.text)
        }
        .toast(isPresenting: $presentToast, offsetY: 60) {
            AlertToast(displayMode: .hud, type: .regular, title: "Asdf")
        }
        .onChange(of: toastPayload) { _ in
            presentToast = true
        }
    }
}

struct CollectiblesDetailView_Previews: PreviewProvider {
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
    
    static let collection = NFTCollection(name: "CryptoPunks", description: "CryptoPunks launched as a fixed set of 10,000 items in mid-2017 and became one of the inspirations for the ERC-721 standard. They have been featured in places like The New York Times, Christie’s of London, Art|Basel Miami, and The PBS NewsHour.", createdDate: "123", slug: "CryptoPunks", imageUrl: "https://lh3.googleusercontent.com/jAnoAAC4aNNREN2qzvwyKBsm0u-9r89J0WLKOvUML-7wYqSkd2eu3Q-pt1PsIDDeDuKcHPNITCTfODy6EMC4cVFNWQuxDPUQYbAeGg=s0", largeImageUrl: nil, bannerImageUrl: nil, safelistRequestStatus: .approved, payoutAddress: nil, stats: NFTStats(oneDayVolume: 0, oneDayChange: 0, oneDaySales: 0, oneDayAveragePrice: 0, totalSupply: 0, totalSales: 0, totalVolume: 0, count: 0, floorPrice: 0, marketCap: 0, numOwners: 0), chatUrl: nil, discordUrl: nil, featuredImageUrl: nil, mediumUserName: nil, telegramUrl: nil, twitterUsername: nil, instagramUsername: nil, wikiUrl: nil, ownedAssetCount: 4)
    
    static var openSea: OpenSea = {
        let openSea = OpenSea()
        openSea.collectionTable = [CollectiblesDetailView_Previews.collection: [CollectiblesDetailView_Previews.nft]]
        openSea.isLoading = false
        return openSea
    }()
    
    static let viewModel = NFTViewModel()
    
    static var previews: some View {
        CollectiblesDetailView(nft: CollectiblesDetailView_Previews.nft, collection: CollectiblesDetailView_Previews.collection)
            .environmentObject(CollectiblesView_Previews.viewModel)
    }
}
