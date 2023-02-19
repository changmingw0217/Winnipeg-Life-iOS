//
//  LocalGalleyView.swift
//  WinnipegLife
//
//  Created by changming wang on 6/17/21.
//

import SwiftUI
import SDWebImageSwiftUI

struct LocalGalleryView: View {
    @Environment(\.presentationMode) var presentation
    
    let imageLinks: [String]
    let coloums = Array(repeating: GridItem(.fixed((UIScreen.main.bounds.size.width / 2) - 20)), count: 2)
        
    @StateObject var viewer = ImageViewer()
            
    
    var body: some View {
        ZStack(alignment: .top){
            ScrollView{
                
                LazyVGrid(columns: coloums){
                    
                    
                    ForEach(0..<imageLinks.count){ index in
                        Button(action: {
                            withAnimation(.easeInOut){
                                viewer.showImageViewer.toggle()
                                viewer.imageIndex = index
                                UIScrollView.appearance().bounces = false
                            }
                            
                        }, label: {
                            WebImage(url: URL(string: imageLinks[index]))
                                .resizable()
                                .frame(width:(UIScreen.main.bounds.size.width / 2) - 20, height: (UIScreen.main.bounds.size.width / 2) - 20)
                                .aspectRatio(contentMode: .fill)
                                .padding(.horizontal, 10)
                        })
                    }
                    
                }.padding()
            }
            .padding(.top, 50)
            .overlay(
                
                Color("SystemColor")
                    .frame(height: UIApplication.shared.windows.first?.safeAreaInsets.top)
                    .ignoresSafeArea(.all, edges: .top)
                ,alignment: .top
            )
            
            ZStack{
                
                Color("SystemColor").frame(width: UIScreen.main.bounds.size.width, height: 50)
                
                VStack(spacing: 0){
                    HStack{
                        Button(action: { presentation.wrappedValue.dismiss() }) {
                            Image(systemName: "chevron.left")
                                .imageScale(.large)
                                .foregroundColor(.orange)
                        }.padding(.leading, 10)
                        
                        Spacer()
                        
                        Text("探店图片")
                            .font(.system(size: 20.0))
                            .foregroundColor(.black)
                            .lineLimit(1)
                            .frame(minWidth: 0, maxWidth: 150)
                        
                        Spacer()
                        
                    }.frame(width: UIScreen.main.bounds.size.width, height: 50)
                    
                }
            }.frame(width: UIScreen.main.bounds.size.width, height: 50)
            
            
        }
        .overlay(
            ImageView(urls: imageLinks)
        )
//        .onAppear(perform: {
//            UIScrollView.appearance().bounces = false
//        })
//        .onDisappear(perform: {
//            UIScrollView.appearance().bounces = true
//        })
        .environmentObject(viewer)
        .navigationBarTitle("")
        .navigationBarHidden(true)

    }
}

//struct LocalGalleryView_Previews: PreviewProvider {
//    static var previews: some View {
//        LocalGalleryView()
//    }
//}
