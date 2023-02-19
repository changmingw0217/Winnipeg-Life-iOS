//
//  NewsDetailView.swift
//  WinnipegLife
//
//  Created by changming wang on 6/6/21.
//

import SwiftUI
import SDWebImageSwiftUI

struct NewsDetailView: View {
    
    @Environment(\.presentationMode) var presentation
    @StateObject var content: CommonViewModel
    
    @StateObject var viewer = ImageViewer()
    
    let title:String
    
    var body: some View {
        ZStack(alignment: .top){
            VStack{
                if content.isLoading{
                    SimpleRefreshingView()
                        .padding()
                }else{
                    VStack{
                        ScrollView{
                            VStack{
                                Text(content.viewContent.viewTitle)
                                    .font(.largeTitle)
                                    .fontWeight(.bold)
                                    .padding(.top, 10)
                                    .padding(.horizontal, 10)
                                
                                if !content.viewContent.storeVideoId.isEmpty{
                                    
                                    youtubeView(videoID: content.viewContent.storeVideoId).frame(width: UIScreen.main.bounds.size.width, height: 200)
                                }
                                
                                VStack(alignment: .leading){
                                    ForEach(0..<content.viewContent.htmlContent.count){ index in
                                        let data = content.viewContent.htmlContent[index]
                                        let key = Array(data.keys)[0]
                                        
                                        if key == "p" {
                                            Text(data["p"]!)
                                                .fixedSize(horizontal: false, vertical: true)
                                                .frame(maxWidth: .infinity, alignment: .leading)
                                                .padding(.horizontal, 10)
                                        }else if key == "img" {
                                            let url = data["img"]!
                                            
                                            WebImage(url: URL(string: url))
                                                .resizable()
                                                .indicator(Indicator.progress)
                                                .aspectRatio(contentMode: .fill)
                                                .padding(10)
                                                .onTapGesture(){
                                                    withAnimation(.easeInOut) {
                                                        UIScrollView.appearance().bounces = false
                                                        viewer.showImageViewer.toggle()
                                                        viewer.imageIndex = content.contentImageIndex[index]
                                                    }

                                                }
                                            
                                        }
                                    }
                                }
                                .frame(width: UIScreen.main.bounds.size.width)
                                .padding(.horizontal, 10)
                                .padding(.top, 20)
                                
                            }
                        }
                    }.padding(.top, 55)
                }
            }
            
            ZStack{
                
                Color("SystemColor").frame(width: UIScreen.main.bounds.size.width, height: 50 + UIApplication.shared.windows[0].safeAreaInsets.top)
                    .ignoresSafeArea(.all, edges: .top)
                
                VStack(spacing: 0){
                    HStack{
                        Button(action: { presentation.wrappedValue.dismiss() }) {
                            Image(systemName: "chevron.left")
                                .imageScale(.large)
                                .foregroundColor(.orange)
                        }.padding(.leading, 10)
                        
                        Spacer()
                        
                        Text(title)
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
            ImageView(urls: content.viewContent.contentImageUrls)
        )
        .environmentObject(viewer)
        .onAppear(perform: {
            content.requestData()
//            UIScrollView.appearance().bounces = false
        })
        .navigationBarTitle(title)
        .navigationBarHidden(true)
        
    }
}

//struct NewsDetailView_Previews: PreviewProvider {
//    static var previews: some View {
//        NewsDetailView()
//    }
//}
