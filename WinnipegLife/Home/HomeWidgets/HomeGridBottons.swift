//
//  HomeGridBottons.swift
//  WPGL
//
//  Created by changming wang on 6/1/21.
//

import SwiftUI
import SDWebImageSwiftUI

//struct HomeGridBottons: View {
//
//    @Binding var tabSelection:Int
//
//    let imageURL:String =  "https://images.unsplash.com/photo-1504674900247-0877df9cc836?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=1650&q=80"
//
//    let columns = Array(repeating: GridItem(.flexible()), count: 4)
//
//    var body: some View {
//        VStack{
//            HStack(){
//                NavigationLink(destination: CommunityView(community: Community(selection: 1))){
//                    VStack {
//                        Image("House")
//                            .resizable()
//                            .frame(width: 30, height: 30)
//
//                        Text("Rent")
//                            .font(.system(size: 12.0))
//                            .foregroundColor(.primary)
//
//                    }
//                }
//                Spacer()
//                NavigationLink(destination: CommunityView(community: Community(selection: 2))){
//                    VStack {
//                        Image("Change")
//                            .resizable()
//                            .frame(width: 30, height: 30)
//
//                        Text("UsedGoods")
//                            .font(.system(size: 12.0))
//                            .foregroundColor(.primary)
//                    }
//                }
//                Spacer()
//                NavigationLink(destination: MerchantView(merchants: Merchants(selection: 4))){
//                    VStack {
//                        Image("Bag")
//                            .resizable()
//                            .frame(width: 30, height: 30)
//
//                        Text("Employment")
//                            .font(.system(size: 12.0))
//                            .foregroundColor(.primary)
//                    }
//                }
//                Spacer()
//                NavigationLink(destination: MerchantView(merchants: Merchants(selection: 1))){
//                    VStack {
//                        Image("Car")
//                            .resizable()
//                            .frame(width: 30, height: 30)
//
//                        Text("Cars")
//                            .font(.system(size: 12.0))
//                            .foregroundColor(.primary)
//                    }
//                }
//            }
//            .padding(.horizontal, 10)
//            .padding(.bottom, 5)
//
//            HStack{
//                NavigationLink(destination: MerchantView(merchants: Merchants(selection: 5))){
//                    VStack {
//                        Image("Group")
//                            .resizable()
//                            .frame(width: 30, height: 30)
//
//                        Text("Immigration")
//                            .font(.system(size: 12.0))
//                            .foregroundColor(.primary)
//                    }
//                }
//                Spacer()
//                NavigationLink(destination: NewsView()){
//                    VStack {
//                        Image("Map")
//                            .resizable()
//                            .frame(width: 30, height: 30)
//
//                        Text("Winnipeg News")
//                            .font(.system(size: 12.0))
//                            .foregroundColor(.primary)
//                    }
//                }
//                Spacer()
//                NavigationLink(destination: LocalDiscoveries()){
//                    VStack {
//                        Image("Find")
//                            .resizable()
//                            .frame(width: 30, height: 30)
//
//                        Text("Local Discoveris")
//                            .font(.system(size: 12.0))
//                            .foregroundColor(.primary)
//                    }
//                }
//                Spacer()
//                NavigationLink(destination: ClubView(club: Club(selection: 0))){
//                    VStack {
//                        Image(systemName: "house.fill")
//                            .resizable()
//                            .frame(width: 30, height: 30)
//
//                        Text("Clubs")
//                            .font(.system(size: 12.0))
//                            .foregroundColor(.primary)
//                    }
//                }
//            }
//            .padding(.horizontal, 10)
//            .padding(.bottom, 5)
//
//            Button(action: {
//                tabSelection = 1
//            }, label: {
//                WebImage(url: URL(string: imageURL))
//                    .resizable()
//                    .aspectRatio(contentMode: .fill)
//                    .frame(height: 80)
//                    .clipShape(RoundedRectangle(cornerRadius: 5))
//                    .padding(.horizontal, 10)
//            })
//
//        }
//        .padding(.bottom, 10)
//
//
//
//    }
//}
struct HomeGridBottons: View {
    
    @Binding var tabSelection:Int
    
    let imageURL:String =  "https://images.unsplash.com/photo-1504674900247-0877df9cc836?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=1650&q=80"
    
    let columns = Array(repeating: GridItem(.flexible()), count: 4)
    
    var body: some View {
        
        VStack{
            
            LazyVGrid(columns: columns){
                NavigationLink(destination: CommunityView(community: Community(selection: 2))){
                    VStack {
                        Image("House")
                            .resizable()
                            .frame(width: 30, height: 30)
                        
                        Text("Rent")
                            .font(.system(size: 12.0))
                            .foregroundColor(.primary)
                            
                    }
                }

                NavigationLink(destination: CommunityView(community: Community(selection: 3))){
                    VStack {
                        Image("Change")
                            .resizable()
                            .frame(width: 30, height: 30)
                        
                        Text("UsedGoods")
                            .font(.system(size: 12.0))
                            .foregroundColor(.primary)
                    }
                }

                NavigationLink(destination: MerchantView(merchants: Merchants(selection: 4))){
                    VStack {
                        Image("Bag")
                            .resizable()
                            .frame(width: 30, height: 30)
                        
                        Text("Employment")
                            .font(.system(size: 12.0))
                            .foregroundColor(.primary)
                    }
                }

                NavigationLink(destination: MerchantView(merchants: Merchants(selection: 1))){
                    VStack {
                        Image("Car")
                            .resizable()
                            .frame(width: 30, height: 30)
                        
                        Text("Cars")
                            .font(.system(size: 12.0))
                            .foregroundColor(.primary)
                    }
                }
                
                NavigationLink(destination: MerchantView(merchants: Merchants(selection: 5))){
                    VStack {
                        Image("Group")
                            .resizable()
                            .frame(width: 30, height: 30)
                        
                        Text("Immigration")
                            .font(.system(size: 12.0))
                            .foregroundColor(.primary)
                    }
                }

                NavigationLink(destination: NewsView()){
                    VStack {
                        Image("Map")
                            .resizable()
                            .frame(width: 30, height: 30)
                        
                        Text("Winnipeg News")
                            .font(.system(size: 12.0))
                            .foregroundColor(.primary)
                    }
                }

                NavigationLink(destination: LocalDiscoveries()){
                    VStack {
                        Image("Find")
                            .resizable()
                            .frame(width: 30, height: 30)
                        
                        Text("Discoveries")
                            .font(.system(size: 12.0))
                            .foregroundColor(.primary)
                    }
                }

                NavigationLink(destination: ClubView(club: Club(selection: 0))){
                    VStack {
                        Image("Club")
                            .resizable()
                            .frame(width: 30, height: 30)
                        
                        Text("Clubs")
                            .font(.system(size: 12.0))
                            .foregroundColor(.primary)
                    }
                }
            }
                        
            
            Button(action: {
                tabSelection = 1
            }, label: {
                WebImage(url: URL(string: imageURL))
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(height: 80)
                    .clipShape(RoundedRectangle(cornerRadius: 5))
                    .padding(.horizontal, 10)
            })
            
        }
        .padding(.bottom, 10)
        
    }
}
//struct HomeGridBottons_Previews: PreviewProvider {
//    static var previews: some View {
//        HomeGridBottons()
//    }
//}
