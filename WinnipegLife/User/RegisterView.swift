
//
//  RegisterView.swift
//  WPGLife
//
//  Created by changming wang on 4/16/21.
//

import SwiftUI
import Combine
import ActivityIndicatorView
import KeyboardObserving

struct RegisterView: View{
    
    
    
    @EnvironmentObject var appModel: AppModel
    @Environment(\.presentationMode) var presentationMode
    
    
    @State var UserAgreemnetsActive: Bool = false
    
    @State private var showLoadingIndicator: Bool = false
    
    @State private var username: String = ""
    @State private var userPassword: String = ""
    @State private var userEmail:String = ""
    @State private var hiddenPassword: Bool = true
    @State var isChecked: Bool = false
    
    @State private var userEmptyAlert: Bool = false
    @State private var userExistAlert: Bool = false
    @State private var pwdEmptyAlert: Bool = false
    @State private var emailEmptyAlert:Bool = false
    @State private var emailExistAlert:Bool = false
    @State private var isEmailValidAlert:Bool = false
    @State private var userAndEmailExistAlert:Bool = false
    @State private var pwdIsNumericAlert: Bool = false
    @State private var pwdLenghtAlert: Bool = false
    @State private var checkboxAlert: Bool = false
    @State private var timeoutAlert: Bool = false
    @State private var noInternetAlert: Bool = false
    @State private var registerClosedAlert: Bool = false
    
    var autohideDuration: Double = 1.0
    
