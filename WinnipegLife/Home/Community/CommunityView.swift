//
//  CommunityView.swift
//  WinnipegLife
//
//  Created by changming wang on 6/27/21.
//

import SwiftUI

struct CommunityView: View {
    
    @Environment(\.presentationMode) var presentation
    @StateObject var community:Community
    @State var showCategoties:Bool = false
    
    
    var body: some View {
        NavigationView{
            ZStack(alignment: .top){
                
                VStack{
                    ZStack(alignment: .topTrailing){
                        VStack{
                            ZStack(alignment: .trailing){
                                ScrollTabbarView(titleIndex: $community.selection, titles: community.titleList, nameSpaceName: "communityTabbar")
                                
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
                            
                            
                            TabView(selection: $community.selection){
                                ForEach(0..<community.titleList.count){ index in
                                    ScrollView{
                                        
                                        VStack{
                                            CommunityListView(threads: $community.threads[community.selection], models: community.models[community.selection])
                                            
                                            RefreshFooter(refreshing: $community.isLoading, action: {
                                                community.fetchData()
                                            }) {
                                                if community.noMoreData[community.selection] {
                                                    Text("没有更多数据了")
                                                        .foregroundColor(.secondary)
                                                        .padding()
                                                    
                                                } else {
                                                    SimpleRefreshingView()
                                                        .padding()
                                                }
                                            }
                                            .noMore(community.noMoreData[community.selection])
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
                            NewsCategoriesView(titleIndex: $community.selection, showCategoties: $showCategoties, titles: community.titleList)
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
                            
                            Text("小温社区")
                                .font(.system(size: 20.0))
                                .foregroundColor(.black)
                                .lineLimit(1)
                                .frame(minWidth: 0, maxWidth: 150)
                            
                            Spacer()
                            
                        }.frame(width: UIScreen.main.bounds.size.width, height: 50)
                        
                    }
                }.frame(width: UIScreen.main.bounds.size.width, height: 50)
                
            }.overlay(
                
                Color("SystemColor")
                    .frame(height: UIApplication.shared.windows.first?.safeAreaInsets.top)
                    .ignoresSafeArea(.all, edges: .top)
                ,alignment: .top
            )
            //        .onAppear(perform: {
            //            UIScrollView.appearance().bounces = true
            //        })
                .navigationBarTitle("小温社区")
                .navigationBarHidden(true)
        }
        .navigationBarTitle("小温社区")
        .navigationBarHidden(true)
    }
}

//struct CommunityView_Previews: PreviewProvider {
//    static var previews: some View {
//        CommunityView()
//    }
//}
