//
//  UsernameChangeView.swift
//  WinnipegLife
//
//  Created by changming wang on 7/6/21.
//

import Foundation
import SwiftUI
import SwiftUIX
import Alamofire
import SwiftyJSON
import ActivityIndicatorView

struct UsernameChangeView: View {
    
    let baseUrl = BaseUrl().url

    
    @EnvironmentObject var appModel: AppModel
    @Environment(\.presentationMode) var presentation
    
    @State private var showLoadingIndicator: Bool = false
    
    @State private var showingAlert = false
    
    @State private var username:String = ""
    
    @State private var showError:Bool = false
    
    @State private var timeoutAlert: Bool = false
    @State private var noInternetAlert: Bool = false
    @State private var unknownError:Bool = false
    
    private let autohideDuration = 1.0
    
    var body: some View {
        ZStack{
            ZStack(alignment: .top){
                VStack{
                    ScrollView(showsIndicators: false){
                        VStack(alignment: .leading){
                            
                            CocoaTextField("",text: $username, onCommit: {
                                showingAlert.toggle()
                                UIApplication.shared.endEditing()
                            })
                            .autocapitalization(.none)
                            .clearButtonMode(.whileEditing)
                            .returnKeyType(.done)
                            .padding()
                            .disableAutocorrection(true)
                            .background(Color.white)
                                

                            Text("*只有一次更改用户名的机会")
                                .font(.caption)
                                .fontWeight(.bold)
                                .foregroundColor(.secondary)
                                .padding()
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
                            
                            Text("修改用户名")
                                .font(.system(size: 20.0))
                                .foregroundColor(.black)
                                .lineLimit(1)
//                                .frame(minWidth: 0, maxWidth: 150)
                            
                            Spacer()
                            
                            VStack{
                                if username.isEmpty{
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
                                            title: Text("确定要将用户名修改成 \(username) ？"),
                                            message: Text("只有一次修改机会！"),
                                            primaryButton: .default(Text("确定")) {
                                                self.showLoadingIndicator.toggle()
                                                fetchToken()
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
                        Text("正在修改用户名").foregroundColor(.white)
                        ActivityIndicatorView(isVisible: $showLoadingIndicator, type: .growingArc())
                             .frame(width: 50.0, height: 50.0)
                            .foregroundColor(.red)
                    }
                }
            }
        }
        .present(isPresented: self.$showError, type: .alert, animation: Animation.easeInOut, autohideDuration: 1.0, closeOnTap: false) {
            self.createAlertView(message: "用户名已经存在")
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
        .navigationBarTitle("修改用户名")
        .navigationBarHidden(true)
    }
}

struct UsernameChangeView_Previews: PreviewProvider {
    static var previews: some View {
        UsernameChangeView()
    }
}

extension UsernameChangeView{
    
    func changeUserName(){
        
        
        guard var user = appModel.user else {
            return
        }
        
        
        let headers : HTTPHeaders = HTTPHeaders.init([
            HTTPHeader.init(name: "x-http-method-override", value: "patch"),
            HTTPHeader.authorization(bearerToken: user.accessToken)
        ])
        
        let url = baseUrl + "users/" + user.id
        
//        let url = "https://media.lifewpg.ca/api/users/" + user.id
    
        let request = makeRequest(url: url, id: user.id, type: "users", attributes: ["username": username], headers: headers)

        request.responseJSON{ response in
            switch response.result {
            case .success(_):
                
                let httpResponse = response.response!
                if httpResponse.statusCode == 200{
                    
                    user.username = username
                    user.canEditUsername = false
                    
                    UserManager.saveUser(user: user)
                    appModel.user = user
                    self.showLoadingIndicator.toggle()
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                        self.presentation.wrappedValue.dismiss()
                    }
                    
                }else{
                    self.showError.toggle()
                }
                
                self.showLoadingIndicator.toggle()
                    
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
    
    private func fetchToken(){
        guard var user = appModel.user else {
            return
        }
        
        let expireTime = user.tokenExpireIn
        
        let now = Date()
        
        let diff = now.distance(to: expireTime)
        
        if diff < 259200 {
            
            let refreshToken = user.refreshToken

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
                    
                    self.changeUserName()
                    
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

            self.changeUserName()
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
            request.timeoutInterval = 5
        }
    }
    
    private func makeTokenRequest(url:String, param: RefreshTokenJSON) -> DataRequest {


        return Alamofire.AF.request(url, method: .post, parameters: param, encoder: JSONParameterEncoder.default){
            request in
            request.timeoutInterval = 5
        }
    }
    
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

