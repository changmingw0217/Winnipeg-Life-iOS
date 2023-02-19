//
//  MessagePage.swift
//  WPGLife
//
//  Created by changming wang on 4/16/21.
//

import SwiftUI

struct MessagePage: View {
    
    @EnvironmentObject var appModel: AppModel
    
    @EnvironmentObject var messageContent: Message
    
    @Binding var tabSelection:Int
    
    @State var isActive:Bool = false
    
    @State var notificationIsActive:Bool = false
    
    @State var chatIndex: Int = 0
    
    var body: some View {
        
        ZStack(alignment: .top) {
            ZStack{
                if let _ = appModel.user {
                    ScrollView(){
                        
                        NavigationLink.init(destination: SystemMessageView(), isActive: $notificationIsActive){}
                        SystemMessage()
                            .onTapGesture {
                                closeSwiped()
                                self.notificationIsActive = true
                            }
                        
                        if messageContent.chats.count > 0 {
                            NavigationLink.init(destination: MessageDetailView(recipient: messageContent.chats[chatIndex].member.name, messageDetial: MessageDetail(chatId: messageContent.chats[chatIndex].dialogId)),isActive: $isActive){}
                        }
                        
                        LazyVStack(spacing: 0){
                            //                        ForEach(messageContent.chats.indices, id: \.self){ index in
                            //
                            ////                            NavigationLink(destination: MessageDetailView(recipient: messageContent.chats[index].member.name, messageDetial: MessageDetail(chatId: messageContent.chats[index].dialogId))){
                            ////                                MessageRowView(chat: messageContent.chats[index], isActive: $isActive, chatIndex: $chatIndex, myIndex: index)
                            ////                            }
                            //                            MessageRowView(chat: messageContent.chats[index], isActive: $isActive, chatIndex: $chatIndex, myIndex: index)
                            //                        }
                            //                        ForEach(messageContent.chats) { chat in
                            ////                            NavigationLink(destination: MessageDetailView(recipient: messageContent.chats[getIndex(chat: chat)].member.name, messageDetial: MessageDetail(chatId: messageContent.chats[getIndex(chat: chat)].dialogId))) {
                            ////                                MessageRowView(chat: messageContent.chats[getIndex(chat: chat)])
                            ////                            }
                            //                            MessageRowView(chat: $messageContent.chats[getIndex(chat: chat)], isActive: $isActive, chatIndex: $chatIndex, myIndex: getIndex(chat: chat))
                            //                        }
                            
                            ForEach(messageContent.chats.indices, id: \.self) { index in
                                ZStack{
                                    
                                    LinearGradient(gradient: .init(colors: [Color("deleteLightRed"),Color("deleteRed")]), startPoint: .leading, endPoint: .trailing)
                                    
                                    HStack{
                                        
                                        Spacer()
                                        
                                        Button {
                                            print("删除")
                                            deleteChat(messageContent.chats[index])
                                            
                                        } label: {
                                            Text("删除")
                                                .font(.title3)
                                                .foregroundColor(.white)
                                                .padding(.trailing, 22.5)
                                        }
                                    }
                                    
                                    MessageRowView(chat: messageContent.chats[index])
                                        .offset(x: messageContent.chats[index].offset)
                                        .gesture(DragGesture().onChanged({ value in
                                            if value.translation.width < 0{
                                                
                                                if messageContent.chats[index].isSwiped{
                                                    messageContent.chats[index].offset = value.translation.width - 90
                                                }else{
                                                    messageContent.chats[index].offset = value.translation.width
                                                }
                                            }
                                        }).onEnded({ value in
                                            if value.translation.width < 0 {
                                                if -value.translation.width > UIScreen.main.bounds.width / 2{
                                                    messageContent.chats[index].offset = -1000
                                                    deleteChat(messageContent.chats[index])
                                                }
                                                else if -messageContent.chats[index].offset > 50 {
                                                    withAnimation(.easeOut){
                                                        closeSwiped()
                                                        messageContent.chats[index].isSwiped = true
                                                        messageContent.chats[index].offset = -90
                                                    }
                                                    
                                                }else{
                                                    withAnimation(.easeOut){
                                                        closeSwiped()
                                                        messageContent.chats[index].isSwiped = false
                                                        messageContent.chats[index].offset = 0
                                                    }
                                                    
                                                }
                                            }else{
                                                withAnimation(.easeOut){
                                                    closeSwiped()
                                                    messageContent.chats[index].isSwiped = false
                                                    messageContent.chats[index].offset = 0
                                                }
                                                
                                            }
                                        }))
                                        .onTapGesture(perform: {
                                            if messageContent.chats[index].isSwiped {
                                                withAnimation(.easeOut){
                                                    messageContent.chats[index].offset = 0
                                                    messageContent.chats[index].isSwiped = false
                                                }
                                            }else{
                                                closeSwiped()
                                                chatIndex = index
                                                isActive = true
                                            }
                                        })
                                    
                                }
                            }
                            
                            //                        ForEach(messageContent.chats) { chat in
                            //
                            //                            let index = getIndex(chat: chat)
                            //
                            //                            ZStack{
                            //
                            //                                LinearGradient(gradient: .init(colors: [Color("deleteLightRed"),Color("deleteRed")]), startPoint: .leading, endPoint: .trailing)
                            //
                            //                                HStack{
                            //
                            //                                    Spacer()
                            //
                            //                                    Button {
                            //                                       print("删除")
                            //
                            //                                    } label: {
                            //                                        Text("删除")
                            //                                            .font(.title3)
                            //                                            .foregroundColor(.white)
                            //                                            .padding(.trailing, 22.5)
                            //                                    }
                            //                                }
                            //
                            //                                MessageRowView(chat: messageContent.chats[index])
                            //                                    .offset(x: messageContent.chats[index].offset)
                            //                                    .gesture(DragGesture().onChanged({ value in
                            //                                        if value.translation.width < 0{
                            //
                            //                                            if messageContent.chats[index].isSwiped{
                            //                                                messageContent.chats[index].offset = value.translation.width - 90
                            //                                            }else{
                            //                                                messageContent.chats[index].offset = value.translation.width
                            //                                            }
                            //                                        }
                            //                                    }).onEnded({ value in
                            //                                        withAnimation(.easeOut){
                            //                                            if value.translation.width < 0 {
                            //                                                if -value.translation.width > UIScreen.main.bounds.width / 2{
                            //                                                    messageContent.chats[index].offset = -1000
                            //                                                    messageContent.chats[index].isSwiped = false
                            //                                                }
                            //                                                else if -messageContent.chats[index].offset > 50 {
                            //                                                    closeSwiped()
                            //                                                    messageContent.chats[index].isSwiped = true
                            //                                                    messageContent.chats[index].offset = -90
                            //                                                }else{
                            //                                                    closeSwiped()
                            //                                                    messageContent.chats[index].isSwiped = false
                            //                                                    messageContent.chats[index].offset = 0
                            //                                                }
                            //                                            }else{
                            //                                                closeSwiped()
                            //                                                messageContent.chats[index].isSwiped = false
                            //                                                messageContent.chats[index].offset = 0
                            //                                            }
                            //                                        }
                            //                                    }))
                            //                                    .onTapGesture(perform: {
                            //                                        if messageContent.chats[index].isSwiped {
                            //                                            withAnimation(.easeOut){
                            //                                                messageContent.chats[index].offset = 0
                            //                                                messageContent.chats[index].isSwiped = false
                            //                                            }
                            //                                        }else{
                            //                                            chatIndex = index
                            //                                            isActive = true
                            //                                        }
                            //                                    })
                            //
                            //                            }
                            //
                            //                        }
                        }
                    }.padding(.top,50)
                }
                else{
                    VStack{
                        Spacer()
                        Text("您似乎还没有登录")
                        
                        Button {
                            tabSelection = 3
                        } label: {
                            Text("前往登录")
                            
                        }
                        
                        Spacer()
                    }
                    .frame(minWidth: /*@START_MENU_TOKEN@*/0/*@END_MENU_TOKEN@*/,maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, minHeight: /*@START_MENU_TOKEN@*/0/*@END_MENU_TOKEN@*/, maxHeight: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                    
                }
            }
            .onAppear {
                
                if let _ = appModel.user{
                    if !messageContent.loadingMessage{
                        messageContent.fetchMessage()
                    }
                }
            }
            .onDisappear{
                closeSwiped()
            }
            
            ZStack{
                
                Color("SystemColor").frame(width: UIScreen.main.bounds.size.width, height: 50 + UIApplication.shared.windows[0].safeAreaInsets.top)
                    .ignoresSafeArea(.all, edges: .top)
                
                VStack(spacing: 0){
                    HStack{
                        
                        Spacer()
                        
                        Text("Messages")
                            .font(.system(size: 20.0))
                            .foregroundColor(.black)
                            .lineLimit(1)
                            .frame(minWidth: 0, maxWidth: 150)
                        
                        Spacer()
                        
                    }.frame(width: UIScreen.main.bounds.size.width, height: 50)
                    
                }
            }.frame(width: UIScreen.main.bounds.size.width, height: 50)
            
        }
        .navigationTitle("Messages")
        .navigationBarHidden(true)
        
        
    }
}

extension MessagePage{
    
