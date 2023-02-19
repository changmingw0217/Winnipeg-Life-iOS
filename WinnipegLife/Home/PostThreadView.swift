//
//  PostThreadView.swift
//  WinnipegLife
//
//  Created by changming wang on 8/8/21.
//

import SwiftUI
import Introspect
import ZLPhotoBrowser
import ActivityIndicatorView

struct PostThreadView: View {
    
    @AppStorage("appLanguage") var appLanguage: String = Locale.current.languageCode ?? "zh"
    
    @Environment(\.presentationMode) var presentation
    
    @StateObject var post:PostThread = PostThread()
    
    let columns = Array(repeating: GridItem(.flexible()), count: 4)
    
    private var autohideDuration: Double = 1.0
    
    var body: some View {
        ZStack(alignment:.center){
            ZStack(alignment: .top){
                ZStack{
                    Color.black.opacity(0.1).ignoresSafeArea()
                    if !post.loadingCateegoriesList{
                        SimpleRefreshingView()
                    }else{
                        ScrollView{
                            VStack(spacing: 25){
                                VStack(spacing: 0){
                                    
                                    HStack{
                                        Text("帖子内容:")
                                        Spacer()
                                    }.padding(.horizontal, 10)
                                    .padding(.top, 10)
                                    
                                    
                                    TextView(text: $post.content)
                                        .frame(height: 180)
                                        .padding(.horizontal, 10)
                                        .padding(.top, 10)
                                    
                                    HStack{
                                        Button {
                                            UIApplication.shared.endEditing()
                                            if !post.checkImageStatus(){
                                                post.waitUploadingAlert.toggle()
                                            }else{
                                                selectPhotos()
                                            }
                                            
                                        } label: {
                                            Image(systemName: "photo")
                                                .resizable()
                                                .frame(width:30, height: 25)
                                                .aspectRatio(contentMode: .fill)
                                                .foregroundColor(Color.black.opacity(0.2))
                                            
                                        }
                                        
                                        Spacer()
                                    }
                                    .padding(.horizontal, 10)
                                    .padding(.top, 10)
                                    .padding(.bottom, 10)
                                    
                                    
                                    if post.postImages.count > 0 {
                                        LazyVGrid(columns: columns) {
                                            ForEach(post.postImages.indices, id: \.self){ index in
                                                
                                                ZStack{
                                                    ZStack(alignment: .topTrailing){
                                                        Image(uiImage: post.postImages[index].image!)
                                                            .resizable()
                                                            .frame(width: 75, height: 75)
                                                        
                                                        
                                                        if post.postImages[index].status == .uploaded{
                                                            Image(systemName: "xmark.circle.fill")
                                                                .resizable()
                                                                .foregroundColor(Color(.systemRed))
                                                                .background(Color.white.clipShape(Circle()))
                                                                .frame(width: 20, height: 20)
                                                                .offset(x: 10, y: -10)
                                                                .onTapGesture {
                                                                    deleteSelectImage(post.postImages[index])
                                                                }
                                                        }
                                                        
                                                    }
                                                    
                                                    if post.postImages[index].status != .uploaded{
                                                        ZStack{
                                                            Color.black.opacity(0.3)
                                                                .frame(width: 75, height: 75)
                                                            
                                                            if post.postImages[index].status == .waitingForUpload{
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
                                        .padding(.top, 10)
                                        .padding(.bottom, 10)
                                    }
                                    
                                }.background(Color.white)
                                
                                VStack{
                                    ZStack{
                                        Color.white
                                        
                                        VStack{
                                            
                                            HStack{
                                                Text("内容分类")
                                                    .font(.title3)
                                                    .foregroundColor(.primary)
                                                
                                                Spacer()
                                                
                                                Text(LocalizedStringKey(post.firstCategoryIdSelected == -1 ? "请选择分类" : post.firstCategoryList[post.firstCategoryIdSelected]))
                                                    .font(.title3)
                                                    .foregroundColor(.orange)
                                                    .padding(.trailing, 5)
                                                
                                                Image(systemName: "chevron.right")
                                                    .foregroundColor(Color(.secondaryLabel))
                                            }.padding(.horizontal, 10)
                                            .onTapGesture {
                                                UIApplication.shared.endEditing()
                                                post.pickerList = post.firstCategoryList
                                                post.showPicker = true
                                                post.firstOrSecond = true
                                                
                                            }
                                            
                                            if post.sencondCategoryList.count > 0 {
                                                
                                                Divider()
                                                
                                                HStack{
                                                    Text("更多分类")
                                                        .font(.title3)
                                                        .foregroundColor(.primary)
                                                    
                                                    Spacer()
                                                    
                                                    Text(LocalizedStringKey(post.secondCategoryIdSelected == -1 ? "请选择分类" : post.sencondCategoryList[post.secondCategoryIdSelected]))
                                                        .font(.title3)
                                                        .foregroundColor(.orange)
                                                        .padding(.trailing, 5)
                                                    
                                                    Image(systemName: "chevron.right")
                                                        .foregroundColor(Color(.secondaryLabel))
                                                }.padding(.horizontal, 10)
                                                .onTapGesture {
                                                    UIApplication.shared.endEditing()
                                                    post.pickerList = post.sencondCategoryList
                                                    post.showPicker = true
                                                    post.firstOrSecond = false
                                                    
                                                }
                                            }
                                            
                                            
                                        }.padding(.top, 10)
                                        .padding(.bottom, 10)
                                    }
                                }
                            }
                            

                            
                        }.introspectScrollView { scrollview in
                            scrollview.keyboardDismissMode = .onDrag
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
                            
                            Text("发帖")
                                .font(.system(size: 20.0))
                                .foregroundColor(.black)
                                .lineLimit(1)
                                .frame(minWidth: 0, maxWidth: 150)
                            
                            Spacer()
                            
                            Button {
                                UIApplication.shared.endEditing()
                                if post.content.isEmpty{
                                    post.contentEmptyAlert = true
                                }else if !post.checkCategorySelection(){
                                    // 啥也不做
                                    // checkCategorySelection已经弄好了
                                }
                                else if !post.checkImageStatus(){
                                    post.uploadingAlert = true
                                }else{
                                    post.sendThread()
                                }

                            } label: {
                                Text("发布")
                                    .font(.system(size: 20.0))
                                    .foregroundColor(.orange)
                                    .lineLimit(1)
                                    .padding(.trailing, 10)
                            }

                            
                        }.frame(width: UIScreen.main.bounds.size.width, height: 50)
                        
                    }
                }.frame(width: UIScreen.main.bounds.size.width, height: 50)
            }
            
            if post.showPicker{
                ZStack{
                    
                    Color.black.opacity(0.2).ignoresSafeArea()
                        .onTapGesture {
                            post.showPicker = false
                        }
                    
                    VStack(spacing: 0){
                        Text("请选择分类")
                            .frame(minWidth: 0,maxWidth: .infinity, minHeight: 0, maxHeight: 50, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                            .background(Color.gray)
                            
                        ScrollView{
                            ForEach(post.pickerList.indices, id: \.self){ index in
                                Text(LocalizedStringKey(post.pickerList[index]))
                                    .onTapGesture {
                                        post.showPicker = false
                                        if post.firstOrSecond{
                                            
                                            post.firstCategoryIdSelected = index
                                            let name = post.firstCategoryList[index]
                                            let info = post.categoryInfos[name]
                                            
                                            post.sencondCategoryList.removeAll()
                                            post.secondCategoryIdSelected = -1
                                            
                                            if let children = info?.childList {

                                                for child in children{
                                                    post.sencondCategoryList.append(child)
                                                }
                                            }
                                            
                                        }else{
                                            post.secondCategoryIdSelected = index
//                                            post.sencondCategoryList.removeAll()
//                                            post.secondCatecoryIdSelected = -1
                                        }
                                        
                                    }
                                
                                Divider()
                            }
                        }
                        .padding(.top, 10)
                        .background(Color.white)
                    }
                    .padding(.top, 150)
                    .padding(.bottom, 150)
                    .padding(.horizontal, 60)
                }

            }
            
            
            if post.sendingThread{
                ZStack {
                    
                    Color.black.opacity(0.2).ignoresSafeArea()
                    
                    
                    RoundedRectangle(cornerRadius: 5.0)
                        .frame(width: 200.0, height: 200.0)
                        .foregroundColor(Color.black.opacity(0.6))
                    VStack {
                        Text("正在发帖").foregroundColor(.white)
                        ActivityIndicatorView(isVisible: $post.sendingThread, type: .growingArc())
                             .frame(width: 50.0, height: 50.0)
                            .foregroundColor(.red)
                    }
                }
            }
        }
        .present(isPresented: self.$post.contentEmptyAlert, type: .alert, animation: Animation.easeInOut, autohideDuration: autohideDuration, closeOnTap: false) {
            self.createAlertView(message: "内容不能为空")
        }
        .present(isPresented: self.$post.uploadingAlert, type: .alert, animation: Animation.easeInOut, autohideDuration: autohideDuration, closeOnTap: false) {
            self.createAlertView(message: "请等待全部图片上传")
        }
        .present(isPresented: self.$post.waitUploadingAlert, type: .alert, animation: Animation.easeInOut, autohideDuration: autohideDuration, closeOnTap: false) {
            self.createAlertView(message: "请等待当前图片上传")
        }
        .present(isPresented: self.$post.categoryFirstAlert, type: .alert, animation: Animation.easeInOut, autohideDuration: autohideDuration, closeOnTap: false) {
            self.createAlertView(message: "请选择内容分类")
        }
        .present(isPresented: self.$post.categorySecondAlert, type: .alert, animation: Animation.easeInOut, autohideDuration: autohideDuration, closeOnTap: false) {
            self.createAlertView(message: "请选择更多分类")
        }
        .present(isPresented: self.$post.sendingDone, type: .alert, animation: Animation.easeInOut, autohideDuration: autohideDuration, closeOnTap: false) {
            self.createAlertView(message: "发帖成功")
        }
        .onAppear(perform: {
            post.fetchCategories()
        })
        .onChange(of: post.sendingDone, perform: { _ in
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                presentation.wrappedValue.dismiss()
            }
        })
        .navigationBarTitle("发帖")
        .navigationBarHidden(true)
    }
}

//struct PostThreadView_Previews: PreviewProvider {
//    static var previews: some View {
//        PostThreadView()
//    }
//}

extension PostThreadView{
    
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
            config.maxSelectCount = 9 - post.postImages.count
            config.maxPreviewCount = 0
            config.languageType = appLanguage == "zh" ? .chineseSimplified : .english
            config.allowTakePhotoInLibrary = false
            config.allowSelectLivePhoto = false
            config.cameraConfiguration.flashMode = .auto
            config.cameraConfiguration.exposureMode = .autoExpose
            config.cameraConfiguration.focusMode = .autoFocus
            config.cameraConfiguration.sessionPreset = .hd1920x1080
            let ps = ZLPhotoPreviewSheet()
            ps.selectImageBlock = {(images, assets, isOriginal) in
                for image in images{
                    if post.postImages.count == 0 {
                        post.postImages.append(PostImage(image: image))
                    }else{
                        post.postImages.insert(PostImage(image: image), at: post.postImages.count - 1)
                    }
                    
                    for postImage in post.postImages{
                        if postImage.status == .waitingForUpload{
                            post.uploadReplyImage(postImage)
                        }
                    }
                    
                }
                
                for postImage in post.postImages{
                    if postImage.status == .waitingForUpload{
                        //                        content.uploadReplyImage(replyImage)
                    }
                }
            }
            ps.showPreview(sender: root!)
            //            ps.showPhotoLibrary(sender: root!)
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
            //            textField.becomeFirstResponder()
            textField.keyboardDismissMode = .none
            textField.layer.borderWidth = 3
            textField.layer.cornerRadius = 5
            textField.clipsToBounds = true
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
    
    
    func deleteSelectImage(_ image: PostImage) {
        
        post.postImages.removeAll { (image1) -> Bool in
            return image.id == image1.id
        }
        
    }
}
