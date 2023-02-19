//
//  SystemMessageView.swift
//  WinnipegLife
//
//  Created by changming wang on 7/22/21.
//

import SwiftUI

struct SystemMessageView: View {
    
    
    @Environment(\.presentationMode) var presentation
    
    @EnvironmentObject var messageContent: Message
    
    var body: some View {
        ZStack(alignment: .top){
            VStack{
                if messageContent.loadingNotifications {
                    SimpleRefreshingView()
                        .padding()
                }else{
                    if messageContent.notifications.count > 0 {
                        ScrollView(){
                            LazyVStack(spacing:0){
                                ForEach(messageContent.notifications.indices, id: \.self){ index in
                                    ZStack{
                                        
                                        LinearGradient(gradient: .init(colors: [Color("deleteLightRed"),Color("deleteRed")]), startPoint: .leading, endPoint: .trailing)
                                        
                                        HStack{
                                            
                                            Spacer()
                                            
                                            Button {

                                                deleteNotification(messageContent.notifications[index])
                                            } label: {
                                                Text("删除")
                                                    .font(.title3)
                                                    .foregroundColor(.white)
                                                    .padding(.trailing, 22.5)
                                            }
                                        }
                                        
                                        SystemMessageRowView(notification: messageContent.notifications[index])
                                            .offset(x: messageContent.notifications[index].offset)
                                            .gesture(DragGesture().onChanged({ value in
                                                if value.translation.width < 0{
                                                    
                                                    if messageContent.notifications[index].isSwiped{
                                                        messageContent.notifications[index].offset = value.translation.width - 90
                                                    }else{
                                                        messageContent.notifications[index].offset = value.translation.width
                                                    }
                                                }
                                            }).onEnded({ value in
                                                if value.translation.width < 0 {
                                                    if -value.translation.width > UIScreen.main.bounds.width / 2{
                                                        messageContent.notifications[index].offset = -1000
                                                        deleteNotification(messageContent.notifications[index])
                                                    }
                                                    else if -messageContent.notifications[index].offset > 50 {
                                                        withAnimation(.easeOut){
                                                            closeSwiped()
                                                            messageContent.notifications[index].isSwiped = true
                                                            messageContent.notifications[index].offset = -90
                                                        }
                                                        
                                                    }else{
                                                        withAnimation(.easeOut){
                                                            closeSwiped()
                                                            messageContent.notifications[index].isSwiped = false
                                                            messageContent.notifications[index].offset = 0
                                                        }
                                                        
                                                    }
                                                }else{
                                                    withAnimation(.easeOut){
                                                        messageContent.notifications[index].isSwiped = false
                                                        messageContent.notifications[index].offset = 0
                                                    }
                                                    
                                                }
                                            }))
                                            .onTapGesture {
                                                
                                                withAnimation(.easeOut){
                                                    if messageContent.notifications[index].isSwiped{
                                                        messageContent.notifications[index].isSwiped = false
                                                        messageContent.notifications[index].offset = 0
                                                    }
                                                    
                                                }
                                            }
                                    }
                                }
                            }
                        }
                    }else{
                        VStack{
                            Spacer()
                            Text("暂无任何系统消息")
                            Spacer()
                        }
                        .frame(minWidth: /*@START_MENU_TOKEN@*/0/*@END_MENU_TOKEN@*/,maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, minHeight: /*@START_MENU_TOKEN@*/0/*@END_MENU_TOKEN@*/, maxHeight: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                    }

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
                                .foregroundColor(.orange)
                        }.padding(.leading, 10)
                        
                        Spacer()
                        
                        Text("系统消息")
                            .font(.system(size: 20.0))
                            .foregroundColor(.black)
                            .lineLimit(1)
                            .frame(minWidth: 0, maxWidth: 150)
                        
                        Spacer()
                        
                    }.frame(width: UIScreen.main.bounds.size.width, height: 50)
                    
                }
            }.frame(width: UIScreen.main.bounds.size.width, height: 50)
            
        }
        .onAppear{
            messageContent.fetchnotification()
        }
        .navigationBarTitle("系统消息")
        .navigationBarHidden(true)
        
    }
}

//struct SystemMessageView_Previews: PreviewProvider {
//    static var previews: some View {
//        SystemMessageView()
//    }
//}


extension SystemMessageView {
    
    func closeSwiped() {
        for index in messageContent.notifications.indices{
            
            if messageContent.notifications[index].isSwiped{
                withAnimation(.easeIn){
                    messageContent.notifications[index].offset = .zero
                    messageContent.notifications[index].isSwiped = false
                }
                
            }
        }
    }
    
    func deleteNotification(_ notificationData: NotificationData) {
        
        messageContent.deleteNotification(nitificationId: notificationData.notificationId)
        
        messageContent.notifications.removeAll {(notificationData1) -> Bool in
            return notificationData.notificationId == notificationData.notificationId
        }
        
        
    }
    
    
    struct SystemMessageRowView: View {
        
        let notification:NotificationData
        
        var body: some View{
            VStack{
                HStack(spacing:12){
                    Image("SystemNotificationIcon")
                        .renderingMode(.original)
                        .resizable()
                        .frame(width: 48, height: 48)
                        .cornerRadius(8)
                    
                    VStack(alignment: .leading, spacing: 5){
                        HStack(alignment:.top){
                            Text(notification.title)
                                .font(.system(size: 16, weight: .regular))
                                .foregroundColor(.primary)
                            Spacer()
                            Text(notification.createdAt)
                                .font(.system(size: 10))
                                .foregroundColor(.secondary)
                        }
                        
                        Text(notification.content)
                            .fixedSize(horizontal: false, vertical: true)
                            .font(.system(size: 15))
                            .foregroundColor(.secondary)
                    }
                }.padding(EdgeInsets(top: 12, leading: 16, bottom: 12, trailing: 16))
                
                Divider()
            }
            .background(Color.white)
            
        }
    }
}
