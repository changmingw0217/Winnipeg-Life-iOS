//
//  AdvertisingBoard.swift
//  WPGL
//
//  Created by changming wang on 6/3/21.
//

import SwiftUI
import SDWebImageSwiftUI

struct AdvertisingBoard: View {
    var urls:[String]

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
            NavigationLink.init(destination: Text("Hello\(bannerIndex + 1)"), isActive: $isActive) {}
            ACarousel(urls,
                      id: \.self,
                      index: $currentIndex,
                      spacing: spacing,
                      headspace: headspace,
                      sidesScaling: sidesScaling,
                      isWrap: isWrap,
                      autoScroll: autoScroll ? .active(time) : .inactive) { url in
                
                
                WebImage(url: URL(string: url))
                    .resizable()
                    .frame(width: UIScreen.main.bounds.size.width - 20, height: 80)
                    .aspectRatio(contentMode: .fill)
                    .clipped()
                    .onTapGesture {
                        bannerIndex = currentIndex
                        isActive.toggle()
                    }
                    
            }
            
            HStack(spacing: 8) {
                ForEach(0..<self.urls.count) { index in
                    BannerCircle(isSelected: Binding<Bool>(get: { self.currentIndex == index }, set: { _ in })) {
                        withAnimation {
                            self.currentIndex = index
                        }
                    }
                }
            }.offset(y: -10)
            
        }
        .clipShape(RoundedRectangle(cornerRadius: 8))
        .frame(height: 80)
        .padding(.horizontal, 10)
        .padding(.bottom, 10)
    }
}

//struct AdvertisingBoard_Previews: PreviewProvider {
//    static var previews: some View {
//        AdvertisingBoard()
//    }
//}
