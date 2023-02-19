//
//  MerchatnDetailView.swift
//  WinnipegLife
//
//  Created by changming wang on 6/23/21.
//

import SwiftUI
import SDWebImageSwiftUI

struct MerchantDetailView: View {
    
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
                                
                                if content.viewContent.attachmentsImageUrls.count > 0 {
                                    MerchantImages(imageUrls: content.viewContent.attachmentsImageUrls)
//                                    NewMerchatImages(imageUrls: content.viewContent.attachmentsImageUrls)
                                }else{
                                    EmptyView()
                                }
                                
//                                VStack{
//
//                                    if content.viewContent.attachmentsImageUrls.count > 0 {
//    //                                    MerchantImages(imageUrls: content.viewContent.attachmentsImageUrls)
//                                        NewMerchatImages(imageUrls: content.viewContent.attachmentsImageUrls)
//                                    }else{
//                                        EmptyView()
//                                    }
//
//                                    HStack{
//                                        Text(content.viewContent.storeName)
//                                            .font(.title)
//                                            .padding(.horizontal, 10)
//
//                                        Spacer()
//                                    }
//
//                                    Divider().padding(.horizontal, 10)
//
//                                    HStack(){
//                                        VStack{
//                                            Image(systemName: "location")
//                                                .font(.system(size: 15))
//
//                                            Spacer()
//                                        }
//
//                                        VStack(){
//                                            Text(content.viewContent.storeAddress)
//                                                .foregroundColor(.primary)
//                                            Spacer()
//                                        }
//
//                                        Divider()
//
//                                        VStack{
//                                            Spacer()
//                                            Image(systemName: "phone.fill")
//                                                .resizable()
//                                                .frame(width: 22, height: 22)
//                                                .foregroundColor(.orange)
//                                                .onTapGesture{
//                                                    let tel = "tel://"
//                                                    let formattedString = tel + content.viewContent.storePhone
//                                                    guard let url = URL(string: formattedString) else { return }
//                                                    UIApplication.shared.open(url)
//                                                }
//
//                                            Spacer()
//                                        }
//
//
//                                    }.padding(.horizontal, 10)
//
//
//                                    Divider().padding(.horizontal, 10)
//                                }
//                                .padding(.horizontal, 10)
                                
                                
                                
                                VStack(spacing: 10){
//                                    Divider()
//                                    HStack{
//                                        Text("商家名称")
//                                            .padding(.leading, 10)
//                                            .foregroundColor(.secondary)
//                                            .font(.system(size: 22.0))
//
//                                        Text(content.viewContent.storeName)
//                                            .padding(.leading, 10)
//                                            .foregroundColor(.primary)
//                                            .font(.system(size: 22.0))
//
//                                        Spacer()
//                                    }
                                    
                                    HStack{
                                        Text(content.viewContent.storeName)
                                            .font(.title)
                                            .padding(.horizontal, 10)
                                        
                                        Spacer()
                                    }

                                    
                                    Divider().padding(.horizontal, 10)
                                    HStack{
                                        Text("联系电话")
                                            .padding(.leading, 10)
                                            .foregroundColor(.secondary)
                                            .font(.system(size: 22.0))

                                        Text(content.viewContent.formattedPhone)
                                            .padding(.leading, 10)
                                            .foregroundColor(.primary)
                                            .font(.system(size: 22.0))

                                        Spacer()

                                        Image(systemName: "phone.fill")
                                            .resizable()
                                            .frame(width: 22, height: 22)
                                            .foregroundColor(.blue)
                                            .padding(.trailing, 10)
                                    }.onTapGesture{
                                        let tel = "tel://"
                                        let formattedString = tel + content.viewContent.storePhone
                                        guard let url = URL(string: formattedString) else { return }
                                        UIApplication.shared.open(url)
                                    }
                                    Divider().padding(.horizontal, 10)
                                    HStack{
                                        Text("商家地区")
                                            .padding(.leading, 10)
                                            .foregroundColor(.secondary)
                                            .font(.system(size: 22.0))

                                        Text(content.viewContent.storeAddress)
                                            .padding(.leading, 10)
                                            .foregroundColor(.primary)
                                            .font(.system(size: 22.0))

                                        Spacer()
                                    }
                                    Divider()
                                }
                                .frame(minWidth: /*@START_MENU_TOKEN@*/0/*@END_MENU_TOKEN@*/,maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, minHeight: /*@START_MENU_TOKEN@*/0/*@END_MENU_TOKEN@*/, maxHeight: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                                .padding(10)
                                
                                if !content.viewContent.storeVideoId.isEmpty{
                                    HStack{
                                        Text("视频介绍")
                                            .font(.title)
                                        Spacer()
                                    }.padding()
                                    
                                    youtubeView(videoID: content.viewContent.storeVideoId).frame(width: UIScreen.main.bounds.size.width, height: 200)
                                }
                                
                                
                                
                                VStack(alignment: .leading){
                                    
                                    HStack{
                                        Text("详细介绍").font(.title)
                                        
                                        Spacer()
                                    }.padding(.bottom,10)
                                    .padding(.horizontal, 10)
                                    
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
                    }.padding(.top, 50)
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
            
            
        }.overlay(
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

//struct MerchantDetailView_Previews: PreviewProvider {
//
//    static var previews: some View {
//        MerchantDetailView(content: CommonViewModel(pid: "122"), title: "title")
//    }
//}
