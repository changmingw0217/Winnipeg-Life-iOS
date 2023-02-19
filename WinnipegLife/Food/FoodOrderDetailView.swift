//
//  FoodOrderDetailView.swift
//  WinnipegLife
//
//  Created by changming wang on 9/13/21.
//

import SwiftUI
import iPhoneNumberField
import KeyboardObserving
import ActivityIndicatorView
import Alamofire

import Foundation

struct FoodOrderDetailView: View {
    
    let storeOwnerId:String
    
    let threadId: String
    
    @Environment(\.presentationMode) var presentation
    
    @EnvironmentObject var appModel: AppModel
    
    @ObservedObject var keyboardHeightHelper = KeyboardHeightHelper()
    
    @State private var name:String = ""
    
    @State private var phone:String = ""
    
    @State private var numberOfPeople = ""
    
    @State private var date = Date()
    
    @State private var note:String = ""
    
    @State private var clickOnNote = false
    
    @State private var successAlert:Bool = false
    
    
    
    @State private var noNameAlert: Bool = false
    @State private var noPhoneAlert: Bool = false
    @State private var noNumberAlert:Bool = false
    @State private var dateNotValidAlert: Bool = false
    @State private var timeoutAlert: Bool = false
    @State private var noInternetAlert: Bool = false
    @State private var unknownError:Bool = false
    
    @State private var showLoadingIndicator: Bool = false
    
    private let autohideDuration = 1.5
    
    
    var body: some View {
        ZStack{
            ZStack(alignment: .top) {
                VStack{
                    ScrollView{
                        ScrollViewReader{ proxy in
                            VStack(alignment:.leading, spacing: 10){
                                Text("姓名")
                                    .font(.subheadline)
                                    .fontWeight(.bold)
                                    .foregroundColor(.secondary)
                                TextField("", text:$name)
                                    .autocapitalization(.none)
                                    .disableAutocorrection(true)
                                    .padding()
                                    .background(Color.white)
                                    .cornerRadius(5)
                                    .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 5)
                                    .shadow(color: Color.black.opacity(0.08), radius: 5, x: 0, y: -5)
                                
                                Text("电话")
                                    .font(.subheadline)
                                    .fontWeight(.bold)
                                    .foregroundColor(.secondary)
                                iPhoneNumberField("", text:$phone)
                                    .flagHidden(false)
                                    .flagSelectable(true)
                                    .clearButtonMode(.whileEditing)
                                    .defaultRegion("CA")
                                    .padding()
                                    .background(Color.white)
                                    .cornerRadius(5)
                                    .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 5)
                                    .shadow(color: Color.black.opacity(0.08), radius: 5, x: 0, y: -5)
                                
                                Text("订餐人数")
                                    .font(.subheadline)
                                    .fontWeight(.bold)
                                    .foregroundColor(.secondary)
                                TextField("", text:$numberOfPeople)
                                    .keyboardType(.numberPad)
                                    .autocapitalization(.none)
                                    .disableAutocorrection(true)
                                    .padding()
                                    .background(Color.white)
                                    .cornerRadius(5)
                                    .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 5)
                                    .shadow(color: Color.black.opacity(0.08), radius: 5, x: 0, y: -5)
                                
                                
                                DatePicker(LocalizedStringKey("订餐时间"),
                                           selection: $date,
                                           in: Date()...)
                                    .padding([.top,.bottom], 10)
                                    .accentColor(.orange)
                                
                                
                                
                                Text("备注(可选)")
                                    .font(.subheadline)
                                    .fontWeight(.bold)
                                    .foregroundColor(.secondary)
                                TextEditor(text: $note)
                                    .border(Color.primary, width: 1, cornerRadius: 5)
                                    .frame(height: 100)
                                    .onTapGesture{
                                        clickOnNote.toggle()
                                    }
                                
                                
                            }
                            .padding(.horizontal, 10)
                            .padding(.top, 10)
                            .onChange(of: clickOnNote) { _ in
                                withAnimation{
                                    proxy.scrollTo(1)
                                }
                            }
                            
                            Button(action: {
                                
                                UIApplication.shared.endEditing()
                                
                                let now = Date()
                                
                                if name.isEmpty{
                                    noNameAlert.toggle()
                                }else if phone.isEmpty{
                                    noPhoneAlert.toggle()
                                }else if numberOfPeople.isEmpty{
                                    noNumberAlert.toggle()
                                }else if date < now {
                                    dateNotValidAlert.toggle()
                                }else{
                                    reserve()
                                }
                                
                                
                            }, label: {
                                Text("预约")
                                    .font(.system(size: 20))
                                    .foregroundColor(.white)
                                    .fontWeight(.bold)
                                    .padding(.vertical)
                                    .frame(width: UIScreen.main.bounds.width - 50)
                                    .background(
                                        LinearGradient(gradient: .init(colors: [Color("Color"), Color("Color1")]), startPoint: .topLeading, endPoint: .bottomTrailing)
                                    )
                                    .cornerRadius(8)
                                    .padding(.horizontal, 25)
                                    .padding(.top, 10)
                                    .padding(.bottom, 5)
                                    .id(1)
                            })
                            //                        .padding(.horizontal, 25)
                            //                        .padding(.top, 10)
                            //                        .padding(.bottom, 5)
                            //                        .id(1)
                        }
                        
                        
                        
                    }
                    .introspectScrollView { view in
                        view.keyboardDismissMode = .onDrag
                    }
                    
                    
                }
                .padding(.top, 50)
                
                
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
                            
