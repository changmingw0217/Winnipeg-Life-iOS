//
//  BannerDetailView.swift
//  WinnipegLife
//
//  Created by changming wang on 6/8/21.
//

import SwiftUI
import SDWebImageSwiftUI

struct BannerDetailView: View {
    
    @Environment(\.presentationMode) var presentation
    
    @StateObject var content: CommonViewModel
    
    var body: some View {
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
                                            .padding(.horizontal, 10)
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                    }else if key == "img" {
                                        let url = data["img"]!
                                        
                                        WebImage(url: URL(string: url))
                                            .resizable()
                                            .frame(width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height/4)
                                            .aspectRatio(contentMode: .fit)
                                    }
                                }
                            }
                            .frame(width: UIScreen.main.bounds.size.width)
                            .padding(.horizontal, 10)

                        }
                    }
                }

            }
        }
        .onAppear(perform: {
            content.requestData()
        })
        .edgesIgnoringSafeArea(.bottom)
        .navigationTitle(content.viewContent.viewTitle)
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .toolbar(content: {
            ToolbarItem(placement: .navigationBarLeading){
                Button(action: { presentation.wrappedValue.dismiss() }) {
                 Image(systemName: "chevron.left")
                    .foregroundColor(.orange)
                   .imageScale(.large) }
            }
        })
    }
}

//struct BannerDetailView_Previews: PreviewProvider {
//    static var previews: some View {
//        BannerDetailView()
//    }
//}
