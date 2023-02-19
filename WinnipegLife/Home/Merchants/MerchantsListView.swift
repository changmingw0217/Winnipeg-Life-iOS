//
//  MerchantsListView.swift
//  WinnipegLife
//
//  Created by changming wang on 6/24/21.
//

import SwiftUI
import SDWebImageSwiftUI

struct MerchantsListView: View {
    @Binding var threads: [CommonThread]
    var models: [CommonViewModel]
    
    var body: some View {
            LazyVStack{
                
                ForEach(threads.indices, id: \.self){ index in
                    NavigationLink.init(
                        destination: MerchantDetailView(content: models[index], title: threads[index].title),
                        label: {
                            NavigationLink(destination: EmptyView()) {
                                EmptyView()
                            }
                            MerchantsBoxView(thread: threads[index])
                                .padding(.top, 5)
                        })
                    
//                    NavigationLink.init(
//                        destination: ShopView(),
//                        label: {
//                            NavigationLink(destination: EmptyView()) {
//                                EmptyView()
//                            }
//                            MerchantsBoxView(thread: threads[index])
//                                .padding(.top, 5)
//                        })
                    
                }
                
            }
        
    }
}

struct MerchantsBoxView: View {
    
    let thread: CommonThread
    let coloums = Array(repeating: GridItem(.fixed((UIScreen.main.bounds.size.width - 40) / 3)), count: 3)
    
    var body: some View {
        
        ZStack {
            
            RoundedRectangle(cornerRadius: 5)
                .frame(width: UIScreen.main.bounds.size.width - 20, height: 210)
                .foregroundColor(.white)
                .shadow(radius: 5)
            
            VStack{
                HStack(spacing: 0){
                    if thread.userAvatar.isEmpty{
                        Image("defaultusericon")
                            .resizable()
                            .frame(width: 30, height: 30)
                            .clipShape(Circle())
                    }else{
                        WebImage(url: URL(string: thread.userAvatar))
                            .resizable()
                            .frame(width: 30, height: 30)
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
                    .frame(width: UIScreen.main.bounds.size.width - 40, height: 50, alignment: .topLeading)
                    .padding(.horizontal, 5)
                    .padding(.top, 5)
                
                if thread.imageUrls.count > 0{
                    LazyVGrid(columns: coloums){
                        
                        ForEach(0..<(thread.imageUrls.count > 3 ? 3 : thread.imageUrls.count)){ index in
                            WebImage(url: URL(string: thread.imageUrls[index]))
                                .resizable()
                                .frame(width: (UIScreen.main.bounds.size.width - 40) / 3, height: 60)
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
            .frame(width: UIScreen.main.bounds.size.width - 20, height: 210)
            
        }.frame(width: UIScreen.main.bounds.size.width - 20, height: 210)
    }
}

//struct MerchantsListView_Previews: PreviewProvider {
//    static var previews: some View {
//        MerchantsListView()
//    }
//}
