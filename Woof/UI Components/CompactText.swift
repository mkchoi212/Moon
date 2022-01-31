//
//  CompactText.swift
//  Woof
//
//  Created by Mike Choi on 1/21/22.
//

import Foundation
import SwiftUI

public struct CompactText: View {
    var text : String
    
    var font: Font = .body
    var lineLimit : Int = 3
    var foregroundColor : Color = .primary
    
    var expandButtonText : String = "more"
    var expandButtonColor : Color = .blue
    
    var uiFont: UIFont = UIFont.preferredFont(forTextStyle: UIFont.TextStyle.body)
    @State private var expand : Bool = false
    @State private var truncated : Bool = false
    @State private var size : CGFloat = 0
    
    var didPressMore: () -> ()
    
    public init(text: String, didPressMore: @escaping () -> ()) {
        self.text = text
        self.didPressMore = didPressMore
    }
    
    public var body: some View {
        ZStack(alignment: .bottomTrailing){
            Text(text)
                .font(font)
                .foregroundColor(foregroundColor)
                .lineLimit(expand == true ? nil : lineLimit)
                .mask(
                    VStack(spacing: 0){
                        Rectangle()
                            .foregroundColor(.black)
                        
                        HStack(spacing: 0){
                            Rectangle()
                                .foregroundColor(.black)
                            if !expand && truncated{
                                HStack(alignment: .bottom,spacing: 0){
                                    LinearGradient(
                                        gradient: Gradient(stops: [
                                            Gradient.Stop(color: .black, location: 0),
                                            Gradient.Stop(color: .clear, location: 0.8)]),
                                        startPoint: .leading,
                                        endPoint: .trailing)
                                        .frame(width: 32, height: expandButtonText.heightOfString(usingFont: uiFont))
                                    
                                    Rectangle()
                                        .foregroundColor(.clear)
                                        .frame(width: expandButtonText.widthOfString(usingFont: uiFont), alignment: .center)
                                }
                            }
                        }
                        .frame(height: expandButtonText.heightOfString(usingFont: uiFont))
                    }
                )
            
            if truncated && !expand {
                Button(action: {
//                    self.expand = true
                    didPressMore()
                }, label: {
                    Text(expandButtonText)
                        .font(font)
                        .foregroundColor(expandButtonColor)
                })
            }
        }
        .background(
            Text(text)
                .lineLimit(lineLimit)
                .background(GeometryReader { geo in
                    Color.clear.onAppear() {
                        let size = CGSize(width: geo.size.width, height: .greatestFiniteMagnitude)
                        
                        let attributes:[NSAttributedString.Key:Any] = [NSAttributedString.Key.font: uiFont]
                        let attributedText = NSAttributedString(string: text, attributes: attributes)
                        
                        let textSize = attributedText.boundingRect(with: size, options: NSStringDrawingOptions.usesLineFragmentOrigin, context: nil)
                        
                        if textSize.size.height > geo.size.height {
                            truncated = true
                            
                            self.size = textSize.size.height
                        }
                    }
                })
                .hidden()
        )
    }
}

extension String {
    func heightOfString(usingFont font: UIFont) -> CGFloat {
        let fontAttributes = [NSAttributedString.Key.font: font]
        let size = self.size(withAttributes: fontAttributes)
        return size.height
    }
    
    func widthOfString(usingFont font: UIFont) -> CGFloat {
        let fontAttributes = [NSAttributedString.Key.font: font]
        let size = self.size(withAttributes: fontAttributes)
        return size.width
    }
}
