//
//  LoginView.swift
//  WPGLife
//
//  Created by changming wang on 4/16/21.
//
import SwiftUI
import ActivityIndicatorView
import Alamofire
import SwiftyJSON
import KeyboardObserving

struct LoginView: View {
    
    @EnvironmentObject var appModel: AppModel
    @Environment(\.presentationMode) var presentationMode
    
    @State private var showLoadingIndicator: Bool = false
    
    @State private var username: String = ""
    @State private var userPassword: String = ""
    @State private var hiddenPassword: Bool = true
    
    @State private var userEmptyAlert:Bool = false
    @State private var pwdEmptyAlert:Bool = false
    @State private var userNotExistAlert: Bool = false
    @State private var loginFailedAlert: Bool = false
    @State private var timeoutAlert: Bool = false
    @State private var noInternetAlert: Bool = false
    
    @State private var loginFailStr:String = ""
    
    private var autohideDuration: Double = 1.0
    
    var body: some View{
        
        ZStack {
            VStack{
                HStack{
                    VStack(alignment: .leading, spacing: 12){
                        Text("登录账户")
                            .font(.title)
                            .fontWeight(.bold)
                    }
                    
                    Spacer(minLength: 0)
                }
                .padding(.horizontal, 25)
                .padding(.top, 10)
                
                VStack(alignment: .leading, spacing: 10){
                    Text("用户名")
                        .font(.caption)
                        .fontWeight(.bold)
                        .foregroundColor(.secondary)
                    
                    TextField(LocalizedStringKey("请输入用户名"), text:$username)
                        .autocapitalization(.none)
                        .disableAutocorrection(true)
                        .padding()
                        .background(Color.white)
                        .cornerRadius(5)
                        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 5)
                        .shadow(color: Color.black.opacity(0.08), radius: 5, x: 0, y: -5)
                        .onTapGesture {}
                    
                        
                    
                    Text("密码")
                        .font(.caption)
                        .fontWeight(.bold)
                        .foregroundColor(.secondary)
                    
                    ZStack(alignment: .trailing) {
                        HStack{
                            if self.hiddenPassword{
                                SecureField(LocalizedStringKey("请输入密码"), text: $userPassword)
                                    .padding()
                                    .background(Color.white)
                                    .cornerRadius(5)
                                    .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 5)
                                    .shadow(color: Color.black.opacity(0.08), radius: 5, x: 0, y: -5)
                                    .onTapGesture {}
                                    
                            }else{
                                TextField(LocalizedStringKey("请输入密码"), text: $userPassword)
                                    .autocapitalization(.none)
                                    .disableAutocorrection(true)
                                    .padding()
                                    .background(Color.white)
                                    .cornerRadius(5)
                                    .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 5)
                                    .shadow(color: Color.black.opacity(0.08), radius: 5, x: 0, y: -5)
                                    .onTapGesture {}
                                    
                            }
                            
                        }.frame(height: 50)
                        
                        Button(action:{
                            self.hiddenPassword.toggle()
                        }) {
                            Image(systemName: self.hiddenPassword ? "eye.slash.fill" : "eye.fill")
                                .foregroundColor(self.hiddenPassword ? Color.secondary: Color.green)
                        }
                        .frame(height: 50)
                        .offset(x: -10.0)
                    }
                    
//                    Button(action: {
//                        print("忘记密码路由加这里")
//                    }, label: {
//                        Text("忘记密码?")
//                            .font(.system(size: 14))
//                            .fontWeight(.bold)
//                            .foregroundColor(Color("Color"))
//                    })
//                    .padding(.top, 10)
                    
                    NavigationLink(destination: ForgetPasswordPage()) {
                        NavigationLink(destination: EmptyView()) {
                            EmptyView()
                        }
                        Text("忘记密码?")
                            .font(.system(size: 14))
                            .fontWeight(.bold)
                            .foregroundColor(Color("Color"))
                    }.padding(.top, 10)
                    
                }
                .padding(.horizontal, 25)
                .padding(.top, 10)
                
                Button(action: {
                    
                    UIApplication.shared.endEditing()
                    if self.username.isEmpty{
                        self.userEmptyAlert.toggle()
                    }
                    else if self.userPassword.isEmpty{
                        self.pwdEmptyAlert.toggle()
                    }else{
//                        self.login(username: username, password: userPassword)
                        self.login(username: username, password: userPassword)
                    }
                }, label: {
                    Text("登录")
                        .font(.system(size: 20))
                        .foregroundColor(.white)
                        .fontWeight(.bold)
                        .padding(.vertical)
                        .frame(width: UIScreen.main.bounds.width - 50)
                        .background(
                            LinearGradient(gradient: .init(colors: [Color("Color"), Color("Color1")]), startPoint: .topLeading, endPoint: .bottomTrailing)
                        )
                        .cornerRadius(8)
                })
                .padding(.horizontal, 25)
                .padding(.top, 10)
                
