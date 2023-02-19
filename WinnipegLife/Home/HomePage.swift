//
//  testview.swift
//  WPGL
//
//  Created by changming wang on 6/4/21.
//

import SwiftUI
import ActivityIndicatorView
import WaterfallGrid

struct HomePage: View {
    
    @StateObject var homeContent: Home
    
    @EnvironmentObject var appModel: AppModel
    
    @State private var scrollOffset: CGFloat = .zero
    
    @Binding var tabSelection:Int
    
    @State var headerRefreshing:Bool = false
    
    @State var noLoginAlert:Bool = false
    
    @State var postActive:Bool = false
    
    let coloums = Array(repeating: GridItem(.fixed((UIScreen.main.bounds.size.width/2) - 10)), count: 2)
    
    var body: some View {
        
        ZStack(alignment: .top){
            ScrollViewOffset { offset in
                //                print("New ScrollView offset: \(offset)")
                DispatchQueue.main.async {
                    scrollOffset = offset
                }
                
            } content: {
                
//                RefreshHeader(refreshing: $homeContent.refreshing, action: {
//                    homeContent.refreshHomePage()
//                    }) { progress in
//                        if homeContent.refreshing {
//                            SimpleRefreshingView()
//                                .padding()
//                                .edgesIgnoringSafeArea(.top)
//                        } else {
//                            Text("Pull to refresh")
//                                .padding()
//                                .edgesIgnoringSafeArea(.top)
//                        }
//                    }
                
                VStack{
                    
                    BannerPageView(banner: homeContent.banner, models: homeContent.bannerModels)
                        .frame(width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height/4.5)
                        .padding(.bottom, 10)
                    
                    HomeGridBottons(tabSelection: $tabSelection)
                    
                    
                    HomeSectionTitle(title: "Winnipeg News", subTitle: "More News", destination: AnyView(NewsView()))
                    ScrollView(.horizontal, showsIndicators: false) {
                        LazyHStack(){
                            ForEach(0..<homeContent.newsThreads.count, id:\.self){ index in
                                let thread = homeContent.newsThreads[index]
                                let model = homeContent.newsModels[index]
                                NavigationLink(destination:NewsDetailView(content: model, title: thread.title)){
                                    SmallBoxView(thread: thread)
                                }
                                
                            }
                        }.padding(.horizontal, 10)
                        
                    }
                    .frame(height: 220)
                    
                    HomeSectionTitle(title: "Merchants", subTitle: "More MerChants", destination: AnyView(MerchantView(merchants: Merchants(selection: 0))))
                    ScrollView(.horizontal, showsIndicators: false){
                        LazyHStack(){
                            ForEach(0..<homeContent.merchantsThreads.count, id:\.self){ index in
                                let thread = homeContent.merchantsThreads[index]
                                let model = homeContent.merchantsModels[index]
                                NavigationLink(destination: MerchantDetailView(content: model, title: thread.title)){
                                    LargeBoxView(thread: thread)
                                }
                            }
                        }.padding(.horizontal, 10)
                    }
                    .frame(height: 220)
                    
//                    AdvertisingBoard(urls: homeContent.banner.imageUrls)
                    
                    HomeSectionTitle(title: "Community", subTitle: "Go Coummnity", destination: AnyView(CommunityView(community: Community(selection: 0)))).padding(.bottom, 10)
                    
                    CommunityListView(threads: $homeContent.communityThreads, models: homeContent.communityModels)
                    
                    RefreshFooter(refreshing: $homeContent.isLoading, action: {
                        homeContent.fetchCommunity()
                    }) {
                        if homeContent.noMoreData {
                            Text("没有更多数据了")
                                .foregroundColor(.secondary)
                                .padding()
                            
                        } else {
                            SimpleRefreshingView()
                                .padding()
                        }
                    }
                    .noMore(homeContent.noMoreData)
                    .preload(offset: 50)
                    
//                    if homeContent.communityThreads.count > 0 {
//                        RefreshFooter(refreshing: $homeContent.isLoading, action: {
//                            homeContent.fetchCommunity()
//                        }) {
//                            if homeContent.noMoreData {
//                                Text("没有更多数据了")
//                                    .foregroundColor(.secondary)
//                                    .padding()
//
//                            } else {
//                                SimpleRefreshingView()
//                                    .padding()
//                            }
//                        }
//                        .noMore(homeContent.noMoreData)
//                        .preload(offset: 50)
//                    }
                                        
                }
                
            }
            .edgesIgnoringSafeArea(.top)
            .overlay(
                
                Color.white
                    .frame(height: UIApplication.shared.windows.first?.safeAreaInsets.top)
                    .ignoresSafeArea(.all, edges: .top)
                    .opacity(opacity)
                ,alignment: .top
            )
            
            ZStack{
                
                Color.white.frame(width: UIScreen.main.bounds.size.width, height: 50)
                    .opacity(opacity)
                
                VStack(spacing: 0){
                    HStack{
                        Spacer()
                        NavigationLink(destination:SearchView()){
                            HStack(){
                                Image(systemName: "magnifyingglass")
                                Text("Search")
                                Spacer()
                                
                            }
                            .padding(.horizontal, 15)
                            .frame(maxWidth: 200)
                            .frame(height: 33)
                            .background(-scrollOffset > 100 ? Color.gray.opacity(0.1) : Color.white)
                            .foregroundColor(Color.gray.opacity(0.9))
                            .clipShape(Capsule())
                        }
                        
                        Spacer()
                        NavigationLink.init(destination:PostThreadView(), isActive: $postActive){
                            Button(action: {
                                
                                guard let _ = appModel.user else {
                                    noLoginAlert = true
                                    return
                                }
                                
                                
                                withAnimation(.easeIn) {
                                    postActive = true
                                }
                            }) {
                                Image(systemName: "plus.circle.fill")
                                    .foregroundColor(-scrollOffset > 100 ? .orange : .white)
                                    .padding(.trailing, 15)
                            }
                        }
                        

                        
//                        NavigationLink(destination:PostThreadView(), isActive: $postActive){
//                            Image(systemName: "plus.circle.fill")
//                                .foregroundColor(-scrollOffset > 100 ? .orange : .white)
//                        }.padding(.trailing, 15)
                    }.frame(width: UIScreen.main.bounds.size.width, height: 50)
                    .offset(y: scrollOffset > 0 ? scrollOffset : 0)
                }
            }.frame(width: UIScreen.main.bounds.size.width, height: 50)
        }
        .navigationBarTitle("")
        .navigationBarHidden(true)
        .present(isPresented: self.$noLoginAlert, type: .alert, animation: Animation.easeInOut, autohideDuration: 1.5, closeOnTap: false) {
            self.createAlertView(message: "请先登录后再发帖")
        }
    }
    
