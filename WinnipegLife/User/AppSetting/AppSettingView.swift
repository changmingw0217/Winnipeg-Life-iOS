//
//  AppSettingView.swift
//  WinnipegLife
//
//  Created by changming wang on 8/29/21.
//

import SwiftUI

struct AppSettingView: View {
    
    @AppStorage("appLanguage") var appLanguage: String = Locale.current.languageCode ?? "zh"
    
    @Environment(\.presentationMode) var presentation
    
    var body: some View {
        NavigationView{
            ZStack(alignment: .top){
                VStack{
                    
                    ScrollView{
                        //                    Button.init(LocalizedStringKey.init("Change Language")) {
                        //                        print(appLanguage)
                        //                        appLanguage = appLanguage == "zh" ? "en" : "zh"
                        //                    }
                        NavigationLink(destination: LanguageSetting()) {
                            HStack(){
                                Image(systemName: "globe")
                                    .foregroundColor(Color(.secondaryLabel))
                                Text("语言")
                                Spacer()
                                Image(systemName: "chevron.right")
                                    .foregroundColor(Color(.secondaryLabel))
                            }.padding(.horizontal, 10)
                                .foregroundColor(.black)
                                .frame(height: 50)
                        }
                        
                        Divider()
                    }
                    
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
                            
                            Text("Setting")
                                .font(.system(size: 20.0))
                                .foregroundColor(.black)
                                .lineLimit(1)
                                .frame(minWidth: 0, maxWidth: 150)
                            
                            Spacer()
                            
                        }.frame(width: UIScreen.main.bounds.size.width, height: 50)
                        
                    }
                }.frame(width: UIScreen.main.bounds.size.width, height: 50)
            }
            .navigationBarTitle("软件设置")
            .navigationBarHidden(true)
        }
        .navigationBarTitle("软件设置")
        .navigationBarHidden(true)
    }
}

struct AppSettingView_Previews: PreviewProvider {
    static var previews: some View {
        AppSettingView()
    }
}
