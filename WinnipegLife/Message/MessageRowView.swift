//
//  MessageRow.swift
//  WinnipegLife
//
//  Created by changming wang on 7/12/21.
//

import SwiftUI
import SDWebImageSwiftUI

//struct MessageRowView: View {
//
//    @EnvironmentObject var messageContent: Message
//
////    @Binding var chat:Chat
//
//    var chat:Chat
//
//    @Binding var isActive:Bool
//
//    @Binding var chatIndex: Int
//
//    let myIndex:Int
//
//    @State var offset:CGFloat = 0
//
//    @State var isSwiped:Bool = false
//
//    var body: some View {
//        ZStack{
//
//            LinearGradient(gradient: .init(colors: [Color("deleteLightRed"),Color("deleteRed")]), startPoint: .leading, endPoint: .trailing)
//
//            HStack{
//
//                Spacer()
//
//                Button {
//                    messageContent.deleteDialog(dialogId: chat.dialogId)
//                    isSwiped = false
//                } label: {
//                    Text("删除")
//                        .font(.title3)
//                        .foregroundColor(.white)
//                        .padding(.trailing, 22.5)
//                }
//
//
//            }
//
//            VStack{
//                HStack(spacing:12){
//                    if chat.member.icon.isEmpty{
//                        Image("defaultusericon")
//                            .renderingMode(.original)
//                            .resizable()
//                            .frame(width: 48, height: 48)
//                            .cornerRadius(8)
//                            .overlay(
//                                ZStack{
//                                    if chat.isUserSender{
//                                        if chat.senderReadTime.isEmpty{
//                                            Circle()
//                                                .fill(Color.red)
//                                                .frame(width: 10, height: 10)
//                                                .offset(x: 3, y: -3)
//                                        }
//                                    }else{
//                                        if chat.recipientReadTime.isEmpty{
//                                            Circle()
//                                                .fill(Color.red)
//                                                .frame(width: 10, height: 10)
//                                                .offset(x: 3, y: -3)
//                                        }
//                                    }
//                                },
//                                alignment: .topTrailing
//                            )
//                    }else{
//
//                        WebImage(url: URL(string: chat.member.icon))
//                            .resizable()
//                            .frame(width: 48, height: 48)
//                            .cornerRadius(8)
//                            .overlay(
//                                ZStack{
//                                    if chat.isUserSender{
//                                        if chat.senderReadTime.isEmpty{
//                                            Circle()
//                                                .fill(Color.red)
//                                                .frame(width: 10, height: 10)
//                                                .offset(x: 3, y: -3)
//                                        }
//                                    }else{
//                                        if chat.recipientReadTime.isEmpty{
//                                            Circle()
//                                                .fill(Color.red)
//                                                .frame(width: 10, height: 10)
//                                                .offset(x: 3, y: -3)
//                                        }
//                                    }
//                                },
//                                alignment: .topTrailing
//                            )
//                    }
//
//                    VStack(alignment: .leading, spacing: 5){
//                        HStack(alignment:.top){
//                            Text(chat.member.name)
//                                .font(.system(size: 16, weight: .regular))
//                                .foregroundColor(.primary)
//                            Spacer()
//                            Text(chat.time)
//                                .font(.system(size: 10))
//                                .foregroundColor(.secondary)
//                        }
//
//                        Text(chat.desc)
//                            .lineLimit(1)
//                            .font(.system(size: 15))
//                            .foregroundColor(.secondary)
//                    }
//
//                }
//                .padding(EdgeInsets(top: 12, leading: 16, bottom: 12, trailing: 16))
//
//                Divider().padding(.leading, 75)
//            }
//            .background(Color.white)
//            .offset(x: offset)
//            .gesture(DragGesture().onChanged(onChange(value:)).onEnded(onEnd(value:)))
//            .onTapGesture {
//                if isSwiped{
//                    withAnimation(.easeOut){
//                        offset = 0
//                        isSwiped = false
//                    }
//                }else{
//                    chatIndex = myIndex
//                    isActive = true
//                }
//
//            }
//        }
//    }
//}


struct MessageRowView: View {
    
    
    let chat:Chat
    
    var body: some View {
        VStack{
            HStack(spacing:12){
                if chat.member.icon.isEmpty{
                    Image("defaultusericon")
                        .renderingMode(.original)
                        .resizable()
                        .frame(width: 48, height: 48)
                        .cornerRadius(8)
                        .overlay(
                            ZStack{
                                if chat.isUserSender{
                                    if chat.senderReadTime.isEmpty{
                                        Circle()
                                            .fill(Color.red)
                                            .frame(width: 10, height: 10)
                                            .offset(x: 3, y: -3)
                                    }
                                }else{
                                    if chat.recipientReadTime.isEmpty{
                                        Circle()
                                            .fill(Color.red)
                                            .frame(width: 10, height: 10)
                                            .offset(x: 3, y: -3)
                                    }
                                }
                            },
                            alignment: .topTrailing
                        )
                }else{
                    
                    WebImage(url: URL(string: chat.member.icon))
                        .resizable()
                        .frame(width: 48, height: 48)
                        .cornerRadius(8)
                        .overlay(
                            ZStack{
                                if chat.isUserSender{
                                    if chat.senderReadTime.isEmpty{
                                        Circle()
                                            .fill(Color.red)
                                            .frame(width: 10, height: 10)
                                            .offset(x: 3, y: -3)
                                    }
                                }else{
                                    if chat.recipientReadTime.isEmpty{
                                        Circle()
                                            .fill(Color.red)
                                            .frame(width: 10, height: 10)
                                            .offset(x: 3, y: -3)
                                    }
                                }
                            },
                            alignment: .topTrailing
                        )
                }
                
                VStack(alignment: .leading, spacing: 5){
                    HStack(alignment:.top){
                        Text(chat.member.name)
                            .font(.system(size: 16, weight: .regular))
                            .foregroundColor(.primary)
                        Spacer()
                        Text(chat.time)
                            .font(.system(size: 10))
                            .foregroundColor(.secondary)
                    }
                    
                    Text(chat.desc)
                        .lineLimit(1)
                        .font(.system(size: 15))
                        .foregroundColor(.secondary)
                }
                
            }
            .padding(EdgeInsets(top: 12, leading: 16, bottom: 12, trailing: 16))
            
            Divider().padding(.leading, 75)
        }
        .background(Color.white)
    }
}

//extension MessageRowView{
//
//    func onChange(value: DragGesture.Value){
//        if value.translation.width < 0{
//            if isSwiped{
//                offset = value.translation.width - 90
//            }
//            else{
//                offset = value.translation.width
//            }
//        }
//    }
//
//    func onEnd(value: DragGesture.Value) {
//        withAnimation(.easeOut){
//            if value.translation.width < 0 {
//                if -value.translation.width > UIScreen.main.bounds.width / 2{
//                    offset = -1000
//                    messageContent.deleteDialog(dialogId: chat.dialogId)
//                    isSwiped = false
//                }
//                else if -offset > 50 {
//
//                    isSwiped = true
//                    offset = -90
//                }
//                else{
//                    isSwiped = false
//                    offset = 0
//                }
//            }else{
//                isSwiped = false
//                offset = 0
//            }
//        }
//
//    }
//
//}
