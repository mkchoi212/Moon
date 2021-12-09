//
//  IconPicker.swift
//  Woof
//
//  Created by Mike Choi on 12/8/21.
//

import SwiftUI

struct ColorPickerRow: View {
    @Binding var selectedColor: Color
    
    let colors: [Color] = [
        .red, .orange, .yellow, .mint, .teal,
        .cyan, .blue, .indigo, .purple, .pink,
        .brown, .gray
    ]
    let columns = Array(repeating: GridItem(.flexible()), count: 6)
    
    var body: some View {
        GeometryReader { proxy in
            LazyVGrid(columns: columns, alignment: .center, spacing: 0) {
                ForEach(colors, id: \.self.hashValue) { color in
                    ZStack(alignment: .center) {
                        Circle()
                            .foregroundColor(color)
                            .aspectRatio(1, contentMode: .fit)
                            .frame(width: (proxy.size.width / 6) - 10)
                        
                        if color == selectedColor {
                            Circle()
                                .strokeBorder(color, lineWidth: 3)
                                .frame(width: proxy.size.width / 6)
                        }
                    }
                    .frame(width: proxy.size.width / 6, height: proxy.size.height / 2)
                    .onTapGesture {
                        selectedColor = color
                    }
                }
            }
        }
    }
}

struct GlyphPicker: View {
    let columns = Array(repeating: GridItem(.flexible()), count: 6)
    static let iconNames = [
        "sun.max.fill", "moon.fill", "sparkle", "sparkles", "moon.stars.fill",
        "cloud.fill", "cloud.rain.fill", "cloud.bolt.fill", "wind", "tornado", "umbrella.fill", "flame.fill",
        "lasso", "trash.fill", "folder.fill", "paperplane.fill", "tray.fill", "externaldrive.fill",
        "archivebox.fill", "xmark.bin.fill", "doc.fill", "arrow.up.doc.fill", "doc.text.fill", "doc.on.doc.fill",
        "terminal.fill", "arrowshape.turn.up.left.fill", "arrowshape.turn.up.right.fill", "book.fill",
        "books.vertical.fill", "magazine.fill", "newspaper.fill", "heart.text.square.fill", "bookmark.fill",
        "rosette", "graduationcap.fill", "ticket.fill", "link", "person.fill", "person.2.fill", "photo.artframe",
        "power.circle.fill", "peacesign", "globe", "globe.americas.fill", "globe.europe.africa.fill", "globe.asia.australia.fill", "checkmark.seal.fill", "xmark.seal.fill", "exclamationmark.triangle.fill",
        "drop.fill", "play.fill", "pause.fill", "stop.fill", "music.note", "magnifyingglass", "loupe", "mic.fill", "circle.fill",
        "triangle.fill", "diamond.fill", "octagon.fill", "hexagon.fill", "heart.fill", "suit.club.fill",
        "suit.diamond.fill", "bolt.heart.fill", "rhombus.fill", "star.fill", "flag.fill", "location.fill",
        "bell.fill", "tag.fill", "bolt.fill", "eyes.inverse", "mustache.fill", "mouth.fill", "facemask.fill",
        "brain", "bubble.right.fill", "quote.opening", "captions.bubble.fill", "phone.fill", "mail.fill",
        "gearshape", "line.3.crossed.swirl.circle.fill", "scissors", "bag.fill", "cart.fill", "creditcard.fill",
        "giftcard.fill", "dice.fill", "pianokeys.inverse", "paintbrush.fill", "hammer.fill",
        "scroll.fill", "theatermasks.fill", "puzzlepiece.fill", "building.columns.fill", "building.fill",
        "building.2.fill", "lock.fill", "lock.open.fill", "key.fill", "pin.fill", "map.fill", "powerplug.fill",
        "cpu.fill", "tv.fill", "guitars.fill", "airplane", "car.fill", "parkingsign", "cross.fill",
        "tortoise.fill", "ant.fill", "leaf.fill", "face.smiling.fill", "crown.fill", "photo.fill", "shield",
        "cube.fill", "scope", "alarm.fill", "gamecontroller.fill", "cup.and.saucer.fill", "hand.thumbsup.fill",
        "hand.thumbsdown.fill", "hand.point.up.left.fill", "hands.clap.fill", "chart.line.uptrend.xyaxis",
        "burst.fill", "waveform.path.ecg", "gift.fill", "hourglass", "grid", "lightbulb.fill",
        "questionmark.square.fill", "arrowtriangle.up.fill", "arrowtriangle.down.fill", "dollarsign.circle.fill"
    ]
    
    @Binding var selectedIconName: String
    
    static var rowCount: CGFloat {
        CGFloat(GlyphPicker.iconNames.count / 6)
    }
    
    var body: some View {
        GeometryReader { proxy in
            LazyVGrid(columns: columns, alignment: .center, spacing: 0) {
                ForEach(GlyphPicker.iconNames, id: \.self.hashValue) { iconName in
                    ZStack(alignment: .center) {
                        let cellWidth = proxy.size.width / 6
                        
                        Circle()
                            .foregroundColor(Color(uiColor: .tertiarySystemGroupedBackground))
                            .aspectRatio(1, contentMode: .fit)
                            .frame(width: cellWidth - 10)
                        
                        Image(systemName: iconName)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(maxWidth: cellWidth - 30, maxHeight: cellWidth - 30)
                            .foregroundColor(Color(uiColor: .secondaryLabel))
                        
                        if iconName == selectedIconName {
                            Circle()
                                .strokeBorder(.blue, lineWidth: 3)
                                .frame(width: cellWidth)
                        }
                    }
                    .frame(width: proxy.size.width / 6, height: proxy.size.width / 6)
                    .onTapGesture {
                        selectedIconName = iconName
                    }
                }
            }
        }
    }
}

struct IconPicker: View {
    @Binding var selectedColor: Color
    @Binding var selectedIconName: String
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack {
            IconSquare(cornerRadius: 24, color: selectedColor, icon: Image(systemName: selectedIconName), iconFontSize: 60)
                .frame(width: 110, height: 110, alignment: .center)
                .padding()
            
            List {
                Section {
                    ColorPickerRow(selectedColor: $selectedColor)
                        .frame(height: 140)
                }
                
                Section {
                    GlyphPicker(selectedIconName: $selectedIconName)
                        .frame(height: GlyphPicker.rowCount * 54)
                }
            }
            .listStyle(.insetGrouped)
        }
        .background(Color(uiColor: .systemGroupedBackground))
        .toolbar {
            ToolbarItem(placement: .confirmationAction) {
                Button("Save", role: .destructive) {
                    dismiss()
                }
            }
            
            ToolbarItem(placement: .cancellationAction) {
                Button("Cancel") {
                    dismiss()
                }
            }
        }
    }
    
    func dismiss() {
        presentationMode.wrappedValue.dismiss()
    }
}

struct IconPicker_Previews: PreviewProvider {
    static var previews: some View {
        IconPicker(selectedColor: .constant(.blue), selectedIconName: .constant("moon.fill"))
        IconPicker(selectedColor: .constant(.blue), selectedIconName: .constant("moon.fill"))
            .preferredColorScheme(.dark)
    }
}
