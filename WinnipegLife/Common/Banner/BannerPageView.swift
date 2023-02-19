//
//  BannerPageView.swift
//  WinnipegLife
//
//  Created by changming wang on 6/5/21.
//

import SwiftUI
import SDWebImageSwiftUI

struct BannerPageView: View {
    
    
    var banner:BannerModel
    var models:[CommonViewModel]
    
    
    @State var spacing: CGFloat = 0
    @State var headspace: CGFloat = 0
    @State var sidesScaling: CGFloat = 1.0
    @State var isWrap: Bool = true
    @State var autoScroll: Bool = true
    @State var time: TimeInterval = 5
    @State var currentIndex: Int = 0
    
    @State var isActive = false
    @State private var bannerIndex: Int = 0
    
    var body: some View {
        ZStack(alignment:.bottom){
            NavigationLink.init(destination: BannerDetailView(content: models[bannerIndex]), isActive: $isActive) {}
            ACarousel(banner.imageUrls,
                      id: \.self,
                      index: $currentIndex,
                      spacing: spacing,
                      headspace: headspace,
                      sidesScaling: sidesScaling,
                      isWrap: isWrap,
                      autoScroll: autoScroll ? .active(time) : .inactive) { url in
            
                WebImage(url: URL(string: url))
                    .resizable()
                    .frame(width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height/4.5)
                    .aspectRatio(contentMode: .fill)
                    .onTapGesture {
                        bannerIndex = currentIndex
                        isActive.toggle()
                    }
                    
            }
            
            HStack(spacing: 8) {
                ForEach(0..<self.banner.imageUrls.count) { index in
                    BannerCircle(isSelected: Binding<Bool>(get: { self.currentIndex == index }, set: { _ in })) {
                        withAnimation {
                            self.currentIndex = index
                        }
                    }
                }
            }.offset(y: -10)
            
        }

    }
}

