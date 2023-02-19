//
//  MerchantImages.swift
//  WinnipegLife
//
//  Created by changming wang on 6/24/21.
//

import SwiftUI
import SDWebImageSwiftUI

struct MerchantImages: View {
    
    let imageUrls: [String]
    
    @State var currentIndex: Int = 0
    
    var body: some View {
        ZStack(alignment:.bottom){
            TabView(selection: $currentIndex){
                ForEach(0..<imageUrls.count){ index in
//                    WebImage(url: URL(string: imageUrls[index]))
//                        .resizable()
//                        .aspectRatio(contentMode: .fill)
//                        .frame(width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height/4)
//                        .clipped()
//                        .tag(index)
                    
                    VStack{
                        WebImage(url: URL(string: imageUrls[index]))
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: UIScreen.main.bounds.size.width - 20, height: UIScreen.main.bounds.size.height/4)
                            .cornerRadius(10)
                            .clipped()

                    }
                    .frame(width: UIScreen.main.bounds.size.width - 20, height: UIScreen.main.bounds.size.height/4)
                    
                    
                }
            }.tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                .frame(width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height/4)
                .padding()
                .cornerRadius(10)
            
            
            HStack(spacing: 8) {
                ForEach(0..<imageUrls.count) { index in
                    BannerCircle(isSelected: Binding<Bool>(get: { self.currentIndex == index }, set: { _ in })) {
                        withAnimation {
                            self.currentIndex = index
                        }
                    }
                }
            }.offset(y: -10)
            
        }.frame(width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height/4)
        
    }
}

//struct MerchantImages_Previews: PreviewProvider {
//    static var previews: some View {
//        MerchantImages()
//    }
//}

struct NewMerchatImages: View {
    
    let imageUrls: [String]
    
    var body: some View{
        ZStack(alignment: .bottomTrailing){
            VStack{
                WebImage(url: URL(string: imageUrls[0]))
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: UIScreen.main.bounds.size.width - 20, height: UIScreen.main.bounds.size.height/4)
                    .cornerRadius(10)
                    .clipped()

            }
            .frame(width: UIScreen.main.bounds.size.width - 20, height: UIScreen.main.bounds.size.height/4)
            
//            ZStack{
//                Color.black.opacity(0.8).clipShape(RoundedRectangle(cornerRadius: 15))
//                    .padding()
//            }
            
            
//            ZStack{
//
//                Color.black.opacity(0.8).clipShape(RoundedRectangle(cornerRadius: 15))
//
//
//                HStack{
//                    Image(systemName: "photo")
//                        .resizable()
//                        .frame(width: 32, height: 18)
//                        .foregroundColor(.white)
//
//                    Text(String(imageUrls.count))
//                        .foregroundColor(.white)
//
//                }
//
//            }
            
        }
        
    }
}
