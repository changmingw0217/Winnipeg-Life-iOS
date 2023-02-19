//
//  ContentView.swift
//  WPGL
//
//  Created by changming wang on 5/17/21.
//

import SwiftUI
import SSToastMessage
import Alamofire
import SwiftyJSON

struct ContentView: View {
    
    init() {
        UITabBar.appearance().tintColor = .orange
    }
    
    @AppStorage("appLanguage") var appLanguage: String = Locale.current.languageCode ?? "zh"
    
    @State private var tabSelection:Int = 0
    @StateObject var homeContent = Home()
    @StateObject var foodContent = Food()
    @StateObject var messageContent = Message()

    
    @EnvironmentObject var appModel: AppModel
    
    let messageTimer1 = Timer.publish(every: 20, on: .main, in: .common).autoconnect()
    let messageTimer2 = Timer.publish(every: 5, on: .main, in: .common).autoconnect()
    
    var body: some View {
        ZStack{
            if homeContent.loaded && foodContent.inited{
                NavigationView {
                    
                    TabView(selection: $tabSelection) {
                        HomePage(homeContent: homeContent, tabSelection: $tabSelection).tabItem {
                            VStack {
                                Image(systemName: "house.fill")
                                    .resizable()
                                    .frame(width: 25, height: 25)
                                   
                                Text("Home")
                                    .font(.system(size: 12.0))
                            }.padding()
                            
                        }.tag(0)
                        FoodPage(foodContent: foodContent).tabItem {
                            VStack {
                                Image(systemName: "cart.fill")
                                    .resizable()
                                    .frame(width: 25, height: 25)
                                Text("Restaurants")
                                    .font(.system(size: 12.0))
                            }.padding()
                            
                        }.tag(1)
                        MessagePage(tabSelection: $tabSelection).tabItem {
                            VStack {
                                Image(systemName: "bolt.horizontal.circle.fill")
                                    .resizable()
                                    .frame(width: 25, height: 25)
                                Text("Messages")
                                    .font(.system(size: 12.0))
                            }.padding()
                            
                        }.tag(2)
                        UserPage().tabItem {
                            VStack {
                                Image(systemName: "person.fill")
                                    .resizable()
                                    .frame(width: 25, height: 25)
                                Text("Me")
                                    .font(.system(size: 12.0))
                            }.padding()
                            
                        }.tag(3)
                        
                    }
                    .accentColor(.orange)
                    .navigationViewStyle(StackNavigationViewStyle())
                }
                .onReceive(messageTimer1) { _ in
                    if tabSelection != 2{
                        if let _ = appModel.user{
                            
                            if !messageContent.loadingMessage{
                                messageContent.fetchMessage()
    //                            user.chats = messageContent.chats
    //                            UserManager.user = user
    //                            UserManager.saveUser(user: user)
    //                            appModel.user = user
                            }

                        }
                    }

                }
                .onReceive(messageTimer2) { _ in

                    if tabSelection == 2 {
                        
                        if let _ = appModel.user{
                            if !messageContent.loadingMessage{
                                messageContent.fetchMessage()
    //                            user.chats = messageContent.chats
    //                            UserManager.user = user
    //                            UserManager.saveUser(user: user)
    //                            appModel.user = user
                            }

                        }
                    }

                }
                .environmentObject(messageContent)
            }else{
                VStack{
                    Spacer()
                    Text("Loading..")
                    Spacer()
                }
            }
        }

    }
    
}

private extension ContentView {
    var navigationBarTitle: LocalizedStringKey {
        if tabSelection == 0{
            return "Home"
        }else if tabSelection == 1{
            return "Restaurants"
        }
        else if tabSelection == 2{
            return "Messages"
        }else{
            return "Me"
        }
        
    }
    
    var navigationBarHidden: Bool {
        if tabSelection == 0{
            return true
        }else if tabSelection == 1{
            return true
        }else if tabSelection == 2{
            return true
        }else{
            return true
        }
    }
    
    @ViewBuilder
    var navigationBarLeadingItems: some View {
        EmptyView()
    }
    
    @ViewBuilder
    var navigationBarTrailingItems: some View {
        EmptyView()
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}


struct CornerRadiusStyle: ViewModifier {
    var radius: CGFloat
    var corners: UIRectCorner
    
    struct CornerRadiusShape: Shape {
        
        var radius = CGFloat.infinity
        var corners = UIRectCorner.allCorners
        
        func path(in rect: CGRect) -> Path {
            let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
            return Path(path.cgPath)
        }
    }
    
    func body(content: Content) -> some View {
        content
            .clipShape(CornerRadiusShape(radius: radius, corners: corners))
    }
}


