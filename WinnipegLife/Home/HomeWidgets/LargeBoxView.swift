//
//  LargeBoxView.swift
//  WPGL
//
//  Created by changming wang on 6/2/21.
//

import SwiftUI
import SDWebImageSwiftUI

struct LargeBoxView: View {
    
    let thread: CommonThread
    let columns = Array(repeating: GridItem(.flexible()), count: 3)
    
    
    var body: some View {
        
        ZStack {
            
            RoundedRectangle(cornerRadius: 5)
                .frame(width: 280, height: 210)
                .foregroundColor(.white)
                .shadow(radius: 5)
            
            VStack{
                HStack(spacing: 0){
                    if thread.userAvatar.isEmpty{
                        Image("defaultusericon")
                            .resizable()
                            .frame(width: 25, height: 25)
                            .clipShape(Circle())
                    }else{
                        WebImage(url: URL(string: thread.userAvatar))
                            .resizable()
                            .frame(width: 25, height: 25)
                            .clipShape(Circle())
                    }

                    
                    Text(thread.userName)
                        .foregroundColor(.secondary)
                        .padding(.leading, 10)
                    Spacer()
                    
                    Text(thread.diffCreatedAt)
                        .foregroundColor(.secondary)
                }
                .frame(height:30)
                .padding(.horizontal, 5)
                .padding(.top, 5)
                
                Text(thread.title)
                    .font(.system(size: 20))
                    .fontWeight(.bold)
                    .foregroundColor(.black)
                    .frame(width: 260, height: 50, alignment: .topLeading)
                    .padding(.horizontal, 5)
                    .padding(.top, 5)
                
                if thread.imageUrls.count > 0{
                    LazyVGrid(columns: columns){
                        
                        ForEach(0..<(thread.imageUrls.count > 3 ? 3 : thread.imageUrls.count)){ index in
                            WebImage(url: URL(string: thread.imageUrls[index]))
                                .resizable()
                                .frame(width: 80, height: 60)
                                .aspectRatio(contentMode: .fill)
                            
                        }
                    }
                }else{
                    Spacer()
                }

                
                HStack(spacing: 0){
                    Text(LocalizedStringKey(thread.categoryId))
                        .foregroundColor(.secondary)
                        .padding(.leading, 5)
                    Spacer()
                    HStack(spacing: 0){
                        Image(systemName: "eye")
                            .resizable()
                            .frame(width:18,height: 11)
                            .foregroundColor(.secondary)
                            .padding(.horizontal, 5)
                        Text(thread.viewCount >= 999 ? "999+" : String(thread.viewCount))

                            .foregroundColor(.secondary)
                    }.padding(.trailing, 5)

                }.frame(height:30)
                .padding(.horizontal, 5)
                .padding(.bottom, 5)
            }.padding(.top, 5)
            .frame(width: 280, height: 210)
            
        }.frame(width: 280, height: 210)
    }

}

//struct LargeBoxView_Previews: PreviewProvider {
//    static var previews: some View {
//        LargeBoxView(viewCount: 999)
//    }
//}
