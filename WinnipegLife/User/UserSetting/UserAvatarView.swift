//
//  UserAvatarView.swift
//  WinnipegLife
//
//  Created by changming wang on 7/8/21.
//

import SwiftUI
import SDWebImageSwiftUI
import ZLPhotoBrowser
import Alamofire
import SwiftyJSON
import ActivityIndicatorView

struct UserAvatarView: View {
    
    let baseUrl = BaseUrl().url
    
    @AppStorage("appLanguage") var appLanguage: String = Locale.current.languageCode ?? "zh"
    
    @EnvironmentObject var appModel: AppModel
    @Environment(\.presentationMode) var presentation
    
    @State private var showLoadingIndicator: Bool = false
    
    @State private var successAlert:Bool = false
    
    @State private var timeoutAlert: Bool = false
    @State private var noInternetAlert: Bool = false
    @State private var unknownError:Bool = false
    
    private let autohideDuration = 1.0
    
    var body: some View {
        ZStack{
            ZStack(alignment:.top){
                VStack{
                    VStack{
                        Spacer()
                        if let user = appModel.user{
                            if user.avatarUrl.isEmpty{
                                Image("defaultusericon")
                                    .resizable()
                                    .frame(width: getRecct().width, height: getRecct().width)
                            }else{
                                WebImage(url: URL(string: user.avatarUrl))
                                    .resizable()
                                    .frame(width: getRecct().width, height: getRecct().width)
                            }

                        }
                        Spacer()
                    }
                }.background(Color.black.opacity(0.95).ignoresSafeArea(.all, edges: .bottom))
                .padding(.top, 50)
                
                
                ZStack{
                    
                    Color.black.opacity(0.95).frame(width: UIScreen.main.bounds.size.width, height: 50 + UIApplication.shared.windows[0].safeAreaInsets.top)
                        .ignoresSafeArea(.all, edges: .top)
                    
                    VStack(spacing: 0){
                        HStack{
                            Button(action: { presentation.wrappedValue.dismiss() }) {
                                Image(systemName: "chevron.left")
                                    .imageScale(.large)
                                    .foregroundColor(.white)
                            }.padding(.leading, 10)
                            
                            Spacer()
                            
                            Text("个人头像")
                                .font(.system(size: 20.0))
                                .foregroundColor(.white)
                                .lineLimit(1)
                                .frame(minWidth: 0, maxWidth: 150)
                            
                            Spacer()
                            
                            Button(action: {
                                selectPhotos()
                            }){
                                Image(systemName: "ellipsis")
                                    .imageScale(.large)
                                    .foregroundColor(.white)
                            }
                            .padding(.trailing, 10)
                            
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
                        Text("正在上传头像").foregroundColor(.white)
                        ActivityIndicatorView(isVisible: $showLoadingIndicator, type: .growingArc())
                             .frame(width: 50.0, height: 50.0)
                            .foregroundColor(.red)
                    }
                }
            }
            
        }
        .present(isPresented: self.$successAlert, type: .alert, animation: Animation.easeInOut, autohideDuration: autohideDuration, closeOnTap:false) {
            self.createAlertView(message: "上传成功")
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
        .navigationBarTitle("个人头像")
        .navigationBarHidden(true)
    }
}

struct UserAvatarView_Previews: PreviewProvider {
    static var previews: some View {
        UserAvatarView()
    }
}

extension UserAvatarView{
    
    func selectPhotos() {
        let scene = UIApplication.shared.connectedScenes.first
        let root = (scene as? UIWindowScene)?.windows.first?.rootViewController
        if root != nil {
            let config = ZLPhotoConfiguration.default()
            config.allowSelectVideo = false
            config.allowRecordVideo = false
            config.allowMixSelect = false
            config.allowSelectOriginal = false
            config.allowSelectGif = false
            config.languageType = appLanguage == "zh" ? .chineseSimplified : .english
            config.maxSelectCount = 1
            config.maxPreviewCount = 0
            config.allowTakePhotoInLibrary = false
            config.allowSelectLivePhoto = false
            config.editImageTools = [.clip]
            config.cameraConfiguration.flashMode = .off
            config.cameraConfiguration.exposureMode = .autoExpose
            config.cameraConfiguration.focusMode = .autoFocus
            config.cameraConfiguration.sessionPreset = .hd1920x1080
            let ps = ZLPhotoPreviewSheet()
            ps.selectImageBlock = {(images, assets, isOriginal) in
                let image = images[0]
                let imgData = NSData(data: image.jpegData(compressionQuality: 1)!)
                let imageSize: Int = imgData.count
                if imageSize > (495 * 1000) {
                    let compression = Double(495 * 1000) / Double(imageSize)
                    let resizeData = NSData(data: image.jpegData(compressionQuality: CGFloat(compression))!)
                    let data = Data(resizeData)
                    
                    self.showLoadingIndicator.toggle()
                    fetchToken(data)
                    
                }else{
                    
                    let data = image.jpegData(compressionQuality: 1)!
                    
                    self.showLoadingIndicator.toggle()
                    fetchToken(data)
                    
                }
                
            }
            ps.showPreview(sender: root!)
//            ps.showPhotoLibrary(sender: root!)
        }
    }
    
    private func uploadAvatar(_ image:Data) {
        
        guard let user = appModel.user else {
            return
        }
        
        let url = baseUrl + "users/" + user.id + "/avatar"
        
//        let url = "https://media.lifewpg.ca/api/users/" + user.id + "/avatar"
        
        let headers : HTTPHeaders = HTTPHeaders.init([
            HTTPHeader.authorization(bearerToken: user.accessToken),
            HTTPHeader.contentType("multipart/form-data"),
            HTTPHeader.contentDisposition("form-data")
        ])
        
        let request = makeRequest(url: url, image: image, headers: headers)
        
        request.responseJSON { response in
            switch response.result{
            case .success(let value):
                let dataJson = JSON(value)
                let data = dataJson["data"]["attributes"].dictionaryValue
                let avatarUrl = data["avatarUrl"]?.stringValue
                
                var newUser = user
                
                newUser.avatarUrl = avatarUrl!
                
                UserManager.logout()
                UserManager.saveUser(user: newUser)
                appModel.user = newUser
                
                self.showLoadingIndicator.toggle()
                self.successAlert.toggle()
                
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
    
    
    private func fetchToken(_ image:Data){
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
                    
                    self.uploadAvatar(image)
                    
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
            self.uploadAvatar(image)
        }
        
    }
    
    private func makeRequest(url: String,image: Data, headers: HTTPHeaders) -> DataRequest {
        
        return AF.upload(multipartFormData: { (multipartFormData) in
            
            multipartFormData.append(image, withName: "avatar", fileName: "avatar", mimeType: "image/jpeg")
            
        }, to: URL.init(string: url)!,
        method: .post,
        headers: headers)
    }
    
    private func makeTokenRequest(url:String, param: RefreshTokenJSON) -> DataRequest {

        return Alamofire.AF.request(url, method: .post, parameters: param, encoder: JSONParameterEncoder.default){
            request in
            request.timeoutInterval = 5
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
        .frame(width: 250, height: 50)
        .background(Color(.secondaryLabel))
        .cornerRadius(10.0)
        .shadow(color: Color(.sRGBLinear, white: 0, opacity: 0.13), radius: 10.0)
        
    }
    
}
