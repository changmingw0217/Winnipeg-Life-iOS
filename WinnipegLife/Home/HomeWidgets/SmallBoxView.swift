//
//  SmallBoxViewWidget.swift
//  WPGL
//
//  Created by changming wang on 5/31/21.
//

import SwiftUI
import SDWebImageSwiftUI

struct SmallBoxView: View {
    
    let thread: CommonThread
    
    var body: some View {
        
        ZStack {
            
            RoundedRectangle(cornerRadius: 5)
                .frame(width: 140, height: 201.25)
                .foregroundColor(.white)
                .shadow(radius: 5)
            
            VStack(spacing: 0){
                WebImage(url: URL(string: thread.storeCover))
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 140, height: 87.5)
                    .cornerRadius(radius: 5, corners: [.topLeft, .topRight])
                
                
                VStack(alignment:.leading){
                    Text(thread.summary)
                        .font(.system(size: 18))
                        .foregroundColor(.black)
                        .padding(.horizontal, 10)
                        .lineLimit(3)
                        .padding(.top, 5)
                    
                        Spacer()
                }
                .frame(minWidth: 0,
                        maxWidth: 140,
                        minHeight: 0,
                        maxHeight: 93.3,
                        alignment: .topLeading)
                
                
                HStack{
                    Text(LocalizedStringKey(thread.categoryId))
                        .font(.footnote)
                        .foregroundColor(.secondary)
                        .padding(.horizontal, 5)
                    
                    Spacer()
                    
                    HStack(spacing: 2) {
                        Image(systemName: "eye")
                            .resizable()
                            .frame(width:18,height: 11)
                            .foregroundColor(.secondary)
                        Text(thread.viewCount >= 999 ? "999+" : String(thread.viewCount))
                            .font(.footnote)
                            .foregroundColor(.secondary)
                    }.padding(.trailing, 5)
                    
                }.padding(.bottom, 10)
                
                
            }.frame(width: 140, height: 201.25)
        }
    }
}

//struct SmallBoxView_Previews: PreviewProvider {
//    static var previews: some View {
//        SmallBoxView(summary: "文章的简介", imageURL: "https://images.unsplash.com/photo-1468276311594-df7cb65d8df6?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=1650&q=80", newsCategory: "国际新闻", viewCount: 1).previewLayout(.sizeThatFits)
//    }
//}