    func getIndex(chat: Chat) -> Int {
        return messageContent.chats.firstIndex { (chat1) -> Bool in
            return chat.id == chat1.id
        } ?? 0
    }
    
    func closeSwiped() {
        for index in messageContent.chats.indices{
            
            if messageContent.chats[index].isSwiped{
                withAnimation(.easeIn){
                    messageContent.chats[index].offset = .zero
                    messageContent.chats[index].isSwiped = false
                }
                
            }
        }
    }
    
    func deleteChat(_ chat: Chat) {
        
        messageContent.isDeletingMessage = true
        
        messageContent.deleteDialog(dialogId: chat.dialogId)
        
        messageContent.chats.removeAll {(chat1) -> Bool in
            return chat.dialogId == chat1.dialogId
        }
        
        
    }
    
    struct SystemMessage: View {
        var body: some View{
            VStack{
                HStack{
                    Image(systemName: "exclamationmark.bubble.fill")
                        .resizable()
                        .frame(width: 42, height: 42)
                        .foregroundColor(.primary)
                    
                    
                    Text("系统消息")
                        .font(.system(size: 21, weight: .regular))
                        .foregroundColor(.primary)
                        .padding(.leading, 7.5)
                    
                    Spacer()
                    
                }.padding(EdgeInsets(top: 12, leading: 16, bottom: 12, trailing: 16))
                
                Divider()
            }.background(Color.white)
        }
    }
    
}