    var body: some View{
        ZStack{
            VStack{
                HStack{
                    VStack(alignment: .leading, spacing: 12){
                        Text("注册账户")
                            .font(.title)
                            .fontWeight(.bold)
                    }
                    
                    Spacer(minLength: 0)
                }
                .padding(.horizontal, 25)
                .padding(.top, 10)
                
                VStack(alignment: .leading, spacing: 10){
                    Text("用户名(可包含中文，英文及数字)")
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
                        
                    
                    Text("密码(需包含字母与数字)")
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
                    
                    Text("邮箱")
                        .font(.caption)
                        .fontWeight(.bold)
                        .foregroundColor(.secondary)
                    
                    TextField(LocalizedStringKey("请输入邮箱"), text:$userEmail)
                        .autocapitalization(.none)
                        .disableAutocorrection(true)
                        .padding()
                        .background(Color.white)
                        .cornerRadius(5)
                        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 5)
                        .shadow(color: Color.black.opacity(0.08), radius: 5, x: 0, y: -5)
                        .onTapGesture {}
                    
                    HStack{
                        Button(action: {
                            self.isChecked.toggle()
                        }, label: {
                            
                            Image(systemName: isChecked ? "checkmark.square": "square")
                                .font(.system(size: 14.0))
                            
                        })
                        
                        Text("我已同意").font(.system(size: 14.0))
                        
                        NavigationLink(destination: UserAgreements()){
                            Text("《用户协议》")
                                .font(.system(size: 14.0))
                                .foregroundColor(.green)
                        }
                        NavigationLink(destination: PrivacyAgreementsView()){
                            Text("《隐私政策》")
                                .font(.system(size: 14.0))
                                .foregroundColor(.green)
                        }

                    }
                    .padding(.top, 10)

                    
                }
                .padding(.horizontal, 25)
                .padding(.top, 10)
                
                Button(action: {
                    UIApplication.shared.endEditing()
                    if self.username.isEmpty{
                        self.userEmptyAlert.toggle()
                    }else if self.userPassword.isEmpty{
                        self.pwdEmptyAlert.toggle()
                    }else if self.userEmail.isEmpty{
                        self.emailEmptyAlert.toggle()
                    }else if !self.userEmail.isValidEmail{
                        self.isEmailValidAlert.toggle()
                    }else if !self.isChecked{
                        self.checkboxAlert.toggle()
                    }else if self.userPassword.isNumeric{
                        self.pwdIsNumericAlert.toggle()
                    }else if self.userPassword.count < 6{
                        self.pwdLenghtAlert.toggle()
                    }else{
                        register(username: self.username, password: self.userPassword, email: self.userEmail)
                    }
                }, label: {
                    Text("注册")
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
                        Text("正在注册").foregroundColor(.white)
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
        .present(isPresented: self.$emailEmptyAlert, type: .alert, animation: Animation.easeInOut, autohideDuration: autohideDuration, closeOnTap: false) {
            self.createAlertView(message: "邮箱不能为空")
        }
        .present(isPresented: self.$isEmailValidAlert, type: .alert, animation: Animation.easeInOut, autohideDuration: autohideDuration, closeOnTap: false) {
            self.createAlertView(message: "邮箱格式不正确")
        }
        .present(isPresented: self.$emailExistAlert, type: .alert, animation: Animation.easeInOut, autohideDuration: autohideDuration, closeOnTap: false) {
            self.createAlertView(message: "邮箱已经被注册了")
        }
        .present(isPresented: self.$userAndEmailExistAlert, type: .alert, animation: Animation.easeInOut, autohideDuration: autohideDuration, closeOnTap: false) {
            self.createAlertView(message: "用户名与邮箱已存在")
        }
        .present(isPresented: self.$checkboxAlert, type: .alert, animation: Animation.easeInOut, autohideDuration: autohideDuration, closeOnTap:false) {
            self.createAlertView(message: "注册前需同意《用户使用协议》")
        }
        .present(isPresented: self.$pwdIsNumericAlert, type: .alert, animation: Animation.easeInOut, autohideDuration: autohideDuration, closeOnTap:false) {
            self.createAlertView(message: "密码需包含字母跟数字")
        }
        .present(isPresented: self.$pwdLenghtAlert, type: .alert, animation: Animation.easeInOut, autohideDuration: autohideDuration, closeOnTap:false) {
            self.createAlertView(message: "密码长度不能小于6位")
        }
        .present(isPresented: self.$userExistAlert, type: .alert, animation: Animation.easeInOut, autohideDuration: autohideDuration, closeOnTap: false) {
            self.createAlertView(message: "用户名已存在")
        }
        .present(isPresented: self.$timeoutAlert, type: .alert, animation: Animation.easeInOut, autohideDuration: autohideDuration, closeOnTap: false) {
            self.createAlertView(message: "服务器连接失败，请稍后重试")
        }
        .present(isPresented: self.$noInternetAlert, type: .alert, animation: Animation.easeInOut, autohideDuration: autohideDuration, closeOnTap: false) {
            self.createAlertView(message: "您似乎没有连接上互联网")
        }
        .present(isPresented: self.$registerClosedAlert, type: .alert, animation: Animation.easeInOut, autohideDuration: autohideDuration, closeOnTap: false) {
            self.createAlertView(message: "注册通道关闭，请等待官方通知")
        }

    }
    
    
    
    
}

extension RegisterView{
    
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
    
    private func register(username:String, password:String, email:String){
        
        let postdata = ["data" : ["attributes" : ["username":username, "password": password, "email": email]]]
        
        guard let encoded = try? JSONEncoder().encode(postdata) else {
            print("Failed to encode order")
            return
        }

        let url = URL(string: "https://lifewpg.com/api/register")
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
            
            if httpResponse.statusCode == 201{
                self.login(username: username, password: password)
                self.showLoadingIndicator.toggle()
                
            }else if httpResponse.statusCode == 422{
                if let decodedError = try?
                    JSONDecoder().decode(RegisterError.self, from: data){
                    DispatchQueue.main.async{
                        print(decodedError.errors.count)
                        if decodedError.errors.count == 1{
                            let error = decodedError.errors[0].detail[0]
                            if error.contains("用户名"){
                                self.showLoadingIndicator.toggle()
                                self.userExistAlert.toggle()
                            }else{
                                self.showLoadingIndicator.toggle()
                                self.emailExistAlert.toggle()
                            }
                        }else{
                            self.showLoadingIndicator.toggle()
                            self.userAndEmailExistAlert.toggle()
                        }
                    }
                }

            }else if httpResponse.statusCode == 401{
                self.showLoadingIndicator.toggle()
                self.registerClosedAlert.toggle()
            }
        }.resume()
    }
    
    
    private func login(username:String, password:String){

        
        let postdata = ["data" : ["attributes" : ["username":username, "password": password]]]
        
        guard let encoded = try? JSONEncoder().encode(postdata) else {
            print("Failed to encode order")
            return
        }
        
        let url = URL(string: "https://lifewpg.com/api/login")
        var request = URLRequest(url: url!)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        request.httpBody = encoded
        
        let sessionConfig = URLSessionConfiguration.default
        sessionConfig.timeoutIntervalForRequest = 10.0
        
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
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                            self.presentationMode.wrappedValue.dismiss()
                        }
                    }
                }
            }
            
            
        }.resume()
    }
    
    private func handle(error: Error?) {
        guard let error = error as NSError? else {
            return
        }
        switch error.code {
        case NSURLErrorTimedOut:
            self.showLoadingIndicator.toggle()
            self.timeoutAlert.toggle()
        case NSURLErrorNotConnectedToInternet:
            self.showLoadingIndicator.toggle()
            self.noInternetAlert.toggle()
        default:
            break
        }
        
    }
    
}


struct RegisterError: Codable {
    let errors: [RegisterErrors]
}

// MARK: - Error
struct RegisterErrors: Codable {
    let status, code: String
    let detail: [String]
    let source: Source
}

// MARK: - Source
struct Source: Codable {
    let pointer: String
}


