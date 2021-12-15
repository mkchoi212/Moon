//
//  BottomSheet.swift
//  BottomSheet
//
//  Created by Tieda Wei on 2020-04-25.
//  Copyright © 2020 Tieda Wei. All rights reserved.
//

import SwiftUI

struct BottomSheet<Content: View>: View {
    
    private var dragToDismissThreshold: CGFloat { height * 0.2 }
    private var grayBackgroundOpacity: Double { isPresented ? (0.4 - Double(draggedOffset)/600) : 0 }
    
    @State private var draggedOffset: CGFloat = 0
    @State private var previousDragValue: DragGesture.Value?

    @Binding var isPresented: Bool
    private let height: CGFloat
    private let topBarHeight: CGFloat
    private let topBarCornerRadius: CGFloat
    private let content: Content
    private let contentBackgroundColor: Color
    private let topBarBackgroundColor: Color
    private let showTopIndicator: Bool
    
    public init(
        isPresented: Binding<Bool>,
        height: CGFloat,
        topBarHeight: CGFloat = 30,
        topBarCornerRadius: CGFloat? = nil,
        topBarBackgroundColor: Color = Color(.systemBackground),
        contentBackgroundColor: Color = Color(.systemBackground),
        showTopIndicator: Bool,
        @ViewBuilder content: () -> Content
    ) {
        self.topBarBackgroundColor = topBarBackgroundColor
        self.contentBackgroundColor = contentBackgroundColor
        self._isPresented = isPresented
        self.height = height
        self.topBarHeight = topBarHeight
        if let topBarCornerRadius = topBarCornerRadius {
            self.topBarCornerRadius = topBarCornerRadius
        } else {
            self.topBarCornerRadius = topBarHeight / 3
        }
        self.showTopIndicator = showTopIndicator
        self.content = content()
    }
    
    public var body: some View {
        GeometryReader { geometry in
            ZStack {
                self.fullScreenLightGrayOverlay()
                VStack(spacing: 0) {
                    self.topBar(geometry: geometry)
                    VStack(spacing: -8) {
                        Spacer()
                        content
                            .padding(.bottom, geometry.safeAreaInsets.bottom)
                        Spacer()
                    }
                }
                .frame(height: self.height - min(self.draggedOffset*2, 0))
                .background(contentBackgroundColor)
                .cornerRadius(topBarCornerRadius, corners: [.topLeft, .topRight])
                .animation(.interactiveSpring(), value: topBarCornerRadius)
                .offset(y: isPresented ? (geometry.size.height/2 - height/2 + geometry.safeAreaInsets.bottom + draggedOffset) : (geometry.size.height/2 + height/2 + geometry.safeAreaInsets.bottom))
            }
        }
    }
    
    fileprivate func fullScreenLightGrayOverlay() -> some View {
        Color
            .black
            .opacity(grayBackgroundOpacity)
            .edgesIgnoringSafeArea(.all)
            .animation(.interactiveSpring(), value: grayBackgroundOpacity)
            .onTapGesture { self.isPresented = false }
    }
    
    fileprivate func topBar(geometry: GeometryProxy) -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: 6)
                .fill(Color.secondary)
                .frame(width: 40, height: 6)
                .opacity(showTopIndicator ? 1 : 0)
        }
        .frame(width: geometry.size.width, height: topBarHeight)
        .background(topBarBackgroundColor)
        .gesture(
            DragGesture()
                .onChanged({ (value) in
                    let offsetY = value.translation.height
                    if offsetY > -100 {
                        draggedOffset = offsetY
                    }
                    
                    previousDragValue = value
                    
                })
                .onEnded({ (value) in
                    self.draggedOffset = 0
                    if let yDiff = previousDragValue?.translation.height, yDiff > 70 {
                        self.isPresented = false
                    }
                })
        )
    }
}
