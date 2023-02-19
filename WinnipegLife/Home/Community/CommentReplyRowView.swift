//
//  CommentReplyRowView.swift
//  WinnipegLife
//
//  Created by changming wang on 7/2/21.
//

import SwiftUI
import SDWebImageSwiftUI

struct CommentReplyMainRowView: View {
    
    @EnvironmentObject var appModel: AppModel
    
    @Environment(\.presentationMode) var presentation
    
    let columns = Array(repeating: GridItem(.flexible()), count: 3)
    
    @EnvironmentObject var viewer: ImageViewer
    
    let model: CommentsModel
    
    @State var chatActive: Bool = false
    
    @Binding var imageLinks:[String]
    
    @Binding var showSendCommentView:Bool
    
    @Binding var noLoginAlert:Bool
    
    var body: some View {
        HStack(alignment: .top){
            VStack{
                if model.userInfo.userAvatar.isEmpty{
                    if let user = appModel.user{
                        NavigationLink(destination: CommunityChatView(recipient: model.userInfo.userName,messageDetial: CommunityMessage(userId: model.userId)), isActive: $chatActive){
                            Button(action: {
                                if user.id != model.userId{
                                    chatActive = true
                                }
                            }) {
                                Image("defaultusericon")
                                    .resizable()
                                    .frame(width: 40, height: 40)
                                    .clipShape(Circle())
                                    .padding([.top, .leading], 10)
                            }
                        }
                    }else{
                        Image("defaultusericon")
                            .resizable()
                            .frame(width: 40, height: 40)
                            .clipShape(Circle())
                            .padding([.top, .leading], 10)
                    }
                }else{
                    if let user = appModel.user{
                        NavigationLink(destination: CommunityChatView(recipient: model.userInfo.userName,messageDetial: CommunityMessage(userId: model.userId)), isActive: $chatActive){
                            Button(action: {
                                if user.id != model.userId{
                                    chatActive = true
                                }
                            }) {
                                WebImage(url: URL(string: model.userInfo.userAvatar))
                                    .resizable()
                                    .frame(width: 40, height: 40)
                                    .clipShape(Circle())
                                    .padding([.top, .leading], 10)
                            }
                        }
                    }else{
                        WebImage(url: URL(string: model.userInfo.userAvatar))
                            .resizable()
                            .frame(width: 40, height: 40)
                            .clipShape(Circle())
                            .padding([.top, .leading], 10)
                    }

                }

                Spacer()
            }
            
            VStack(alignment: .leading){
                //这里是用户名
                HStack(alignment:.top){
                    Text(model.userInfo.userName)
                        .frame(alignment: .leading)
                        .padding(.horizontal, 10)
                        .foregroundColor(.black)
                    
                    Spacer()
                    
                    Image(systemName: "bubble.middle.bottom")
                        .foregroundColor(.secondary)
                        .padding(.trailing, 20)
                        .onTapGesture {
                            
                            guard let _ = appModel.user else {
                                noLoginAlert = true
                                return
                            }
                            
                            withAnimation(.easeIn) {
                                showSendCommentView = true
                            }
                            
                        }
                }
                .padding(.bottom, 10)
                .padding(.top, 5)
                
                Text(model.createdAt)
                    .foregroundColor(.secondary)
                    .font(.footnote)
                    .padding(.bottom, 10)
                    .padding(.horizontal, 10)
                
                VStack(alignment: .leading){
                    Text(model.parseContentHtml)
                        .fixedSize(horizontal: false, vertical: true)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal, 10)
                }.padding([.bottom, .trailing], 10)
                
                if model.imageUrls.count > 0{
                    
                    LazyVGrid(columns: columns, alignment: .leading){
                        
                        ForEach(model.imageUrls.indices, id: \.self){ index in
                            
                            ZStack{
                                if index <= 2{
                                    
                                    WebImage(url: URL(string: model.imageUrls[index].thumbUrl))
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(width: (getRecct().width - 90) / 3, height: 120)
                                        .cornerRadius(12)
                                        .onTapGesture(){
                                            withAnimation(.easeInOut) {
                                                UIScrollView.appearance().bounces = false
                                                var urls:[String] = []
                                                for item in model.imageUrls{
                                                    urls.append(item.url)
                                                }
                                                imageLinks = urls
                                                viewer.showImageViewer.toggle()
                                                viewer.imageIndex = index
                                            }

                                        }
                                }
                                
                                if model.imageUrls.count > 3 && index == 2{
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(Color.black.opacity(0.3))
                                        .onTapGesture(){
                                            withAnimation(.easeInOut) {
                                                var urls:[String] = []
                                                for item in model.imageUrls{
                                                    urls.append(item.url)
                                                }
                                                imageLinks = urls
                                                viewer.showImageViewer.toggle()
                                                viewer.imageIndex = index
                                            }

                                        }
                                    
                                    let remainingImages = model.imageUrls.count - 3
                                    
                                    Text("+\(remainingImages)")
                                        .font(.title)
                                        .fontWeight(.heavy)
                                        .foregroundColor(.white)
                                    
                                }
                            }
                        }
                        
                    }.padding(.horizontal, 10)
                    
                }
                
                Button(action: {
                    presentation.wrappedValue.dismiss()
                }){
                    Text("查看原帖")
                        .foregroundColor(.blue)
                        .padding(.horizontal, 10)
                }
                
            }
        }
    }
}
//
//struct CommentReplyRowView_Previews: PreviewProvider {
//    static var previews: some View {
//        CommentReplyRowView()
//    }
//}

