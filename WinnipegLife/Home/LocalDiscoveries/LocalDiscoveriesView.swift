//
//  LocalDiscoveries.swift
//  WinnipegLife
//
//  Created by changming wang on 6/15/21.
//

import SwiftUI

struct LocalDiscoveries: View {
    
    @Environment(\.presentationMode) var presentation
    @StateObject var discoveries = LocalDiscovery()
    
    
    var body: some View {
        NavigationView{
            ZStack(alignment: .top){
                VStack{
                    
                    ScrollView{
                        LazyVStack{
                            
                            ForEach(discoveries.threads.indices, id: \.self){ index in
                                let item = discoveries.threads[index]
                                let model = discoveries.models[index]
                                NavigationLink(destination: LocalDetailView(content: model, title: item.storeName)) {
                                    NavigationLink(destination: EmptyView()) {
                                        EmptyView()
                                    }
                                    DiscoveriesRowView(title: item.storeName, summary: item.storeDesc, createTime: item.createdAt, imageURL: item.storeCover)
                                    
                                }
                            }
                            
                        }.padding(.top, 5)
                        
                        RefreshFooter(refreshing: $discoveries.isLoading, action: {
                            discoveries.fetchData()
                        }) {
                            if discoveries.noMoreData {
                                Text("没有更多数据了")
                                    .foregroundColor(.secondary)
                                    .padding()
                                
                            } else {
                                SimpleRefreshingView()
                                    .padding()
                            }
                        }
                        .noMore(discoveries.noMoreData)
                        .preload(offset: 50)
                        
//                        if discoveries.threads.count > 0 {
//                            RefreshFooter(refreshing: $discoveries.isLoading, action: {
//                                discoveries.fetchData()
//                            }) {
//                                if discoveries.noMoreData {
//                                    Text("没有更多数据了")
//                                        .foregroundColor(.secondary)
//                                        .padding()
//
//                                } else {
//                                    SimpleRefreshingView()
//                                        .padding()
//                                }
//                            }
//                            .noMore(discoveries.noMoreData)
//                            .preload(offset: 50)
//                        }
                    }.enableRefresh()
                    
                }
                .padding(.top, 50)
                .overlay(
                    
                    Color("SystemColor")
                        .frame(height: UIApplication.shared.windows.first?.safeAreaInsets.top)
                        .ignoresSafeArea(.all, edges: .top)
                    ,alignment: .top
                )
                
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
                            
                            Text("本地探店")
                                .font(.system(size: 20.0))
                                .foregroundColor(.black)
                                .lineLimit(1)
                                .frame(minWidth: 0, maxWidth: 150)
                            
                            Spacer()
                            
                        }.frame(width: UIScreen.main.bounds.size.width, height: 50)
                        
                    }
                }.frame(width: UIScreen.main.bounds.size.width, height: 50)
                
            }
            //        .onAppear(perform: {
            //            UIScrollView.appearance().bounces = true
            //        })
            .navigationBarTitle("本地探店")
            .navigationBarHidden(true)
        }
        .navigationBarTitle("本地探店")
        .navigationBarHidden(true)
    }
}

struct LocalDiscoveries_Previews: PreviewProvider {
    static var previews: some View {
        LocalDiscoveries()
    }
}
