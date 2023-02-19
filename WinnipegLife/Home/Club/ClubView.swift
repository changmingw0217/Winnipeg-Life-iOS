//
//  ClubView.swift
//  WinnipegLife
//
//  Created by changming wang on 8/28/21.
//

import SwiftUI

struct ClubView: View {
    
    @Environment(\.presentationMode) var presentation
    @StateObject var club: Club
    @State var showCategoties:Bool = false
    
    var body: some View {
        
        NavigationView{
            ZStack(alignment: .top){
                
                VStack{
                    ZStack(alignment: .topTrailing){
                        VStack{
                            ZStack(alignment: .trailing){
                                ScrollTabbarView(titleIndex: $club.selection, titles: club.titleList, nameSpaceName: "clubTabbar")
                                
                                Button(action: {
                                    showCategoties.toggle()
                                }){
                                    Image(systemName: "text.justify")
                                        .resizable()
                                        .frame(width: 20, height: 20)
                                        .padding(.horizontal, 8)
                                        .foregroundColor(.secondary)
                                }.background(
                                    Color.white.frame(width: 40, height: 40)
                                        .shadow(color: Color.black.opacity(0.08), radius: 5, x: -5, y: 0)
                                )
                                    .frame(height: 40)
                            }.frame(height: 40)
                            
                            
                            TabView(selection: $club.selection){
                                ForEach(0..<club.titleList.count){ index in
                                    ScrollView{
                                        
                                        VStack{
                                            CommunityListView(threads: $club.threads[club.selection], models: club.models[club.selection])
                                            
                                            RefreshFooter(refreshing: $club.isLoading, action: {
                                                club.fetchData()
                                            }) {
                                                if club.noMoreData[club.selection] {
                                                    Text("没有更多数据了")
                                                        .foregroundColor(.secondary)
                                                        .padding()
                                                    
                                                } else {
                                                    SimpleRefreshingView()
                                                        .padding()
                                                }
                                            }
                                            .noMore(club.noMoreData[club.selection])
                                            .preload(offset: 50)
                                            
                                        }
                                        
                                    }
                                    .enableRefresh()
                                    .tag(index)
                                    
                                }
                            }.tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                                .padding(.leading, 2)
                        }
                        
                        
                        if showCategoties {
                            NewsCategoriesView(titleIndex: $club.selection, showCategoties: $showCategoties, titles: club.titleList)
                                .padding(.trailing, 15)
                                .padding(.top, 55)
                        }
                        
                    }.padding(.top, 55)
                }
                
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
                            
                            Text("小温部落")
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
                
                Color("SystemColor")
                    .frame(height: UIApplication.shared.windows.first?.safeAreaInsets.top)
                    .ignoresSafeArea(.all, edges: .top)
                ,alignment: .top
            )
            .navigationBarTitle("小温部落")
            .navigationBarHidden(true)
        }
        .navigationBarTitle("小温部落")
        .navigationBarHidden(true)
        
    }
}

//struct ClubView_Previews: PreviewProvider {
//    static var previews: some View {
//        ClubView()
//    }
//}