struct CommentReplyRowView : View{
    
    @EnvironmentObject var appModel: AppModel
    
    let columns = Array(repeating: GridItem(.flexible()), count: 3)
    
    @EnvironmentObject var viewer: ImageViewer
    
    let model: CommentsModel
    
    @State var chatActive: Bool = false
    
    @Binding var imageLinks:[String]
    
    var body: some View{
        HStack(alignment: .top){
            VStack{
                if model.userInfo.userAvatar.isEmpty{
                    if let user = appModel.user{
                        NavigationLink(destination: CommunityChatView(recipient: model.userInfo.userName,messageDetial: CommunityMessage(userId: model.userId)), isActive: $chatActive){
                            Button(action: {
                                if user.id != model.userId{
                                    chatActive = true
                                }
                            }) {
                                Image("defaultusericon")
                                    .resizable()
                                    .frame(width: 25, height: 25)
                                    .clipShape(Circle())
                                    .padding([.top, .leading], 10)
                            }
                        }
                    }else{
                        Image("defaultusericon")
                            .resizable()
                            .frame(width: 25, height: 25)
                            .clipShape(Circle())
                            .padding([.top, .leading], 10)
                    }
                }else{
                    if let user = appModel.user{
                        NavigationLink(destination: CommunityChatView(recipient: model.userInfo.userName,messageDetial: CommunityMessage(userId: model.userId)), isActive: $chatActive){
                            Button(action: {
                                if user.id != model.userId{
                                    chatActive = true
                                }
                            }) {
                                WebImage(url: URL(string: model.userInfo.userAvatar))
                                    .resizable()
                                    .frame(width: 25, height: 25)
                                    .clipShape(Circle())
                                    .padding([.top, .leading], 10)
                            }
                        }
                    }else{
                        WebImage(url: URL(string: model.userInfo.userAvatar))
                            .resizable()
                            .frame(width: 25, height: 25)
                            .clipShape(Circle())
                            .padding([.top, .leading], 10)
                    }

                }

                Spacer()
            }
            
            VStack(alignment: .leading){
                //这里是用户名
                Text(model.userInfo.userName)
                    .frame(alignment: .leading)
                    .padding(.horizontal, 10)
                    .foregroundColor(.black)
                    .padding(.bottom, 10)
                    .padding(.top, 5)
                
                Text(model.createdAt)
                    .foregroundColor(.secondary)
                    .font(.footnote)
                    .padding(.bottom, 10)
                    .padding(.horizontal, 10)
                
                VStack(alignment: .leading){
                    Text(model.parseContentHtml)
                        .fixedSize(horizontal: false, vertical: true)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal, 10)
                }.padding([.bottom, .trailing], 10)
                
                if model.imageUrls.count > 0{
                    
                    LazyVGrid(columns: columns, alignment: .leading){
                        
                        ForEach(model.imageUrls.indices, id: \.self){ index in
                            
                            ZStack{
                                if index <= 2{
                                    
                                    WebImage(url: URL(string: model.imageUrls[index].thumbUrl))
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(width: (getRecct().width - 70) / 3, height: 100)
                                        .cornerRadius(12)
                                        .onTapGesture(){
                                            withAnimation(.easeInOut) {
                                                UIScrollView.appearance().bounces = false
                                                var urls:[String] = []
                                                for item in model.imageUrls{
                                                    urls.append(item.url)
                                                }
                                                imageLinks = urls
                                                viewer.showImageViewer.toggle()
                                                viewer.imageIndex = index
                                            }

                                        }
                                }
                                
                                if model.imageUrls.count > 3 && index == 2{
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(Color.black.opacity(0.3))
                                        .onTapGesture(){
                                            withAnimation(.easeInOut) {
                                                UIScrollView.appearance().bounces = false
                                                var urls:[String] = []
                                                for item in model.imageUrls{
                                                    urls.append(item.url)
                                                }
                                                imageLinks = urls
                                                viewer.showImageViewer.toggle()
                                                viewer.imageIndex = index
                                            }

                                        }
                                    
                                    let remainingImages = model.imageUrls.count - 3
                                    
                                    Text("+\(remainingImages)")
                                        .font(.title)
                                        .fontWeight(.heavy)
                                        .foregroundColor(.white)
                                    
                                }
                            }
                        }
                        
                    }.padding(.horizontal, 10)
                    
                }

                
                Divider()
            }
        }.background(Color.black.opacity(0.03))
    }
    
}
