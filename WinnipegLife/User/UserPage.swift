//
//  UserPage.swift
//  WPGL
//
//  Created by changming wang on 5/17/21.
//

import SwiftUI
import SDWebImageSwiftUI

struct UserPage: View {
    
    @EnvironmentObject var appModel: AppModel
    
    @State private var loginExpire:Bool = false
    
    var body: some View {
            ZStack(alignment: .top) {
                ScrollView(){
                    
                    if let user = appModel.user {
                        
                        let date = Date()
                        
                        if user.tokenExpireIn < date{
                            NavigationLink(destination:LoginAndRegister()){
                                HStack(){
                                    Image("defaultusericon")
                                        .resizable()
                                        .frame(width: 75, height: 75)
                                        .clipShape(Circle())
                                        .padding()
                                    
                                    Text("登录/注册")
                                        .foregroundColor(.black)
                                        .font(.system(size: 24.0))
                                    Spacer()
                                    Image(systemName: "chevron.right")
                                        .foregroundColor(Color(.secondaryLabel))
                                    
                                }
                            }
                            .padding(.horizontal, 5)
                            .padding(.top, 20)
                            .frame(height: 100)
                        }else{
                            NavigationLink(destination: UserSettingView()){
                                HStack(){
                                    if user.avatarUrl.isEmpty{
                                        Image("defaultusericon")
                                            .resizable()
                                            .frame(width: 50, height: 50)
                                            .clipShape(/*@START_MENU_TOKEN@*/Circle()/*@END_MENU_TOKEN@*/)
                                            .padding()
                                    }else{
                                        WebImage(url: URL(string: user.avatarUrl))
                                            .resizable()
                                            .frame(width: 50, height: 50)
                                            .clipShape(Circle())
                                            .padding()
                                    }
                                    
                                    
                                    Text(user.username)
                                        .foregroundColor(.black)
                                        .font(.system(size: 24.0))
                                    Spacer()
                                    Image(systemName: "chevron.right")
                                        .foregroundColor(Color(.secondaryLabel))
                                    
                                }
                            }
                            .padding(.horizontal, 5)
                            .padding(.top, 20)
                            .frame(height: 100)
                        }
                        
                        
                    }else {
                        NavigationLink(destination:LoginAndRegister()){
                            HStack(){
                                Image("defaultusericon")
                                    .resizable()
                                    .frame(width: 75, height: 75)
                                    .clipShape(Circle())
                                    .padding()
                                
                                Text("登录/注册")
                                    .foregroundColor(.black)
                                    .font(.system(size: 24.0))
                                Spacer()
                                Image(systemName: "chevron.right")
                                    .foregroundColor(Color(.secondaryLabel))
                                
                            }
                        }
                        .padding(.horizontal, 5)
                        .padding(.top, 20)
                        .frame(height: 100)
                    }
//                    if let user = appModel.user{
//                        Divider().scaleEffect(CGSize(width: 1.0, height: 20.0))
//
//                        NavigationLink(destination: OrdersView(content: RestaOrders(userId: user.id))) {
//                            HStack(){
//                                Image(systemName: "square.3.stack.3d")
//                                    .foregroundColor(Color(.secondaryLabel))
//                                Text("我的订单")
//                                Spacer()
//                                Image(systemName: "chevron.right")
//                                    .foregroundColor(Color(.secondaryLabel))
//                            }.padding(.horizontal, 5)
//                                .foregroundColor(.black)
//                                .frame(height: 50)
//                        }
//                    }
                    
                    if let _ = appModel.user{
                        Divider().scaleEffect(CGSize(width: 1.0, height: 20.0))
                        
                        NavigationLink(destination: RewardsView(content: RewardsModel())) {
                            HStack(){
                                Image(systemName: "star.circle")
                                    .foregroundColor(Color(.secondaryLabel))
                                Text("我的积分")
                                Spacer()
                                Image(systemName: "chevron.right")
                                    .foregroundColor(Color(.secondaryLabel))
                            }.padding(.horizontal, 5)
                                .foregroundColor(.black)
                                .frame(height: 50)
                        }
                    }
                    
                    
                    Divider().scaleEffect(CGSize(width: 1.0, height: 20.0))
                    
                    NavigationLink(destination: AppSettingView()) {
                        HStack(){
                            Image(systemName: "gearshape")
                                .foregroundColor(Color(.secondaryLabel))
                            Text("软件设置")
                            Spacer()
                            Image(systemName: "chevron.right")
                                .foregroundColor(Color(.secondaryLabel))
                        }.padding(.horizontal, 5)
                            .foregroundColor(.black)
                            .frame(height: 50)
                    }
                    
                    Divider().scaleEffect(CGSize(width: 1.0, height: 20.0))
                    
//                    NavigationLink(destination: /*@START_MENU_TOKEN@*/Text("Destination")/*@END_MENU_TOKEN@*/) {
//                        HStack(){
//                            Image(systemName: "questionmark.circle")
//                                .foregroundColor(Color(.secondaryLabel))
//                            Text("帮助/反馈")
//                            Spacer()
//                            Image(systemName: "chevron.right")
//                                .foregroundColor(Color(.secondaryLabel))
//                        }.padding(.horizontal, 5)
//                            .foregroundColor(.black)
//                            .frame(height: 50)
//                    }
                    
                    NavigationLink(destination: AboutPage()) {
                        HStack(){
                            Image(systemName: "exclamationmark.circle")
                                .foregroundColor(Color(.secondaryLabel))
                            Text("关于/联系")
                            Spacer()
                            Image(systemName: "chevron.right")
                                .foregroundColor(Color(.secondaryLabel))
                        }.padding(.horizontal, 5)
                            .foregroundColor(.black)
                            .frame(height: 50)
                    }
                    
                    
                    
                }
                .present(isPresented: self.$loginExpire, type: .alert, animation: Animation.easeInOut, autohideDuration: 1.5, closeOnTap: false) {
                    self.createAlertView(message: "登录过期，请重新登录")
                }
                .frame(minWidth: /*@START_MENU_TOKEN@*/0/*@END_MENU_TOKEN@*/,maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, minHeight: /*@START_MENU_TOKEN@*/0/*@END_MENU_TOKEN@*/, maxHeight: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                .padding(.top, 50)
                
                
                ZStack{
                    
                    Color("SystemColor").frame(width: UIScreen.main.bounds.size.width, height: 50 + UIApplication.shared.windows[0].safeAreaInsets.top)
                        .ignoresSafeArea(.all, edges: .top)
                    
                    VStack(spacing: 0){
                        HStack{
                            
                            Spacer()
                            
                            Text("Me")
                                .font(.system(size: 20.0))
                                .foregroundColor(.black)
                                .lineLimit(1)
                                .frame(minWidth: 0, maxWidth: 150)
                            
                            Spacer()
                            
                        }.frame(width: UIScreen.main.bounds.size.width, height: 50)
                        
                    }
                }.frame(width: UIScreen.main.bounds.size.width, height: 50)
            }
            .navigationTitle("Me")
            .navigationBarHidden(true)
    }
}

extension UserPage{
    
    private func createAlertView(message:String = "") -> some View {
        
        
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

struct UserPage_Previews: PreviewProvider {
    static var previews: some View {
        UserPage()
    }
}

