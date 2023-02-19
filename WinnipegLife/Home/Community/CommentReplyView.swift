//
//  CommentReplyView.swift
//  WinnipegLife
//
//  Created by changming wang on 7/2/21.
//

import SwiftUI
import SDWebImageSwiftUI
import SwiftUIX
import ZLPhotoBrowser

struct CommentReplyView: View {
    
    @AppStorage("appLanguage") var appLanguage: String = Locale.current.languageCode ?? "zh"
    
    
    @Environment(\.presentationMode) var presentation
    
    @Binding var model: CommentsModel
    
    @StateObject var content: CommentReplyModel
    
    @StateObject var viewer = ImageViewer()
    
    @State var imageLinks:[String] = []
    
    @State var noLoginAlert:Bool = false
    
    @State var isPhotoLibraryOpen:Bool = false
    
    var body: some View {
        ZStack{
            ZStack(alignment: .top){
                if content.isLoading{
                    SimpleRefreshingView()
                        .padding()
                }else{
                    VStack{
                        
                        ScrollView{
                            
                            CommentReplyMainRowView(model: model, imageLinks: $imageLinks, showSendCommentView: $content.showSendCommentView, noLoginAlert: $noLoginAlert)
                            
                            LazyVStack{
                                ForEach(content.comments.indices, id: \.self){ index in
                                    CommentReplyRowView(model: content.comments[index], imageLinks: $imageLinks)
                                }
                            }
                            
                            if content.comments.count > 0 && !content.isLoading{
                                RefreshFooter(refreshing: $content.isLoading, action: {
                                    content.fecthMore()
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
                            
                        }.enableRefresh()
                    }.padding(.top, 55)
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
                            if appLanguage == "zh"{
                                Text("\(model.repliesCount)条回复")
                                    .font(.system(size: 20.0))
                                    .foregroundColor(.black)
                                    .lineLimit(1)
                                    .frame(minWidth: 0, maxWidth: 150)
                            }else{
                                Text("\(model.repliesCount) Comments")
                                    .font(.system(size: 20.0))
                                    .foregroundColor(.black)
                                    .lineLimit(1)
                                    .frame(minWidth: 0, maxWidth: 150)
                            }

                            
                            Spacer()
                            
                        }.frame(width: UIScreen.main.bounds.size.width, height: 50)
                        
                    }
                }.frame(width: UIScreen.main.bounds.size.width, height: 50)
            }
            
            if content.showSendCommentView{
                SendCommentDetailView(replyToWho: model.userInfo.userName, replyPid: model.pid, showSendCommentView: $content.showSendCommentView, isPhotoLibraryOpen: $isPhotoLibraryOpen)
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
        .onAppear(){
            content.fetchData()
        }
//        .onDisappear(){
//            print("Bounces status: \(UIScrollView.appearance().bounces)")
//        }
        .navigationBarTitle("\(model.repliesCount)条回复")
        .navigationBarHidden(true)
    }
}


extension CommentReplyView{
    
    func createAlertView(message:String = "") -> some View {
        
        
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
    
    
    struct SendCommentDetailView:View {
        
        @EnvironmentObject var content: CommentReplyModel
        
        let replyToWho:String
        
        let replyPid: String
        
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
                            
                            HStack{
                                Text("回复")
                                Text(LocalizedStringKey(replyToWho))
                                Text(": ")
                                Spacer()
                            }.padding(.top, 5)
                            .padding(.horizontal, 12)
                            
                            HStack{
                                
                                TextView(text: $content.replyText) {
                                    //                                print(text)
                                    content.sendReply(replyPid: replyPid)
                                    
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
                                        content.sendReply(replyPid: replyPid)
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
                config.languageType = .chineseSimplified
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
