//
//  CommunityDetailView.swift
//  WinnipegLife
//
//  Created by changming wang on 6/27/21.
//

import SwiftUI
import SwiftUIX
import SDWebImageSwiftUI
import ZLPhotoBrowser

struct CommunityDetailView: View {
    
    
    
    @Environment(\.presentationMode) var presentation
    
    @EnvironmentObject var appModel: AppModel
    
    @StateObject var content: DetailCommunityViewModel
    
    @StateObject var viewer = ImageViewer()
    
    @State var imageLinks:[String] = []
    
//    @State var showSendCommentView:Bool = false
    
    @State var noLoginAlert:Bool = false
    
    @State var isPhotoLibraryOpen:Bool = false
    
    @State var replyToWho: String = ""
    
    @State var replyPid:String = ""
    
    @State var chatActive: Bool = false
    
    let title:String
    
    let columns = Array(repeating: GridItem(.flexible()), count: 3)
    
    var body: some View {
        ZStack{
            
            ZStack(alignment: .top){
                VStack{
                    if !content.loaded{
                        SimpleRefreshingView()
                            .padding()
                    }else{
                        VStack(spacing: 0){
                            ScrollView{
                                VStack{
                                    VStack{
                                        Text(content.viewContent.viewTitle)
                                            .font(.largeTitle)
                                            .fontWeight(.bold)
                                            .padding(.top, 10)

                                        HStack{
                                            if content.viewContent.userAvatar.isEmpty{
                                                if let user = appModel.user{
                                                    NavigationLink(destination: CommunityChatView(recipient: content.viewContent.userName,messageDetial: CommunityMessage(userId: content.viewContent.userId)), isActive: $chatActive){
                                                        Button(action: {
                                                            if user.id != content.viewContent.userId{
                                                                chatActive = true
                                                            }
                                                        }) {
                                                            Image("defaultusericon")
                                                                .resizable()
                                                                .frame(width: 25, height: 25)
                                                                .clipShape(Circle())
                                                                .padding(.leading, 10)
                                                        }
                                                    }
                                                }else{
                                                    Image("defaultusericon")
                                                        .resizable()
                                                        .frame(width: 25, height: 25)
                                                        .clipShape(Circle())
                                                        .padding(.leading, 10)
                                                }


                                            }else{
                                                if let user = appModel.user{
                                                    NavigationLink(destination: CommunityChatView(recipient: content.viewContent.userName,messageDetial: CommunityMessage(userId: content.viewContent.userId)), isActive: $chatActive){
                                                        Button(action: {
                                                            if user.id != content.viewContent.userId{
                                                                chatActive = true
                                                            }
                                                        }) {
                                                            WebImage(url: URL(string: content.viewContent.userAvatar))
                                                                .resizable()
                                                                .indicator(Indicator.progress)
                                                                .frame(width: 25, height: 25)
                                                                .clipShape(Circle())
                                                                .padding(.leading, 10)
                                                        }
                                                    }
                                                }else{
                                                    WebImage(url: URL(string: content.viewContent.userAvatar))
                                                        .resizable()
                                                        .indicator(Indicator.progress)
                                                        .frame(width: 25, height: 25)
                                                        .clipShape(Circle())
                                                        .padding(.leading, 10)
                                                }

                                            }

                                            Text(content.viewContent.userName)
                                                .foregroundColor(.secondary)
                                                .padding(.leading, 10)

                                            Text(content.viewContent.createdAt)
                                                .foregroundColor(.secondary)
                                                .padding(.leading, 10)

                                            Spacer()
                                        }
                                    }

                                    VStack(alignment: .leading){
                                        ForEach(0..<content.viewContent.htmlContent.count, id: \.self){ index in
                                            let data = content.viewContent.htmlContent[index]
                                            let key = Array(data.keys)[0]

                                            if key == "p" {
                                                Text(data["p"]!)
                                                    .fixedSize(horizontal: false, vertical: true)
                                                    .frame(maxWidth: .infinity, alignment: .leading)
                                                    .padding(.horizontal, 10)

                                            }else if key == "img" {
                                                let url = data["img"]!

                                                WebImage(url: URL(string: url))
                                                    .resizable()
                                                    .indicator(Indicator.progress)
                                                    .aspectRatio(contentMode: .fill)
                                                    .frame(width: UIScreen.main.bounds.size.width - 20)
                                                    .padding(10)
                                                    .onTapGesture(){
                                                        withAnimation(.easeInOut) {
                                                            UIScrollView.appearance().bounces = false
                                                            imageLinks = content.viewContent.contentImageUrls
                                                            viewer.showImageViewer.toggle()
                                                            viewer.imageIndex = content.contentImageIndex[index]
                                                        }

                                                    }

                                            }
                                        }
                                    }
                                    .frame(width: UIScreen.main.bounds.size.width)
                                    .padding(.top, 20)
                                    
                                    
                                    if content.viewContent.attachmentsImageUrls.count > 0 {
                                        LazyVGrid(columns: columns) {
                                            ForEach(0..<content.viewContent.attachmentsImageThumbUrls.count, id: \.self){ index in
                                                WebImage(url: URL(string: content.viewContent.attachmentsImageThumbUrls[index]))
                                                    .resizable()
                                                    .aspectRatio(contentMode: .fill)
                                                    .onTapGesture(){
                                                        withAnimation(.easeInOut) {
                                                            UIScrollView.appearance().bounces = false
                                                            imageLinks = content.viewContent.attachmentsImageUrls
                                                            viewer.showImageViewer.toggle()
                                                            viewer.imageIndex = index
                                                        }

                                                    }
                                            }
                                        }.padding(.horizontal, 10)
                                    }
                                    


                                    CommentListView(commentCount: content.viewContent.commentCount, models: $content.comments, imageLinks: $imageLinks, replyToWho: $replyToWho, replyPid: $replyPid,showSendCommentView: $content.showSendCommentView, noLoginAlert: $noLoginAlert)
                                        .padding(.top, 20)

                                    if content.viewContent.commentCount > 0{
                                        RefreshFooter(refreshing: $content.loadingComments, action: {
                                            content.fetchMoreComments()
                                        }) {
                                            if content.noMoreData {
                                                Text("没有更多评论了")
                                                    .foregroundColor(.secondary)
                                                    .padding()

                                            } else {
                                                SimpleRefreshingView()
                                                    .padding()
                                            }
                                        }
                                        .noMore(content.noMoreData)
                                        .preload(offset: 50)
                                    }
                                }

                            }
                            .enableRefresh()
                            
                        }
                        .padding(.top, 50)
                        .padding(.bottom, 76 - UIApplication.shared.windows[0].safeAreaInsets.bottom)
                        
                    }
                }
                
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
                            
                            Text(title)
                                .font(.system(size: 20.0))
                                .foregroundColor(.black)
                                .lineLimit(1)
                                .frame(minWidth: 0, maxWidth: 150)
                            
                            Spacer()
                            
                        }.frame(width: UIScreen.main.bounds.size.width, height: 50)
                        
                    }
                }.frame(width: UIScreen.main.bounds.size.width, height: 50)
            }
            
            VStack{
                Spacer()
                SendCommentView(replyToWho: $replyToWho, replyPid: $replyPid,showSendCommentView: $content.showSendCommentView, noLoginAlert: $noLoginAlert)
            }.edgesIgnoringSafeArea(.bottom)
            
            if content.showSendCommentView{
                SendCommentDetailView(replyToWho: $replyToWho, replyPid: $replyPid,showSendCommentView: $content.showSendCommentView, isPhotoLibraryOpen: $isPhotoLibraryOpen)
            }
            
            
        }
        .present(isPresented: self.$noLoginAlert, type: .alert, animation: Animation.easeInOut, autohideDuration: 1.5, closeOnTap: false) {
            self.createAlertView(message: "请先登录后再评论")
        }
        .overlay(
            ImageView(urls: imageLinks)
        )
        .environmentObject(viewer)
        .environmentObject(content)
        .onAppear(perform: {
            content.fetchData()
            //            UIScrollView.appearance().bounces = false
            
            if isPhotoLibraryOpen{
                isPhotoLibraryOpen = false
            }
        })
        .onDisappear(){
            if !isPhotoLibraryOpen{
                content.cleanReplyData()
            }
        }
        .navigationBarTitle(title)
        .navigationBarHidden(true)
        
    }
}

