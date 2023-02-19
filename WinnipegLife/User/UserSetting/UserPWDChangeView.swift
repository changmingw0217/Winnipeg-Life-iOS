//
//  UserPWDChangeView.swift
//  WinnipegLife
//
//  Created by changming wang on 7/7/21.
//

import Foundation
import SwiftUI
import SwiftUIX
import Alamofire
import SwiftyJSON
import ActivityIndicatorView

struct UserPWDChangeView: View {
    
    let baseUrl = BaseUrl().url
    
    @EnvironmentObject var appModel: AppModel
    @Environment(\.presentationMode) var presentation
    
    @State private var pwd:String = ""
    
    @State private var newPwd:String = ""
    
    @State private var reNewPwd:String = ""
    
    @State private var showLoadingIndicator: Bool = false
    
    @State private var showingAlert:Bool = false
    
    @State private var gotToken:Bool = false
    
    // 原密码不匹配
    @State private var originalPwdAlert = false
    // 原密码与新密码相同
    @State private var samePwdAlert = false
    // 两次输入密码不相同
    @State private var reNewPwdAlert = false
    // 密码纯数字
    @State private var pwdIsNumericAlert: Bool = false
    // 密码长度小于6
    @State private var pwdLenghtAlert: Bool = false
    // 修改密码成功
    @State private var successAlert:Bool = false
    
    @State private var timeoutAlert: Bool = false
    @State private var noInternetAlert: Bool = false
    @State private var unknownError:Bool = false
    
    @State private var hiddenPassword:Bool = true
    
    @State private var hiddenNewPassword:Bool = true
    
    @State private var hiddenReNewPassword:Bool = true
    
    private let autohideDuration = 1.0
    
