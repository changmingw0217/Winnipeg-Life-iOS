//
//  FoodPage.swift
//  WinnipegLife
//
//  Created by changming wang on 6/5/21.
//

import SwiftUI

struct FoodPage: View {
    
    @StateObject var foodContent: Food
    @State var showCategoties:Bool = false
    
    var body: some View {
        
        ZStack(alignment: .top) {
            ZStack(){
                
                VStack{
                    ZStack(alignment: .trailing){
                        ScrollTabbarView(titleIndex: $foodContent.selection, titles: foodContent.titleList, nameSpaceName: "FoodTabbar")
                        
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
                    
                    
                    TabView(selection: $foodContent.selection){
                        ForEach(foodContent.titleList.indices, id: \.self){ index in
                            ScrollView{
                                VStack{
                                    FoodListView(threads: $foodContent.threads[foodContent.selection],models: foodContent.models[foodContent.selection])
                                    
                                    RefreshFooter(refreshing: $foodContent.isLoading, action: {
                                        foodContent.fetchData()
                                    }) {
                                        if foodContent.noMoreData[foodContent.selection] {
                                            Text("没有更多数据了")
                                                .foregroundColor(.secondary)
                                                .padding()
                                        } else {
                                            SimpleRefreshingView()
                                                .padding()
                                        }
                                    }
                                    .noMore(foodContent.noMoreData[foodContent.selection])
                                    .preload(offset: 50)
                                }
                                
                            }.enableRefresh()
                                .tag(index)
                            
                        }
                    }.tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                        .padding(.leading, 2)
                }.padding(.top, 50)
                
                
                if showCategoties {
                    NewsCategoriesView(titleIndex: $foodContent.selection, showCategoties: $showCategoties, titles: foodContent.titleList)
                        .padding(.trailing, 15)
                        .padding(.top, 55)
                }
                
            }
            
            ZStack{
                
                Color("SystemColor").frame(width: UIScreen.main.bounds.size.width, height: 50 + UIApplication.shared.windows[0].safeAreaInsets.top)
                    .ignoresSafeArea(.all, edges: .top)
                
                VStack(spacing: 0){
                    HStack{
                        
                        Spacer()
                        
                        Text("Restaurants")
                            .font(.system(size: 20.0))
                            .foregroundColor(.black)
                            .lineLimit(1)
                            .frame(minWidth: 0, maxWidth: 150)
                        
                        Spacer()
                        
                    }.frame(width: UIScreen.main.bounds.size.width, height: 50)
                    
                }
            }.frame(width: UIScreen.main.bounds.size.width, height: 50)
        }
        .navigationTitle("Restaurants")
        .navigationBarHidden(true)
    }
}

//struct FoodPage_Previews: PreviewProvider {
//    static var previews: some View {
//        FoodPage()
//    }
//}