    var opacity: Double {
        switch scrollOffset {
        case -105...0:
            return Double(-scrollOffset) / 105.0
        case ...(-105):
            return 1
        default:
            return 0
        }
    }
    
}


struct ScrollViewOffset<Content: View>: View {
    let onOffsetChange: (CGFloat) -> Void
    let content: () -> Content
    
    init(
        onOffsetChange: @escaping (CGFloat) -> Void,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.onOffsetChange = onOffsetChange
        self.content = content
    }
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            offsetReader
            content()
                .padding(.top, -8)
        }.enableRefresh()
        .coordinateSpace(name: "frameLayer")
        .onPreferenceChange(OffsetPreferenceKey.self, perform: onOffsetChange)
    }
    
    var offsetReader: some View {
        GeometryReader { proxy in
            Color.clear
                .preference(
                    key: OffsetPreferenceKey.self,
                    value: proxy.frame(in: .named("frameLayer")).minY
                )
        }
        .frame(height: 0)
    }
}

private struct OffsetPreferenceKey: PreferenceKey {
    static var defaultValue: CGFloat = .zero
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {}
}


extension HomePage{
    func createAlertView(message:LocalizedStringKey = "") -> some View {
        
        
        VStack() {
            
            Spacer()
            
            Text(message)
                .foregroundColor(.white)
                .font(.system(size: 15))
                .fontWeight(.bold)
            
            Spacer()
            
        }
        .padding()
        .frame(width: 250, height: 50)
        .background(Color(.secondaryLabel))
        .cornerRadius(10.0)
        .shadow(color: Color(.sRGBLinear, white: 0, opacity: 0.13), radius: 10.0)
        
    }
}
