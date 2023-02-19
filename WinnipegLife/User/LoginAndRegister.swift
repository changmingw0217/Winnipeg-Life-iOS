//
//  LoginAndRegister.swift
//  WPGL
//
//  Created by changming wang on 5/18/21.
//

import SwiftUI
import Combine
import ActivityIndicatorView

struct LoginAndRegister: View {
    
    
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var appModel: AppModel
    
    @State var index = 0
    @Namespace var name
    
    
    var body: some View{
        NavigationView{
            ZStack(alignment: .topLeading){
                VStack{
                    
                    Image("Logo")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 70, height: 70)
                    
                    
                    
                    HStack(spacing: 0){
                        
                        Button(action: {
                            withAnimation(.spring()){
                                index = 0
                            }
                        }, label: {
                            VStack{
                                Text("登录")
                                    .font(.system(size: 20))
                                    .fontWeight(.bold)
                                    .foregroundColor(index == 0 ? .black : .gray)
                                
                                ZStack{
                                    Capsule()
                                        .fill(Color.black.opacity(0.04))
                                        .frame(height:4)
                                    
                                    if index == 0 {
                                        Capsule()
                                            .fill(Color(.orange))
                                            .frame(height:4)
                                            .matchedGeometryEffect(id: "Tab", in: name)
                                    }
                                }
                            }
                        })
                        
                        Button(action: {
                            withAnimation(.spring()){
                                index = 1
                            }
                        }, label: {
                            VStack{
                                Text("注册")
                                    .font(.system(size: 20))
                                    .fontWeight(.bold)
                                    .foregroundColor(index == 1 ? .black : .gray)
                                
                                ZStack{
                                    Capsule()
                                        .fill(Color.black.opacity(0.04))
                                        .frame(height:4)
                                    
                                    if index == 1 {
                                        Capsule()
                                            .fill(Color(.orange))
                                            .frame(height:4)
                                            .matchedGeometryEffect(id: "Tab", in: name)
                                    }
                                }
                                
                            }
                        })
                    }.padding(.top, 30)
                    
                    if index == 0{
                        LoginView()
                    }else{
                        RegisterView()
                    }
                }
                
                
                Button(action: {
                    self.presentationMode.wrappedValue.dismiss()
                }){
                    Image(systemName: "chevron.backward")
                        .font(.system(size: 22))
                        .foregroundColor(.orange)
                }.offset(x: 10, y: 10)
                
            }

            .frame(minWidth: /*@START_MENU_TOKEN@*/0/*@END_MENU_TOKEN@*/,maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, minHeight: /*@START_MENU_TOKEN@*/0/*@END_MENU_TOKEN@*/, maxHeight: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
            .navigationTitle("")
            .navigationBarHidden(true)
            .gesture(DragGesture(minimumDistance: 50, coordinateSpace: .local)
                        .onEnded({ value in
                if value.translation.width < 0 {
                    // left
                    withAnimation {
                        index = 1
                    }
                }
                
                if value.translation.width > 0 {
                    // right
                    withAnimation {
                        index = 0
                    }
                }
            }))
            
        }.navigationBarHidden(true)
        
    }
}
