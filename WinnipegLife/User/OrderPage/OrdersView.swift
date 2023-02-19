//
//  OrdersView.swift
//  WinnipegLife
//
//  Created by changming wang on 9/20/21.
//

import SwiftUI

struct OrdersView: View {
    
    @Environment(\.presentationMode) var presentation
    
    @StateObject var content:RestaOrders
    
    var body: some View {
        NavigationView{
            ZStack(alignment: .top){
                VStack{
                    ScrollView{
                        LazyVStack{
                            ForEach(content.orders.indices, id: \.self){ index in
                                
                                OrdersRowView(order: content.orders[index])
                                
                            }
                            
                            if content.orders.count > 0 {
                                RefreshFooter(refreshing: $content.isLoadingMore, action: {
                                    content.fetchMore()
                                }) {
                                    if content.noMore {
                                        Text("没有更多数据了")
                                            .foregroundColor(.secondary)
                                            .padding()
                                        
                                    } else {
                                        SimpleRefreshingView()
                                            .padding()
                                    }
                                }
                                .noMore(content.noMore)
                                .preload(offset: 50)
                            }
                        }.padding(.top, 5)
                    }.enableRefresh()
                }.padding(.top, 50)
                
                ZStack{
                    
                    Color("SystemColor").frame(width: UIScreen.main.bounds.size.width, height: 50 + UIApplication.shared.windows[0].safeAreaInsets.top)
                        .ignoresSafeArea(.all, edges: .top)
                    
                    VStack(spacing: 0){
                        HStack{
                            Button(action: { presentation.wrappedValue.dismiss() }) {
                                Image(systemName: "chevron.left")
                                    .imageScale(.large)
                                    .foregroundColor(.orange)
                            }.padding(.leading, 10)
                            
                            Spacer()
                            
                            Text("我的订单")
                                .font(.system(size: 20.0))
                                .foregroundColor(.black)
                                .lineLimit(1)
                                .frame(minWidth: 0, maxWidth: 150)
                            
                            Spacer()
                            
                            
                        }.frame(width: UIScreen.main.bounds.size.width, height: 50)
                        
                    }
                }.frame(width: UIScreen.main.bounds.size.width, height: 50)
            }
            .navigationBarTitle("我的订单")
            .navigationBarHidden(true)
            .onAppear {
                content.fetchData()
            }
        }
        .navigationBarTitle("我的订单")
        .navigationBarHidden(true)
    }
}

//struct OrdersView_Previews: PreviewProvider {
//    static var previews: some View {
//        OrdersView()
//    }
//}