                            Text("预约餐厅")
                                .font(.system(size: 20.0))
                                .foregroundColor(.black)
                                .lineLimit(1)
                                .frame(minWidth: 0, maxWidth: 150)
                            
                            Spacer()
                            
                            Button {
                                UIApplication.shared.endEditing()
                                
                                let now = Date()
                                
                                if name.isEmpty{
                                    noNameAlert.toggle()
                                }else if phone.isEmpty{
                                    noPhoneAlert.toggle()
                                }else if numberOfPeople.isEmpty{
                                    noNumberAlert.toggle()
                                }else if date < now {
                                    dateNotValidAlert.toggle()
                                }else{
                                    reserve()
                                }
                                
                            } label: {
                                Text("预约")
                                    .font(.system(size: 16.0))
                                    .foregroundColor(.orange)
                                    .padding(.trailing, 10)
                            }
                            
                            
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
                        Text("正在预约").foregroundColor(.white)
                        ActivityIndicatorView(isVisible: $showLoadingIndicator, type: .growingArc())
                            .frame(width: 50.0, height: 50.0)
                            .foregroundColor(.red)
                    }
                }
            }
            
        }
        .keyboardObserving()
        .present(isPresented: self.$noNameAlert, type: .alert, animation: Animation.easeInOut, autohideDuration: autohideDuration, closeOnTap: false) {
            self.createAlertView(message: "姓名不能为空")
        }
        .present(isPresented: self.$noPhoneAlert, type: .alert, animation: Animation.easeInOut, autohideDuration: autohideDuration, closeOnTap: false) {
            self.createAlertView(message: "电话不能为空")
        }
        .present(isPresented: self.$noNumberAlert, type: .alert, animation: Animation.easeInOut, autohideDuration: autohideDuration, closeOnTap: false) {
            self.createAlertView(message: "人数不能为空")
        }
        .present(isPresented: self.$dateNotValidAlert, type: .alert, animation: Animation.easeInOut, autohideDuration: autohideDuration, closeOnTap: false) {
            self.createAlertView(message: "日期不正确")
        }
        .present(isPresented: self.$successAlert, type: .alert, animation: Animation.easeInOut, autohideDuration: autohideDuration, closeOnTap:false) {
            self.createAlertView(message: "预约成功，请等待餐厅接单")
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
        .navigationBarTitle("预约餐厅")
        .navigationBarHidden(true)
    }
}

extension FoodOrderDetailView{
    
    func createAlertView(message:LocalizedStringKey) -> some View {
        
        
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
    
    func reserve() {
        
        guard let user = appModel.user else {
            return
        }
        
        showLoadingIndicator = true
        
        let headers : HTTPHeaders = HTTPHeaders.init([
            HTTPHeader.authorization(bearerToken: user.accessToken)
        ])
        
        let url = "https://media.lifewpg.ca/api/rdio/create"
        
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone(identifier: "America/Winnipeg")
        formatter.dateFormat = "YYYY-MM-d hh:mm"
        
        
        let attr = ReserveAttributes(customerID: user.id, restaurantUserID: storeOwnerId, restaurantMainthreadID: threadId, diningNum: numberOfPeople, customerName: name, customerMobile: phone, diningTime: formatter.string(from: date), note: note)
        
        let requestClass = ReserveDataClass(type: "xz_rdio_order", attributes: attr)
        
        let attributes = ReserveResta(data: requestClass)
        
        let request = makeRequest(url: url, parameters: attributes, headers: headers)
        
        
        request.responseJSON{ response in
            switch response.result {
            case .success(let value):
                print(value)
                self.showLoadingIndicator = false
                self.successAlert = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                    self.presentation.wrappedValue.dismiss()
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
    
    private func makeRequest(url: String, parameters: ReserveResta, headers: HTTPHeaders) -> DataRequest {
        
        return Alamofire.AF.request(url, method: .post, parameters: parameters,encoder: JSONParameterEncoder.default,headers: headers){
            request in
            request.timeoutInterval = 10
        }
    }
    
    struct ReserveResta: Codable {
        var data: ReserveDataClass
    }
    
    // MARK: - DataClass
    struct ReserveDataClass: Codable {
        var type: String
        var attributes: ReserveAttributes
    }
    
    // MARK: - Attributes
    struct ReserveAttributes: Codable {
        var customerID, restaurantUserID, restaurantMainthreadID, diningNum: String
        var customerName, customerMobile, diningTime, note: String
        
        enum CodingKeys: String, CodingKey {
            case customerID = "customer_id"
            case restaurantUserID = "restaurant_user_id"
            case restaurantMainthreadID = "restaurant_mainthread_id"
            case diningNum = "dining_num"
            case customerName = "customer_name"
            case customerMobile = "customer_mobile"
            case diningTime = "dining_time"
            case note
        }
    }
    
}

//struct FoodOrderDetailView_Previews: PreviewProvider {
//    static var previews: some View {
//        FoodOrderDetailView()
//    }
//}
