//
//  CarouselView.swift
//  Fixe
//
//  Created by MRN7BAN on 06/12/25.
//


import SwiftUI

struct CarouselView<Content: View>: View {
    let items: [Any]
    let content: (Int) -> Content
    let autoScroll: Bool
    let delay: Double

    @State private var currentIndex: Int = 0
    @GestureState private var dragOffset: CGFloat = 0

    init(
        items: [Any],
        autoScroll: Bool = true,
        delay: Double = 3,
        @ViewBuilder content: @escaping (Int) -> Content
    ) {
        self.items = items
        self.content = content
        self.autoScroll = autoScroll
        self.delay = delay
    }

    var body: some View {
        GeometryReader { geo in
            ZStack(alignment: .bottom) {
                
                HStack(spacing: 0) {
                    ForEach(items.indices, id: \.self) { index in
                        content(index)
                            .frame(width: geo.size.width)
                    }
                }
                .offset(x: -CGFloat(currentIndex) * geo.size.width + dragOffset)
                .animation(.easeInOut, value: currentIndex)
                .gesture(
                    DragGesture()
                        .updating($dragOffset, body: { value, state, _ in
                            state = value.translation.width
                        })
                        .onEnded { value in
                            let threshold = geo.size.width * 0.3
                            if value.translation.width < -threshold {
                                next()
                            } else if value.translation.width > threshold {
                                previous()
                            }
                        }
                )

                // MARK: - Page Indicators
                HStack(spacing: 6) {
                    ForEach(items.indices, id: \.self) { index in
                        Circle()
                            .fill(currentIndex == index ? Color.accentColor : Color.gray.opacity(0.4))
                            .frame(width: 8, height: 8)
                    }
                }
            }
            .onAppear {
                if autoScroll {
                    startAutoScroll()
                }
            }
        }
        .frame(height: 220) // or dynamic height
    }

    // MARK: - Navigation
    private func next() {
        currentIndex = (currentIndex + 1) % items.count
    }

    private func previous() {
        currentIndex = (currentIndex - 1 + items.count) % items.count
    }

    private func startAutoScroll() {
        Timer.scheduledTimer(withTimeInterval: delay, repeats: true) { _ in
            next()
        }
    }
}
