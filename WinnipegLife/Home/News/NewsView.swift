//
//  NewsView.swift
//  WinnipegLife
//
//  Created by changming wang on 6/5/21.
//

import SwiftUI

struct NewsView: View {
    @Environment(\.presentationMode) var presentation
    
    @StateObject var news = News()
    @State var showCategoties:Bool = false
    
    
    var body: some View {
        NavigationView {
            ZStack(alignment: .top){
                VStack{
                    ZStack(alignment: .topTrailing){
                        VStack{
                            ZStack(alignment: .trailing){
                                ScrollTabbarView(titleIndex: $news.selection, titles: news.titleList, nameSpaceName: "NewsTabbar")
                                
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
                            
                            
                            TabView(selection: $news.selection){
                                ForEach(0..<news.titleList.count){ index in
                                    ScrollView{
                                        
                                        
                                        
                                        VStack{
                                            NewsListView(threads: $news.threads[news.selection],models: news.models[news.selection])
                                            RefreshFooter(refreshing: $news.isLoading, action: {
                                                news.requestData()
                                            }) {
                                                if news.noMoreData[news.selection] {
                                                    Text("没有更多数据了")
                                                        .foregroundColor(.secondary)
                                                        .padding()
                                                } else {
                                                    SimpleRefreshingView()
                                                        .padding()
                                                }
                                            }
                                            .noMore(news.noMoreData[news.selection])
                                            .preload(offset: 50)
                                        }
                                        
                                    }.enableRefresh()
                                        .tag(index)
                                }
                            }.tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                                .padding(.leading, 5)
                            
                        }
                        
                        
                        if showCategoties {
                            NewsCategoriesView(titleIndex: $news.selection, showCategoties: $showCategoties, titles: news.titleList)
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
                            
                            Text("新闻频道")
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
            //        .onAppear(perform: {
            //            UIScrollView.appearance().bounces = true
            //        })
            .navigationBarTitle("新闻频道")
            .navigationBarHidden(true)
        }
        .navigationBarTitle("新闻频道")
        .navigationBarHidden(true)
    }
    
}

struct NewsView_Previews: PreviewProvider {
    static var previews: some View {
        NewsView()
    }
}
