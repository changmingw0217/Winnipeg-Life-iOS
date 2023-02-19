//
//  AboutPage.swift
//  WinnipegLife
//
//  Created by changming wang on 10/26/21.
//

import SwiftUI

struct AboutPage: View {
    @Environment(\.presentationMode) var presentation

    
    var body: some View {
        NavigationView{
        ZStack(alignment: .top){
            
            ScrollView(showsIndicators: false){
                VStack(alignment: .leading){
                    Text("About")
                        .font(.title)
                        .padding(.bottom, 10)
                    
                    Text("The Life Winnipeg Technique Ltd is a Winnipeg local-based computer technology company. The company is committed to developing local market business, resource integration in multiple fields, and real-time media broadcast.")
                        .padding(.bottom, 10)
                    
                    Text("Meanwhile, Life Winnipeg Technique Ltd is committed to building various ethnic and cultural communication exchange platforms and participating in community services. The company's ultimate goal is to build up a local online business district that provides restaurants, hotels, supermarkets, and entertainment services.")
                        .padding(.bottom, 10)

                    
                    Text("100 Innovation Dr")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Text("Winnipeg, R3T 6A8")
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .padding(.bottom, 5)
                    Text("204-296-8659")
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .padding(.bottom, 5)
                    Text("marketing@lifewpg.com")
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .padding(.bottom, 40)
                    
                    HStack{
                        Spacer()
                        NavigationLink(destination: UserAgreements()){
                            NavigationLink(destination: EmptyView()) {
                                EmptyView()
                            }
                            Text("《用户协议》")
                                .font(.system(size: 20.0))
                                .foregroundColor(.green)
                        }
                        Spacer()
                    }
                    
                    HStack{
                        Spacer()
                        NavigationLink(destination: PrivacyAgreementsView()){
                            NavigationLink(destination: EmptyView()) {
                                EmptyView()
                            }
                            Text("《隐私政策》")
                                .font(.system(size: 20.0))
                                .foregroundColor(.green)
                        }
                        Spacer()
                    }

                }.padding(.horizontal, 10)
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
                        
                        Text("关于/联系")
                            .font(.system(size: 20.0))
                            .foregroundColor(.black)
                            .lineLimit(1)
                            .frame(minWidth: 0, maxWidth: 150)
                        
                        Spacer()
                        
                    }.frame(width: UIScreen.main.bounds.size.width, height: 50)
                    
                }
            }.frame(width: UIScreen.main.bounds.size.width, height: 50)
        }
        .navigationTitle("")
        .navigationBarHidden(true)
        }
        .navigationTitle("")
        .navigationBarHidden(true)
        

    }
}

struct AboutPage_Previews: PreviewProvider {
    static var previews: some View {
        AboutPage()
    }
}
