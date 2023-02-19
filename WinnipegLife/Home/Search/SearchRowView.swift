//
//  SearchRowView.swift
//  WinnipegLife
//
//  Created by changming wang on 8/18/21.
//

import SwiftUI
import SDWebImageSwiftUI

struct SearchRowView: View {
    
    let thread: SearchThread
    
    var body: some View {
        VStack(){
            HStack(){
                
                VStack{
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
                    Spacer()
                }
                .padding(.trailing, 8)
                
                VStack(alignment:.leading){
                    
                    HStack{
                        Text(thread.userName)
                            .foregroundColor(.primary)
                        
                        Spacer()
                        
                        Text(thread.createdAt)
                            .foregroundColor(.secondary)
                    }.padding(.bottom, 6)
                    
                    
                    HStack{
                        Text(thread.title)
                            .foregroundColor(.primary)
                            .lineLimit(1)
                    }
                    
                    
                    HStack{
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
                        
                        HStack(spacing: 2) {
                            Image(systemName: "bubble.middle.bottom")
                                .resizable()
                                .frame(width:18,height: 11)
                                .foregroundColor(.secondary)
                            Text(thread.postCount >= 999 ? "999+" : String(thread.postCount))
                                .font(.footnote)
                                .foregroundColor(.secondary)
                        }.padding(.trailing, 5)
                    }
                }
                
            }
            .padding(.horizontal, 5)
            
            Divider()
        }

    }
}

//struct SearchRowView_Previews: PreviewProvider {
//    static var previews: some View {
//        SearchRowView()
//    }
//}