                Spacer()
            }
            
            if showLoadingIndicator{
                ZStack {
                    RoundedRectangle(cornerRadius: 5.0)
                        .frame(width: 200.0, height: 200.0)
                        .foregroundColor(Color.black.opacity(0.6))
                    VStack {
                        Text("正在登录").foregroundColor(.white)
                        ActivityIndicatorView(isVisible: $showLoadingIndicator, type: .growingArc())
                             .frame(width: 50.0, height: 50.0)
                            .foregroundColor(.red)
                    }
                }
            }
        }
        .navigationBarHidden(true)
        .keyboardObserving()
        .present(isPresented: self.$userEmptyAlert, type: .alert, animation: Animation.easeInOut, autohideDuration: autohideDuration, closeOnTap: false) {
            self.createAlertView(message: "用户名不能为空")
        }
        .present(isPresented: self.$pwdEmptyAlert, type: .alert, animation: Animation.easeInOut, autohideDuration: autohideDuration, closeOnTap:false) {
            self.createAlertView(message: "密码不能为空")
        }
        .present(isPresented: self.$userNotExistAlert, type: .alert, animation: Animation.easeInOut, autohideDuration: autohideDuration, closeOnTap: false) {
            self.createAlertView(message: "用户名不存在")
        }
        .present(isPresented: self.$loginFailedAlert, type: .alert, animation: Animation.easeInOut, autohideDuration: autohideDuration, closeOnTap: false) {
            self.createAlertView(message: "用户名或密码错误")
        }
        .present(isPresented: self.$timeoutAlert, type: .alert, animation: Animation.easeInOut, autohideDuration: autohideDuration, closeOnTap: false) {
            self.createAlertView(message: "服务器连接失败，请稍后重试")
        }
        .present(isPresented: self.$noInternetAlert, type: .alert, animation: Animation.easeInOut, autohideDuration: autohideDuration, closeOnTap: false) {
            self.createAlertView(message: "您似乎没有连接上互联网")
        }

    }
    
}

extension LoginView{
    
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
    
    
    func login(username:String, password:String){

        
        let postdata = ["data" : ["attributes" : ["username":username, "password": password]]]
        
        guard let encoded = try? JSONEncoder().encode(postdata) else {
            print("Failed to encode order")
            return
        }
        
//        let url = URL(string: "https://media.lifewpg.ca/api/login")
        let url = URL(string: "https://lifewpg.com/api/login")
        var request = URLRequest(url: url!)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        request.httpBody = encoded
        
        let sessionConfig = URLSessionConfiguration.default
        sessionConfig.timeoutIntervalForRequest = 10.0
        
        self.showLoadingIndicator.toggle()
        
        
        URLSession(configuration: sessionConfig).dataTask(with: request){
            data,response, error in
            
            guard let data = data else{
                self.handle(error: error)
                return
            }
            
            let httpResponse = response as! HTTPURLResponse
            if httpResponse.statusCode == 200{

                
                if let decodedUser = try?
                    JSONDecoder().decode(LoginJSON.self, from: data){
                    DispatchQueue.main.async {
                        
//                        let userModel = UserModel(id: decodedUser.data.id, username: decodedUser.included[0].attributes.username)
                        if let _ = UserManager.user{
                            UserManager.logout()
                        }
                        let id = decodedUser.data.id
                        let username = decodedUser.included[0].attributes.username
                        let avatarUrl = decodedUser.included[0].attributes.avatarURL
                        let tokenType = decodedUser.data.attributes.tokenType
                        let accessToken = decodedUser.data.attributes.accessToken
                        let refreshToken = decodedUser.data.attributes.refreshToken
                        let unreadNotifications = decodedUser.included[0].attributes.unreadNotifications
                        let canEditUsername = decodedUser.included[0].attributes.canEditUsername
                        let email = decodedUser.included[0].attributes.email
                        let expire = decodedUser.data.attributes.expiresIn
//                        let points = decodedUser.included[0].attributes.points
                        let date = Date()
                        let expireIn = date.addingTimeInterval(TimeInterval(Int(expire)))
//                        let userModel = UserModel(id: id, username: username, avatarUrl: avatarUrl, accessToken: accessToken, refreshToken: refreshToken, email: email, tokenType: tokenType, unreadNotifications: unreadNotifications, canEditUsername: canEditUsername, tokenExpireIn: expireIn, points: points)
                        
                        let userModel = UserModel(id: id, username: username, avatarUrl: avatarUrl, accessToken: accessToken, refreshToken: refreshToken, email: email, tokenType: tokenType, unreadNotifications: unreadNotifications, canEditUsername: canEditUsername, tokenExpireIn: expireIn)
                        
                        UserManager.user = userModel
                        UserManager.saveUser(user: userModel)
                        appModel.user = UserManager.user
                        self.showLoadingIndicator.toggle()
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                            self.presentationMode.wrappedValue.dismiss()
                        }
                    }
                }
            }else{
                self.showLoadingIndicator.toggle()
                self.loginFailedAlert.toggle()
            }
            
            
        }.resume()
    }
    
    func handle(error: Error?) {
        guard let error = error as NSError? else {
            return
        }
        switch error.code {
        case NSURLErrorTimedOut:
            print("Time out..")
            self.showLoadingIndicator.toggle()
            self.timeoutAlert.toggle()
        case NSURLErrorNotConnectedToInternet:
            print("Not connected")
            self.showLoadingIndicator.toggle()
            self.noInternetAlert.toggle()
        default:
            break
        }
        
    }
}


