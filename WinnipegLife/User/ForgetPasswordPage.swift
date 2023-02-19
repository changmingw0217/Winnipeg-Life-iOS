//
//  ForgetPasswordPage.swift
//  WinnipegLife
//
//  Created by changming wang on 10/25/21.
//

import SwiftUI
import SwiftUIX
import ActivityIndicatorView
import Alamofire
import SwiftyJSON

struct ForgetPasswordPage: View {
    
    let baseUrl = BaseUrl().url
    
    @Environment(\.presentationMode) var presentation
    
    @State private var showLoadingIndicator: Bool = false
    
    @State private var showingAlert = false
    
    @State private var email:String = ""
    
    @State private var showError:Bool = false
    
    @State private var succeessAlert: Bool = false
    @State private var emailNotExistAlert: Bool = false
    
    @State private var timeoutAlert: Bool = false
    @State private var noInternetAlert: Bool = false
    @State private var unknownError:Bool = false
    @State private var emailError: Bool = false
    
    let autohideDuration = 1.5
    
    var body: some View {
        ZStack{
            ZStack(alignment: .top){
                
                VStack{
                    ScrollView(showsIndicators: false){
                        VStack(alignment: .leading){
                            
                            Text("您的邮箱")
                                .font(.title)
                                .fontWeight(.bold)
                                .foregroundColor(.primary)
                                .padding()
                            
                            CocoaTextField("Email",text: $email, onCommit: {
                                UIApplication.shared.endEditing()
                                
                                if !email.isValidEmail{
                                    emailError = true
                                }else{
                                    sendEmail()
                                    showLoadingIndicator = true
                                }
                            })
                            .autocapitalization(.none)
                            .clearButtonMode(.whileEditing)
                            .returnKeyType(.done)
                            .padding()
                            .disableAutocorrection(true)
                            .background(Color.white)
                            .padding()
                                
                        }
                        
                        Button(action: {
                            
                            UIApplication.shared.endEditing()
                            
                            if !email.isValidEmail{
                                emailError = true
                            }else{
                                sendEmail()
                                showLoadingIndicator = true
                                
                            }
                            
                        }, label: {
                            Text("提交")
                                .font(.system(size: 20))
                                .foregroundColor(.white)
                                .fontWeight(.bold)
                                .padding(.vertical)
                                .frame(width: UIScreen.main.bounds.width - 80)
                                .background(
                                    LinearGradient(gradient: .init(colors: [Color("Color"), Color("Color1")]), startPoint: .topLeading, endPoint: .bottomTrailing)
                                )
                                .cornerRadius(8)
                        })

                        
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
                                    .foregroundColor(.orange)
                            }.padding(.leading, 10)
                            
                            Spacer()
                            
                            Text("忘记密码?")
                                .font(.system(size: 20.0))
                                .foregroundColor(.black)
                                .lineLimit(1)
                                .frame(minWidth: 0, maxWidth: 150)
                            
                            Spacer()
                            
                        }.frame(width: UIScreen.main.bounds.size.width, height: 50)
                        
                    }
                }.frame(width: UIScreen.main.bounds.size.width, height: 50)
            }
            .navigationBarTitle("忘记密码?")
            .navigationBarHidden(true)
            
            
            if showLoadingIndicator{
                ZStack {
                    RoundedRectangle(cornerRadius: 5.0)
                        .frame(width: 200.0, height: 200.0)
                        .foregroundColor(Color.black.opacity(0.6))
                    VStack {
                        Text("Loading").foregroundColor(.white)
                        ActivityIndicatorView(isVisible: $showLoadingIndicator, type: .growingArc())
                             .frame(width: 50.0, height: 50.0)
                            .foregroundColor(.red)
                    }
                }
            }

        }
        .present(isPresented: self.$emailError, type: .alert, animation: Animation.easeInOut, autohideDuration: autohideDuration, closeOnTap: false) {
            self.createAlertView(message: "请输入正确的邮箱")
        }
        .present(isPresented: self.$emailNotExistAlert, type: .alert, animation: Animation.easeInOut, autohideDuration: autohideDuration, closeOnTap: false) {
            self.createAlertView(message: "邮箱不存在")
        }
        .present(isPresented: self.$succeessAlert, type: .alert, animation: Animation.easeInOut, autohideDuration: 2, closeOnTap: false) {
            self.createAlertView(message: "链接发送成功，请检查邮箱")
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
        .onChange(of: self.succeessAlert, perform: { _ in
            if self.succeessAlert == false{
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    self.presentation.wrappedValue.dismiss()
                }
            }
        })
        .navigationBarTitle("忘记密码?")
        .navigationBarHidden(true)
    }
}

//struct ForgetPasswordPage_Previews: PreviewProvider {
//    static var previews: some View {
//        ForgetPasswordPage()
//    }
//}


extension ForgetPasswordPage{
    
    func sendEmail(){
        
        let url = baseUrl + "email/findpwd?email_type=0&email=" + email
        
//        let url = "https://media.lifewpg.ca/api/email/findpwd?email_type=0&email=" + email
        
        AF.request(url).responseJSON { response in
            switch response.result {
            case .success(_):
//                print(value)
                
                let httpResponse = response.response!
                
                if httpResponse.statusCode == 201 {
                    self.succeessAlert = true
                    
                }else{
                    self.emailNotExistAlert = true
                }
                
                self.showLoadingIndicator = false
                
                
                
            case .failure(let error):
                if let underlyingError = error.underlyingError {
                    if let urlError = underlyingError as? URLError {
                        switch urlError.code {
                        case .timedOut:
                            self.showLoadingIndicator = false
                            self.timeoutAlert.toggle()
                        case .notConnectedToInternet:
                            self.showLoadingIndicator = false
                            self.noInternetAlert.toggle()
                        default:
                            //Do something
                            self.showLoadingIndicator = false
                            self.unknownError.toggle()
                        }
                    }
                }
            }
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