    var body: some View {
        ZStack{
            ZStack(alignment: .top){
                
                VStack{
                    ScrollView(){
                        VStack(alignment:.leading){
                            Text("原密码")
                                .font(.caption)
                                .fontWeight(.bold)
                                .foregroundColor(.secondary)
                                .padding([.top, .leading], 10)
                            
                            
                            ZStack(alignment: .trailing) {
                                HStack{

                                    CocoaTextField("", text: $pwd)
                                        .secureTextEntry(hiddenPassword)
                                        .autocapitalization(.none)
                                        .disableAutocorrection(true)
                                        .padding()
                                        .background(Color.white)
                                    
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
                            
                            Text("新密码")
                                .font(.caption)
                                .fontWeight(.bold)
                                .foregroundColor(.secondary)
                                .padding([.top, .leading], 10)
                            
                            
                            ZStack(alignment: .trailing) {
                                HStack{
                                    CocoaTextField("", text: $newPwd)
                                        .secureTextEntry(hiddenNewPassword)
                                        .autocapitalization(.none)
                                        .disableAutocorrection(true)
                                        .padding()
                                        .background(Color.white)
                                    
                                }.frame(height: 50)
                                
                                Button(action:{
                                    self.hiddenNewPassword.toggle()
                                }) {
                                    Image(systemName: self.hiddenNewPassword ? "eye.slash.fill" : "eye.fill")
                                        .foregroundColor(self.hiddenNewPassword ? Color.secondary: Color.green)
                                }
                                .frame(height: 50)
                                .offset(x: -10.0)
                            }
                            
                            
                            Text("重复新密码")
                                .font(.caption)
                                .fontWeight(.bold)
                                .foregroundColor(.secondary)
                                .padding([.top, .leading], 10)
                            
                            
                            ZStack(alignment: .trailing) {
                                HStack{
                                    
                                    CocoaTextField("", text: $reNewPwd, onCommit: {
                                        UIApplication.shared.endEditing()
                                        if !(pwd.isEmpty || newPwd.isEmpty || reNewPwd.isEmpty){
                                            self.showingAlert.toggle()
                                        }
                                    })
                                    .secureTextEntry(hiddenReNewPassword)
                                    .autocapitalization(.none)
                                    .returnKeyType(.done)
                                    .disableAutocorrection(true)
                                    .padding()
                                    .background(Color.white)
                                    
                                }.frame(height: 50)
                                
                                Button(action:{
                                    self.hiddenReNewPassword.toggle()
                                }) {
                                    Image(systemName: self.hiddenReNewPassword ? "eye.slash.fill" : "eye.fill")
                                        .foregroundColor(self.hiddenReNewPassword ? Color.secondary: Color.green)
                                }
                                .frame(height: 50)
                                .offset(x: -10.0)
                            }
                        }
                        

                    }.background(Color.black.opacity(0.05))
                    .ignoresSafeArea(.all, edges: .bottom)
                }.padding(.top, 50)
                
                ZStack{
                    
                    Color("SystemColor").frame(width: UIScreen.main.bounds.size.width, height: 50 + UIApplication.shared.windows[0].safeAreaInsets.top)
                        .ignoresSafeArea(.all, edges: .top)
                    
                    VStack(spacing: 0){
                        HStack{
                            Button(action: { presentation.wrappedValue.dismiss() }) {
                                Image(systemName: "chevron.left")
                                    .imageScale(.large)
                            }.padding(.leading, 10)
                            
                            Spacer()
                            
                            Text("修改密码")
                                .font(.system(size: 20.0))
                                .foregroundColor(.black)
                                .lineLimit(1)
//                                .frame(minWidth: 0, maxWidth: 200)
                            
                            Spacer()
                            
                            VStack{
                                if pwd.isEmpty || newPwd.isEmpty || reNewPwd.isEmpty{
                                    Text("完成")
                                        .font(.system(size: 18.0))
                                        .foregroundColor(.gray)
                                        .padding(.horizontal, 10)
                                        .background(Color.gray.opacity(0.3))
                                        .cornerRadius(5)
                                }else{
                                    Button {
                                        self.showingAlert.toggle()
                                    } label: {
                                        Text("完成")
                                            .font(.system(size: 18.0))
                                            .foregroundColor(.white)
                                            .padding(.horizontal, 10)
                                            .background(Color.green)
                                            .cornerRadius(5)
                                    }.alert(isPresented:$showingAlert) {
                                        Alert(
                                            title: Text("确定修改密码？"),
                                            message: Text(""),
                                            primaryButton: .default(Text("确定")) {
//                                                changePassword()
                                                UIApplication.shared.endEditing()
                                                if newPwd != reNewPwd{
                                                    reNewPwdAlert.toggle()
                                                    
                                                }else if newPwd.count < 6 {
                                                    pwdLenghtAlert.toggle()
                                                    
                                                }else if newPwd.isNumeric{
                                                    pwdIsNumericAlert.toggle()
                                                    
                                                }else{
//                                                    guard let user = appModel.user else { return }
//                                                    let now = Date()
//                                                    if user.tokenExpireIn < now {
//                                                        self.showLoadingIndicator.toggle()
//                                                        self.fetchToken()
//                                                    }else{
//                                                        self.showLoadingIndicator.toggle()
//                                                        self.changePassword()
//                                                    }
                                                    self.showLoadingIndicator.toggle()
                                                    self.fetchToken()
                                                }

                                            },
                                            secondaryButton: .destructive(Text("取消")){
                                                showingAlert.toggle()
                                            }
                                        )
                                    }

                                }
                            }.padding(.trailing, 10)

                            
                        }.frame(width: UIScreen.main.bounds.size.width, height: 50)
                        
                    }
                }.frame(width: UIScreen.main.bounds.size.width, height: 50)
            }
            
            if showLoadingIndicator{
                ZStack {
                    RoundedRectangle(cornerRadius: 5.0)
                        .frame(width: 200.0, height: 200.0)
                        .foregroundColor(Color.black.opacity(0.6))
                    VStack {
                        Text("正在修改密码").foregroundColor(.white)
                        ActivityIndicatorView(isVisible: $showLoadingIndicator, type: .growingArc())
                             .frame(width: 50.0, height: 50.0)
                            .foregroundColor(.red)
                    }
                }
            }
        }
        .present(isPresented: self.$reNewPwdAlert, type: .alert, animation: Animation.easeInOut, autohideDuration: autohideDuration, closeOnTap:false) {
            self.createAlertView(message: "两次输入的密码不一致")
        }
        .present(isPresented: self.$pwdIsNumericAlert, type: .alert, animation: Animation.easeInOut, autohideDuration: autohideDuration, closeOnTap:false) {
            self.createAlertView(message: "密码需包含字母跟数字")
        }
        .present(isPresented: self.$pwdLenghtAlert, type: .alert, animation: Animation.easeInOut, autohideDuration: autohideDuration, closeOnTap:false) {
            self.createAlertView(message: "密码长度不能小于6位")
        }
        .present(isPresented: self.$originalPwdAlert, type: .alert, animation: Animation.easeInOut, autohideDuration: autohideDuration, closeOnTap:false) {
            self.createAlertView(message: "原密码不匹配")
        }
        .present(isPresented: self.$samePwdAlert, type: .alert, animation: Animation.easeInOut, autohideDuration: autohideDuration, closeOnTap:false) {
            self.createAlertView(message: "新密码与原密码不能相同")
        }
        .present(isPresented: self.$successAlert, type: .alert, animation: Animation.easeInOut, autohideDuration: autohideDuration, closeOnTap:false) {
            self.createAlertView(message: "修改密码成功")
        }
        .present(isPresented: self.$timeoutAlert, type: .alert, animation: Animation.easeInOut, autohideDuration: autohideDuration, closeOnTap: false) {
            self.createAlertView(message: "服务器连接失败，请稍后重试")
        }
        .present(isPresented: self.$noInternetAlert, type: .alert, animation: Animation.easeInOut, autohideDuration: autohideDuration, closeOnTap: false) {
            self.createAlertView(message: "您似乎没有连接上互联网")
        }
        .present(isPresented: self.$unknownError, type: .alert, animation: Animation.easeInOut, autohideDuration: autohideDuration, closeOnTap: false) {
            self.createAlertView(message: "未知错误，请稍后重试")
        }
        .navigationBarTitle("修改密码")
        .navigationBarHidden(true)
    }
}

struct UserPWDChangeView_Previews: PreviewProvider {
    static var previews: some View {
        UserPWDChangeView()
    }
}

extension UserPWDChangeView{
    
    
    func changePassword(){

        
        guard let user = appModel.user else {
            return
        }

        
        let headers : HTTPHeaders = HTTPHeaders.init([
            HTTPHeader.init(name: "x-http-method-override", value: "patch"),
            HTTPHeader.authorization(bearerToken: user.accessToken)
        ])
        
        let url = baseUrl + "users/" + user.id
        
//        let url = "https://media.lifewpg.ca/api/users/" + user.id
    
        let request = makeRequest(url: url, id: user.id, type: "users", attributes: ["password" : pwd, "newPassword": newPwd, "password_confirmation": reNewPwd], headers: headers)

        request.responseJSON{ response in
            switch response.result {
            case .success(let value):

                let httpResponse = response.response!
                if httpResponse.statusCode == 200{

                    self.showLoadingIndicator.toggle()
                    self.successAlert.toggle()
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        self.presentation.wrappedValue.dismiss()
                    }

                }else{
                    let data = JSON(value)
                    let errors = data["errors"].arrayValue
                    let error = errors[0].dictionaryValue
                    let detail = error["detail"]?.arrayValue[0].stringValue
                    if detail!.contains("相同"){
                        self.showLoadingIndicator.toggle()
                        self.samePwdAlert.toggle()
                    }else if detail!.contains("匹配"){
                        self.showLoadingIndicator.toggle()
                        self.originalPwdAlert.toggle()
                    }
                    
                }
            
                    
            case .failure(let error):
                if let underlyingError = error.underlyingError {
                    if let urlError = underlyingError as? URLError {
                        switch urlError.code {
                        case .timedOut:
                            self.showLoadingIndicator.toggle()
                            self.timeoutAlert.toggle()
                        case .notConnectedToInternet:
                            self.showLoadingIndicator.toggle()
                            self.noInternetAlert.toggle()
                        default:
                            //Do something
                            self.showLoadingIndicator.toggle()
                            self.unknownError.toggle()
                        }
                    }
                }
            }

        }
    }
    private func makeRequest(url: String,id: String, type: String, attributes: Encodable, headers: HTTPHeaders) -> DataRequest {
        let parameters = [
            "data": [
                "id": id,
                "type": type,
                "attributes": attributes
            ]
        ]
        
        
        return Alamofire.AF.request(url, method: .post, parameters: parameters, headers: headers){
            request in
            request.timeoutInterval = 10
        }
    }
    
    private func fetchToken(){
        guard var user = appModel.user else {
            return
        }
        
        let expireTime = user.tokenExpireIn
        
        let now = Date()
        
        let diff = now.distance(to: expireTime)
        
        if diff < 259200 {
            
            let refreshToken = user.refreshToken
//
//            let url = "https://media.lifewpg.ca/api/refresh-token"
            
            let url = baseUrl + "refresh-token"

            let json = RefreshTokenJSON(data: RefreshTokenDataClass(attributes: RefreshTokenAttributes(grant_type: "refresh_token", refresh_token: refreshToken)))

            let request = makeTokenRequest(url: url, param: json)
            
            request.responseJSON{ response in


                switch response.result {
                case .success(let value):
    //                print(value)
                    let datas = JSON(value)
                    let data = datas["data"].dictionaryValue
                    let attributes = (data["attributes"]?.dictionaryValue)!
                    let token = (attributes["access_token"]?.stringValue)!
                    let refresh = (attributes["refresh_token"]?.stringValue)!
                    let expire = (attributes["expires_in"]?.intValue)!
                    let date = Date()
                    let expireIn = date.addingTimeInterval(TimeInterval(Int(expire)))
                    
                    user.accessToken = token
                    user.refreshToken = refresh
                    user.tokenExpireIn = expireIn
                    
                    UserManager.saveUser(user: user)
                    appModel.user = user
                    
                    self.changePassword()
                    
                case .failure(let error):
                    if let underlyingError = error.underlyingError {
                        if let urlError = underlyingError as? URLError {
                            switch urlError.code {
                            case .timedOut:
                                self.showLoadingIndicator.toggle()
                                self.timeoutAlert.toggle()
                            case .notConnectedToInternet:
                                self.showLoadingIndicator.toggle()
                                self.noInternetAlert.toggle()
                            default:
                                //Do something
                                self.showLoadingIndicator.toggle()
                                self.unknownError.toggle()
                            }
                        }
                    }
                }
            }
        }else{

            self.changePassword()
        }
        
    }
    
    private func makeTokenRequest(url:String, param: RefreshTokenJSON) -> DataRequest {


        return Alamofire.AF.request(url, method: .post, parameters: param, encoder: JSONParameterEncoder.default){
            request in
            request.timeoutInterval = 10
        }
    }
    
    private func createAlertView(message:LocalizedStringKey = "") -> some View {
        
        
        VStack() {
            
            Spacer()

            Text(message)
                .foregroundColor(.white)
                .font(.system(size: 15))
                .fontWeight(.bold)

            Spacer()

        }
        .padding()
        .frame(width: 300, height: 50)
        .background(Color(.secondaryLabel))
        .cornerRadius(10.0)
        .shadow(color: Color(.sRGBLinear, white: 0, opacity: 0.13), radius: 10.0)
        
    }
}

// MARK: - RefreshTokenJSON
struct RefreshTokenJSON: Codable {
    let data: RefreshTokenDataClass
}

// MARK: - DataClass
struct RefreshTokenDataClass: Codable {
    let attributes: RefreshTokenAttributes
}

// MARK: - Attributes
struct RefreshTokenAttributes: Codable {
    let grant_type, refresh_token: String
}
