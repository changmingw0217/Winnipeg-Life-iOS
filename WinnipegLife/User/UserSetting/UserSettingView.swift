//
//  UserSettingView.swift
//  WinnipegLife
//
//  Created by changming wang on 6/7/21.
//

import SwiftUI
import SDWebImageSwiftUI
struct UserSettingView: View {
    
    
    
    @EnvironmentObject var appModel: AppModel
    @EnvironmentObject var messageContent: Message
    
    @Environment(\.presentationMode) var presentation
    
    @State private var showingOptions = false
    
    @State private var canNotEditUsernameAlert = false
    
    private var autohideDuration: Double = 1.0
    
    var body: some View {
        NavigationView{
            ZStack(alignment: .top){
                VStack{
                    if let user = appModel.user{
                        ScrollView(showsIndicators: false){
                            VStack{
                                
                                NavigationLink(destination: UserAvatarView()){
                                    HStack{
                                        Text("头像")
                                            .font(.title3)
                                            .foregroundColor(.primary)
                                        
                                        Spacer()
                                        
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
                                        
                                        Image(systemName: "chevron.right")
                                            .foregroundColor(Color(.secondaryLabel))
                                    }.padding(.horizontal, 5)
                                }
                                
                                
                                Divider().frame(maxWidth: getRecct().width - 30)
                                
                                VStack{
                                    if user.canEditUsername{
                                        NavigationLink(destination: UsernameChangeView()){
                                            HStack{
                                                Text("用户名")
                                                    .font(.title3)
                                                    .foregroundColor(.primary)
                                                
                                                Spacer()
                                                
                                                Text(user.username)
                                                    .font(.title3)
                                                    .foregroundColor(.primary)
                                                    .padding(.trailing, 5)
                                                
                                                Image(systemName: "chevron.right")
                                                    .foregroundColor(Color(.secondaryLabel))
                                            }
                                        }
                                        
                                    }else{
                                        Button {
                                            self.canNotEditUsernameAlert.toggle()
                                        } label: {
                                            HStack{
                                                Text("用户名")
                                                    .font(.title3)
                                                    .foregroundColor(.primary)
                                                
                                                Spacer()
                                                
                                                Text(user.username)
                                                    .font(.title3)
                                                    .foregroundColor(.primary)
                                                    .padding(.trailing, 5)
                                                
                                                Image(systemName: "chevron.right")
                                                    .foregroundColor(Color(.secondaryLabel))
                                            }
                                        }
                                        
                                    }
                                    
                                }.padding(.horizontal, 5)
                                    .padding([.top, .bottom], 10)
                                
                                Divider().frame(maxWidth: getRecct().width - 30)
                                
                                NavigationLink(destination: UserPWDChangeView()){
                                    HStack{
                                        Text("密码")
                                            .font(.title3)
                                            .foregroundColor(.primary)
                                        
                                        Spacer()
                                        
                                        Text("修改")
                                            .font(.title3)
                                            .foregroundColor(.orange)
                                            .padding(.trailing, 5)
                                        
                                        Image(systemName: "chevron.right")
                                            .foregroundColor(Color(.secondaryLabel))
                                    }
                                }.padding(.horizontal, 5)
                                    .padding([.top, .bottom], 10)
                                
                                Divider().frame(maxWidth: getRecct().width - 30)
                                
                                HStack{
                                    Text("邮箱")
                                        .font(.title3)
                                        .foregroundColor(.primary)
                                    
                                    Spacer()
                                    
                                    Text(user.email)
                                        .font(.title3)
                                        .foregroundColor(.primary)
                                        .padding(.trailing, 5)
                                    
                                    Image(systemName: "chevron.right")
                                        .foregroundColor(Color(.secondaryLabel))
                                }.padding(.horizontal, 5)
                                    .padding([.top, .bottom], 10)
                                
                                
                                Button.init(action: {
                                    
                                    showingOptions.toggle()
                                    
                                }, label: {
                                    HStack{
                                        Text("退出登录")
                                            .font(.system(size: 20))
                                            .foregroundColor(.white)
                                            .fontWeight(.bold)
                                            .padding()
                                            .frame(width: UIScreen.main.bounds.width - 50)
                                            .background(
                                                LinearGradient(gradient: .init(colors: [Color("Color"), Color("Color1")]), startPoint: .topLeading, endPoint: .bottomTrailing)
                                            )
                                            .cornerRadius(8)
                                    }
                                    .frame(height: 50)
                                    .padding(.top, 50)
                                    
                                }).actionSheet(isPresented: $showingOptions) {
                                    ActionSheet(
                                        title: Text("确定要退出登录吗？"),
                                        buttons: [
                                            .destructive(Text("退出登录")) {
                                                appModel.user = nil
                                                //coreData
                                                //                    User.clearData()
                                                
                                                //userdefaults
                                                UserManager.logout()
                                                
                                                messageContent.cleanData()
                                                
                                                self.presentation.wrappedValue.dismiss()
                                            },
                                            .cancel(Text("取消"))
                                        ]
                                    )
                                }
                                .padding(.top, 150)
                                .padding(.horizontal, 10)
                                
                            }
                        }
                    }else{
                        EmptyView()
                    }
                }.padding(.top, 55)
                
                
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
                            
                            Text("个人信息")
                                .font(.system(size: 20.0))
                                .foregroundColor(.black)
                                .lineLimit(1)
                                .frame(minWidth: 0, maxWidth: 150)
                            
                            Spacer()
                            
                        }.frame(width: UIScreen.main.bounds.size.width, height: 50)
                        
                    }
                }.frame(width: UIScreen.main.bounds.size.width, height: 50)
                
            }
            .present(isPresented: self.$canNotEditUsernameAlert, type: .alert, animation: Animation.easeInOut, autohideDuration: autohideDuration, closeOnTap: false) {
                self.createAlertView(message: "修改用户名的次数已经到上限了")
            }
            .navigationBarTitle("个人信息")
            .navigationBarHidden(true)
        }
        .navigationBarTitle("个人信息")
        .navigationBarHidden(true)
        
    }
}


extension UserSettingView{
    
    func createAlertView(message:String = "") -> some View {
        
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

struct UserSettingView_Previews: PreviewProvider {
    static var previews: some View {
        UserSettingView()
    }
}
