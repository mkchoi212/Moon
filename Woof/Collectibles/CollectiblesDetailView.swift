//
//  CollectiblesDetailView.swift
//  Woof
//
//  Created by Mike Choi on 1/20/22.
//

import BetterSafariView
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
    
    @State var showEtherscan = false
    @Binding var toastPayload: ToastPayload?
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            RoundedRectangle(cornerRadius: 4)
                .frame(width: 42, height: 6, alignment: .center)
                .foregroundColor(.lightGray)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 14)
                .padding(.top, 4)
            
            NFTImage(resource: imageResource)
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .shadow(color: .black.opacity(0.2), radius: 10, x: 15, y: 15)
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
                        showEtherscan.toggle()
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
            
            Button {
            } label: {
                Text(collection.name)
                    .font(.system(size: 18, weight: .semibold, design: .rounded))
                    .foregroundColor(.blue)
            }
            
            HStack {
                Text("by \(nft.creator.user?.username ?? "unknown artist")")
                
                CircleImageView(url: nft.creator.profileImageUrl, icon: nil, iconPadding: 0)
                    .aspectRatio(1, contentMode: .fit)
                    .frame(width: 25)
            }
        }
        .safariView(isPresented: $showEtherscan) {
            SafariView(url: URL(string: nft.permalink ?? "")!, configuration: .init(entersReaderIfAvailable: false, barCollapsingEnabled: true))
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
    let feedback = UIImpactFeedbackGenerator(style: .rigid)
    
    var body: some View {
        List {
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
                            .font(.system(size: 15, weight: .regular))
                        
                        Text(nft.owner.address.prefix(12) + "...")
                            .foregroundColor(.secondary)
                            .font(.system(size: 15, weight: .regular, design: .monospaced))
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
        .toast(isPresenting: $presentToast, offsetY: 40) {
            AlertToast(displayMode: .hud, type: .regular, title: toastPayload?.message ?? "Done")
        }
        .onChange(of: toastPayload) { _ in
            presentToast = true
            feedback.impactOccurred()
        }
    }
}

struct CollectiblesDetailView_Previews: PreviewProvider {
    static var openSea: OpenSea = {
        let openSea = OpenSea()
        openSea.collectionTable = [NFTCollection.dummy: [NFT.random]]
        openSea.isLoading = false
        return openSea
    }()
    
    static let viewModel = NFTViewModel()
    
    static var previews: some View {
        CollectiblesDetailView(nft: NFT.random, collection: NFTCollection.dummy)
            .environmentObject(CollectiblesView_Previews.viewModel)
    }
}
