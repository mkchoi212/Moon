//
//  FullModal.swift
//  Woof
//
//  Created by Mike Choi on 1/20/22.
//

import SwiftUI

public struct FullModal<Content: View>: View {
    
    private var dragToDismissThreshold: CGFloat { height * 0.2 }
    private var grayBackgroundOpacity: Double { isPresented ? (0.4 - Double(draggedOffset)/600) : 0 }
    
    @State private var draggedOffset: CGFloat = 0

    @Binding var isPresented: Bool {
        didSet {
            if !isPresented {
                dismissed()
            }
        }
    }
    private let height: CGFloat
    private let topBarHeight: CGFloat
    private let topBarCornerRadius: CGFloat
    private let content: () -> Content
    private let dismissed: () -> ()
    private let contentBackgroundColor: Color
    private let topBarBackgroundColor: Color
    
    public init(
        isPresented: Binding<Bool>,
        topBarHeight: CGFloat = 30,
        topBarCornerRadius: CGFloat? = nil,
        topBarBackgroundColor: Color = Color(.systemBackground),
        contentBackgroundColor: Color = Color(.systemBackground),
        dismissed: @escaping () -> (),
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.topBarBackgroundColor = topBarBackgroundColor
        self.contentBackgroundColor = contentBackgroundColor
        self._isPresented = isPresented
        self.height = UIScreen.main.bounds.height
        self.topBarHeight = topBarHeight
        if let topBarCornerRadius = topBarCornerRadius {
            self.topBarCornerRadius = topBarCornerRadius
        } else {
            self.topBarCornerRadius = topBarHeight / 3
        }
        self.dismissed = dismissed
        self.content = content
    }
    
    public var body: some View {
        GeometryReader { geometry in
            ZStack {
                self.fullScreenLightGrayOverlay()
                VStack(spacing: 0) {
                    self.topBar(geometry: geometry)
                    VStack(spacing: -8) {
                        Spacer()
                        self.content()
                            .padding(.bottom, geometry.safeAreaInsets.bottom)
                        Spacer()
                    }
                }
                .frame(height: self.height - min(self.draggedOffset*2, 0))
                .background(self.contentBackgroundColor)
                .cornerRadius(self.topBarCornerRadius, corners: [.topLeft, .topRight])
                .animation(.interactiveSpring())
                .offset(y: self.isPresented ? (geometry.size.height/2 - self.height/2 + geometry.safeAreaInsets.bottom + self.draggedOffset) : (geometry.size.height/2 + self.height/2 + geometry.safeAreaInsets.bottom))
            }
            .gesture(
                DragGesture()
                    .onChanged({ (value) in
                        let offsetY = value.translation.height
                        self.draggedOffset = offsetY
                    })
                    .onEnded({ (value) in
                        let offsetY = value.translation.height
                        if offsetY > self.dragToDismissThreshold {
                            self.isPresented = false
                        }
                        self.draggedOffset = 0
                    })
            )
        }
    }
    
    fileprivate func fullScreenLightGrayOverlay() -> some View {
        Color
            .black
            .opacity(grayBackgroundOpacity)
            .edgesIgnoringSafeArea(.all)
            .animation(.interactiveSpring())
            .onTapGesture { self.isPresented = false }
    }
    
    fileprivate func topBar(geometry: GeometryProxy) -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: 6)
                .fill(Color.secondary)
                .frame(width: 40, height: 6)
        }
        .frame(width: geometry.size.width, height: topBarHeight)
        .background(topBarBackgroundColor)
    }
}

struct Demo: View {
    @State var present = false
    var body: some View {
        Button {
            present.toggle()
        } label: {
            Text("Present")
        }
        .fullScreenBottomSheet(isPresented: $present, dismissed: { }) {
            Text("Hello world :)")
        }
    }
}

struct FullModal_Previews: PreviewProvider {
    static var previews: some View {
        Demo()
    }
}
