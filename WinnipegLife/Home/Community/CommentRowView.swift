//
//  CommentRowView.swift
//  WinnipegLife
//
//  Created by changming wang on 7/2/21.
//

import SwiftUI
import SDWebImageSwiftUI

struct CommentRowView: View{
    
    @AppStorage("appLanguage") var appLanguage: String = Locale.current.languageCode ?? "zh"
    
    @EnvironmentObject var appModel: AppModel
    
    @State var chatActive: Bool = false
    
    @Binding var model: CommentsModel
    
    let columns = Array(repeating: GridItem(.flexible()), count: 3)
    
    @Binding var imageLinks:[String]
    
    @Binding var replyToWho: String
    
    @Binding var replyPid:String
    
    @Binding var showSendCommentView:Bool
    
    @Binding var noLoginAlert:Bool
    
    @EnvironmentObject var viewer: ImageViewer
    
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
                    .padding(.top, 12.5)
                    .frame(alignment: .leading)
                    .padding(.bottom, 10)
                    .padding(.horizontal, 10)
                    .foregroundColor(.black)
                
                //这里是评论内容
                VStack(alignment: .leading){
                    Text(model.parseContentHtml)
                        .fixedSize(horizontal: false, vertical: true)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal, 10)
                }.padding([.bottom, .trailing], 10)
                
                //这里是更多评论
                if model.repliesCount > 0{
                    NavigationLink(destination: CommentReplyView(model: $model,content: CommentReplyModel(pid: model.pid))){
                        
                        NavigationLink(destination: EmptyView()) {
                            EmptyView()
                        }
                        if appLanguage == "zh"{
                            Text("共\(model.repliesCount)条评论 >")
                                .font(.subheadline)
                                .foregroundColor(.blue)
                                .padding(.leading, 10)
                                .padding(.bottom, 10)
                        }else{
                            Text("\(model.repliesCount) more comment(s)")
                                .font(.subheadline)
                                .foregroundColor(.blue)
                                .padding(.leading, 10)
                                .padding(.bottom, 10)
                        }

                        
                    }
                    .frame(alignment: .leading)
                }
                
                if model.imageUrls.count > 0{
                    
                    LazyVGrid(columns: columns, alignment: .leading){
                        
                        ForEach(model.imageUrls.indices, id: \.self){ index in
                            
                            ZStack{
                                if index <= 2{
                                    
                                    WebImage(url: URL(string: model.imageUrls[index].thumbUrl))
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(width: (getRecct().width - 70) / 3, height: 120)
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

                
                HStack{
                    Text(model.createdAt)
                        .foregroundColor(.secondary)
                        .padding(.horizontal, 10)
                    Spacer()
                    
                    Image(systemName: "bubble.middle.bottom")
                        .foregroundColor(.secondary)
                        .padding(.trailing, 20)
                        .onTapGesture {
                            
                            guard let _ = appModel.user else {
                                noLoginAlert = true
                                return
                            }
                            
                            replyToWho = model.userInfo.userName
                            replyPid = model.pid
                            
                            withAnimation(.easeIn) {
                                showSendCommentView = true
                            }
                            
                        }
                }
                Divider()
            }
            
        }
    }
}


//struct CommentRowView_Previews: PreviewProvider {
//    static var previews: some View {
//        CommentRowView()
//            .previewLayout(.sizeThatFits)
//    }
//}
