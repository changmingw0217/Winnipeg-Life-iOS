//
//  LanguageSetting.swift
//  WinnipegLife
//
//  Created by changming wang on 9/21/21.
//

import SwiftUI

struct LanguageSetting: View {
    
    @AppStorage("appLanguage") var appLanguage: String = Locale.current.languageCode ?? "zh"
    
    @Environment(\.presentationMode) var presentation
    
    var body: some View {
        ZStack(alignment: .top){
            
            VStack{
                
                ScrollView{
                    
                    HStack{
//                        Button.init(LocalizedStringKey.init("English")) {
//
//                        }
                        
                        Button {
                            appLanguage = "en"
                        } label: {
                            Text("English")
                                .font(.system(size: 20.0))
                                .foregroundColor(.primary)
                        }

                        
                        Spacer()
                    }.padding(.horizontal, 10)
                    .padding(.top, 10)
                    
                    
                    
                    Divider()
                    
                    HStack{
                        Button {
                            appLanguage = "zh"
                        } label: {
                            Text("简体中文")
                                .font(.system(size: 18.0))
                                .foregroundColor(.primary)
                        }
                        
                        Spacer()
                        
                    }
                    .padding(.horizontal, 10)
                    
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
                        
                        Text("语言")
                            .font(.system(size: 20.0))
                            .foregroundColor(.black)
                            .lineLimit(1)
                            .frame(minWidth: 0, maxWidth: 150)
                        
                        Spacer()
                        
                    }.frame(width: UIScreen.main.bounds.size.width, height: 50)
                    
                }
            }.frame(width: UIScreen.main.bounds.size.width, height: 50)
        }
        
        .navigationBarTitle("语言")
        .navigationBarHidden(true)
    }
}

struct LanguageSetting_Previews: PreviewProvider {
    static var previews: some View {
        LanguageSetting()
    }
}