//struct CommunityDetailView_Previews: PreviewProvider {
//    static var previews: some View {
//        CommunityDetailView()
//    }
//}

extension CommunityDetailView{
    
    func createAlertView(message:LocalizedStringKey = "") -> some View {
        
        
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
    
    struct SendCommentView: View {
        
        @EnvironmentObject var appModel: AppModel
        
        @Binding var replyToWho: String
        
        @Binding var replyPid: String
        
        @Binding var showSendCommentView:Bool
        
        @Binding var noLoginAlert:Bool
        
        var body: some View{
            
            VStack(spacing: 0) {
                Divider()
                
                ZStack {
                    Color("SendViewBg")
                    
                    VStack {
                        
                        HStack{
                            HStack(){
                                Image(systemName: "highlighter")
                                Text("说点什么吧..")
                                Spacer()
                            }
                            .padding(.horizontal, 15)
                            .frame(maxWidth: .infinity)
                            .frame(height: 33)
                            .background(Color.white)
                            .foregroundColor(Color.gray.opacity(0.9))
                            .clipShape(Capsule())
                            .onTapGesture {
                                
                                guard let _ = appModel.user else {
                                    noLoginAlert = true
                                    return
                                }
                                
                                replyToWho = "楼主"
                                
                                replyPid = ""
                                
                                withAnimation(.easeIn) {
                                    showSendCommentView = true
                                }
                                
                            }
                            
                            Spacer()
                            
                        }
                        .frame(height: 56)
                        .padding(.horizontal, 12)
                        
                        
                        Spacer()
                    }
                    
                }
                
            }.frame(height: 76)
            
        }
    }
    
    struct SendCommentDetailView:View {
        
        @AppStorage("appLanguage") var appLanguage: String = Locale.current.languageCode ?? "zh"
        
        @EnvironmentObject var content: DetailCommunityViewModel
        
        @Binding var replyToWho:String
        
        @Binding var replyPid: String
        
        @Binding var showSendCommentView:Bool
        
        @Binding var isPhotoLibraryOpen:Bool
        
        @ObservedObject var keyboardHeightHelper = KeyboardHeightHelper()
        
        @State var bottomHeight:CGFloat = .zero
        
        @State var showAddImage:Bool = false
        
        let columns = Array(repeating: GridItem(.flexible()), count: 4)
        
        var body: some View{
            GeometryReader { proxy in
                
                ZStack(alignment: .bottom){
                    
                    Color.black.opacity(0.3)
                        .onTapGesture {
                            withAnimation(.easeOut) {
                                showSendCommentView = false
                            }
                            UIApplication.shared.endEditing()
                        }
                    
                    ZStack {
                        Color.white
                        
                        VStack(spacing: 0) {
                            
                            HStack(spacing: 0){
                                Text("回复")
                                Text(LocalizedStringKey(replyToWho))
                                Text(": ")
                                Spacer()
                            }.padding(.top, 5)
                            .padding(.horizontal, 12)
                            
                            HStack{
                                
                                TextView(text: $content.replyText) {
                                    //                                print(text)
                                    if replyPid.isEmpty{
                                        content.sendReply()
                                    }else{
                                        content.sendReply(isComment: true, replyPid: replyPid)
                                    }
                                    
                                }
                                //                                .frame(height: 60)
                                //                                .cornerRadius(4)
                                
                            }
                            .frame(height: 60)
                            .padding(.horizontal, 12)
                            .padding(.top, 10)
                            
                            
                            HStack{
                                
                                Image(systemName: "photo")
                                    .resizable()
                                    .frame(width:30, height: 25)
                                    .aspectRatio(contentMode: .fill)
                                    .foregroundColor(.primary)
                                    .onTapGesture {
                                        showAddImage = true
                                        if bottomHeight == .zero {
                                            bottomHeight = proxy.safeAreaInsets.bottom
                                        }
                                        UIApplication.shared.endEditing()
                                    }
                                
                                Spacer()
                                
                                if content.replyText.isEmpty{
                                    Text("发送")
                                        .font(.system(size: 21.0))
                                        .foregroundColor(.gray)
                                        .padding(.horizontal, 10)
                                        .background(Color.gray.opacity(0.3))
                                        .cornerRadius(5)
                                }else{
                                    Button {
                                        //                                    print(text)
                                        if replyPid.isEmpty{
                                            content.sendReply()
                                        }else{
                                            content.sendReply(isComment: true, replyPid: replyPid)
                                        }
                                    } label: {
                                        Text("发送")
                                            .font(.system(size: 21.0))
                                            .foregroundColor(.white)
                                            .padding(.horizontal, 10)
                                            .background(Color.green)
                                            .cornerRadius(5)
                                    }
                                    
                                }
                            }.frame(height: 16)
                            .padding(.horizontal, 12)
                            .padding(.top, 20)
                            
                            
                            if showAddImage{
                                
                                Divider()
                                    .padding(.top, 20)
                                    .padding(.bottom, 10)
                                
                                LazyVGrid(columns: columns,alignment: .leading) {
                                    if content.replyImages.count < 10 {
                                        ForEach(content.replyImages.indices, id: \.self){ index in
                                            
                                            if index == content.replyImages.count - 1 {
                                                Image(uiImage: content.replyImages[index].image!)
                                                    .resizable()
                                                    .frame(width: 75, height: 75)
                                                    .onTapGesture {
                                                        if !content.isUploadingImages(){
                                                            isPhotoLibraryOpen = true
                                                            selectPhotos()
                                                        }
                                                    }
                                            }else{
                                                ZStack{
                                                    ZStack(alignment: .topTrailing){
                                                        Image(uiImage: content.replyImages[index].image!)
                                                            .resizable()
                                                            .frame(width: 75, height: 75)

                                                        
                                                        if content.replyImages[index].status == .uploaded{
                                                            Image(systemName: "xmark.circle.fill")
                                                                .resizable()
                                                                .foregroundColor(Color(.systemRed))
                                                                .background(Color.white.clipShape(Circle()))
                                                                .frame(width: 20, height: 20)
                                                                .offset(x: 10, y: -10)
                                                                .onTapGesture {
                                                                    deleteSelectImage(content.replyImages[index])
                                                                }
                                                        }

                                                    }
                                                    
                                                    if content.replyImages[index].status != .uploaded{
                                                        ZStack{
                                                            Color.black.opacity(0.3)
                                                                .frame(width: 75, height: 75)
                                                            
                                                            if content.replyImages[index].status == .waitingForUpload{
                                                                Text("等待上传")
                                                                    .foregroundColor(.white)

                                                            }else{
                                                                Text("上传中...")
                                                                    .foregroundColor(.white)
                                                            }
                                                        }
                                                    }

                                                }

                                            }
                                        }
                                    }else{
                                        ForEach(0..<9, id: \.self){ index in
                                            
                                            ZStack{
                                                ZStack(alignment: .topTrailing){
                                                    Image(uiImage: content.replyImages[index].image!)
                                                        .resizable()
                                                        .frame(width: 75, height: 75)

                                                    
                                                    if content.replyImages[index].status == .uploaded{
                                                        Image(systemName: "xmark.circle.fill")
                                                            .resizable()
                                                            .foregroundColor(Color(.systemRed))
                                                            .background(Color.white.clipShape(Circle()))
                                                            .frame(width: 20, height: 20)
                                                            .offset(x: 10, y: -10)
                                                            .onTapGesture {
                                                                deleteSelectImage(content.replyImages[index])
                                                            }
                                                    }

                                                }
                                                
                                                if content.replyImages[index].status != .uploaded{
                                                    ZStack{
                                                        Color.black.opacity(0.3)
                                                            .frame(width: 75, height: 75)
                                                        
                                                        if content.replyImages[index].status == .waitingForUpload{
                                                            Text("等待上传")
                                                                .foregroundColor(.white)

                                                        }else{
                                                            Text("上传中...")
                                                                .foregroundColor(.white)
                                                        }
                                                    }
                                                }

                                            }
                                        }
                                    }
                                    
                                }.padding(.horizontal, 10)
                                .padding(.top, 10)
                            }
                            
                            Spacer()
                            
                        }.frame(height: bottomHeight > 0 ? bottomHeight + 150 : proxy.safeAreaInsets.bottom + 150)
                        .onChange(of: proxy.safeAreaInsets.bottom) { value in
                            
                            //键盘出现时让选择图片消失
                            if value > 200{
                                showAddImage = false
                            }
//                            print(value)
                        }
                        
                    }.frame(height: bottomHeight > 0 ? bottomHeight + 150 : proxy.safeAreaInsets.bottom + 150)
                    
                }
                .ignoresSafeArea()
            }
            
        }
        
        func selectPhotos() {
            let scene = UIApplication.shared.connectedScenes.first
            let root = (scene as? UIWindowScene)?.windows.first?.rootViewController
            if root != nil {
                let config = ZLPhotoConfiguration.default()
                
                config.allowSelectVideo = false
                config.allowRecordVideo = false
                config.allowMixSelect = false
                config.allowSelectOriginal = true
                config.allowSelectGif = false
                config.languageType = appLanguage == "zh" ? .chineseSimplified : .english
                config.maxSelectCount = 9 - content.replyImages.count + 1
                config.maxPreviewCount = 0
                config.allowTakePhotoInLibrary = false
                config.allowSelectLivePhoto = false
                
                let ac = ZLPhotoPreviewSheet()
                
                ac.selectImageBlock = { (images, assets, isOriginal) in
                    
                    for image in images{
                        content.replyImages.insert(ReplyImage(image: image), at: content.replyImages.count - 1)
                    }
                    
                    for replyImage in content.replyImages{
                        if replyImage.status == .waitingForUpload{
                            content.uploadReplyImage(replyImage)
                        }
                    }
                    
                }
                
                ac.showPhotoLibrary(sender: root!)
            }
        }
        
        func deleteSelectImage(_ image: ReplyImage) {
            
            content.replyImages.removeAll { (image1) -> Bool in
                return image.id == image1.id
            }
            
        }
        
    }
    
    
    struct TextView: UIViewRepresentable {
        typealias UIViewType = UITextView
        
        @Binding var text: String
        
        
        var onDone: (() -> Void)?
        
        func makeUIView(context: UIViewRepresentableContext<TextView>) -> UITextView {
            let textField = UITextView()
            textField.delegate = context.coordinator
            
            
            textField.isEditable = true
            textField.font = UIFont.preferredFont(forTextStyle: .body)
            textField.isSelectable = true
            textField.isUserInteractionEnabled = true
            textField.isScrollEnabled = true
            textField.enablesReturnKeyAutomatically = true
            textField.becomeFirstResponder()
            textField.keyboardDismissMode = .none
            textField.layer.borderWidth = 3
            textField.layer.borderColor = CGColor(red: 0, green: 0, blue: 0, alpha: 1)
            textField.backgroundColor = UIColor(white: 1.0, alpha: 1.0)
            
            if nil != onDone {
                textField.returnKeyType = .send
            }
            
            textField.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
            return textField
        }
        
        func updateUIView(_ uiView: UITextView, context: UIViewRepresentableContext<TextView>) {
            if uiView.text != self.text {
                uiView.text = self.text
            }
            //        if uiView.window != nil, !uiView.isFirstResponder {
            //            uiView.becomeFirstResponder()
            //        }
            
        }
        
        func makeCoordinator() -> Coordinator {
            return Coordinator(text: $text, onDone: onDone)
        }
        
        final class Coordinator: NSObject, UITextViewDelegate {
            var text: Binding<String>
            var onDone: (() -> Void)?
            
            init(text: Binding<String>, onDone: (() -> Void)? = nil) {
                self.text = text
                self.onDone = onDone
            }
            
            func textViewDidChange(_ uiView: UITextView) {
                text.wrappedValue = uiView.text
            }
            
            func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
                if let onDone = self.onDone, text == "\n" {
                    textView.text = ""
                    onDone()
                    return false
                }
                return true
            }
        }
    }
    
}
