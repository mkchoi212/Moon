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
    @State private var previousDragValue: DragGesture.Value?
    
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
    
    @State var offset: CGFloat = 0
    @State var isDragging = false
    
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
                List {
                    VStack {
                        GeometryReader { proxy in
                        self.topBar(geometry: proxy)
                            .preference(
                                key: ScrollOffsetPreferenceKey.self,
                                value: proxy.frame(in: .named("scrollView")).origin
                            )
                            .onPreferenceChange(ScrollOffsetPreferenceKey.self) { value in
                                if !isDragging {
                                    return
                                }
                                
                                if value.y > 13 {
                                    print(value.y)
                                    draggedOffset = value.y
                                }
                            }
                        }
                    }.frame(maxWidth: .infinity, alignment: .center)
                    
                    self.content()
                }
                .listStyle(.plain)
                .background(self.contentBackgroundColor)
                .cornerRadius(self.topBarCornerRadius, corners: [.topLeft, .topRight])
            }
            .animation(.interactiveSpring(response: 0.3, dampingFraction: 0.8), value: self.isPresented)
            .offset(y: self.isPresented ? (geometry.size.height/2 - self.height/2 + geometry.safeAreaInsets.bottom + self.draggedOffset) : (geometry.size.height/2 + self.height/2 + geometry.safeAreaInsets.bottom))
            .gesture(
                DragGesture()
                    .onChanged { value in
                        isDragging = true
                        print("is dragging")
                    }
                    .onEnded { _ in
                        print("drag ended")
                        
                        if draggedOffset > dragToDismissThreshold {
                            print("offset is \(draggedOffset)")
                            print("dismissing")
                            isPresented = false
                        }
                        
                        isDragging = false
                        draggedOffset = 0
                    })
        }
    }
    
    fileprivate func topBar(geometry: GeometryProxy) -> some View {
        RoundedRectangle(cornerRadius: 6)
            .fill(Color.secondary)
            .frame(width: 40, height: 6, alignment: .center)
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
            Text("ASdf")
            Text("ASdf")
            Text("ASdf")
            Text("ASdf")
        }
    }
}

struct FullModal_Previews: PreviewProvider {
    static var previews: some View {
        Demo()
    }
}
