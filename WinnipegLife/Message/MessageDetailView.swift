//
//  MessageDetailViewe.swift
//  WinnipegLife
//
//  Created by changming wang on 7/13/21.
//

import SwiftUI
import Introspect
import SwiftUIX

struct MessageDetailView: View {
    
    @Environment(\.presentationMode) var presentation
    
    @State var recipient:String
    
    @StateObject var messageDetial: MessageDetail
    
    @State private var timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    @ObservedObject var keyboardHeightHelper = KeyboardHeightHelper()
    
    @State private var firstMessageID:UUID? = nil
    
    
    var body: some View {
        NavigationView{
            ZStack(alignment: .top){
                
                GeometryReader { proxy in
                    
                    VStack(spacing: 0){
                        
                        ScrollView{
                            
                            ScrollViewReader{ proxy in
                                if messageDetial.chatHistory.count > 0 {
                                    RefreshFooter(refreshing: $messageDetial.fetchingOld, action: {
                                        messageDetial.fetchOldMessage()
                                    }) {
                                        if messageDetial.noMore {
                                            EmptyView()
                                        } else {
                                            SimpleRefreshingView()
                                                .padding()
                                        }
                                    }
                                    .noMore(messageDetial.noMore)
                                    .preload(offset: 50)
                                    
                                }
                                LazyVStack(spacing: 0){
                                    
                                    ForEach(messageDetial.chatHistory) { message in
                                        
                                        VStack{
                                            MessageDetailTimeView(time: message.createdAt)
                                            
                                            MessageDetailRowView(
                                                message: message
                                            )
                                        }
                                        .id(message.id)
                                        
                                    }
                                    
                                }
                                .padding(.bottom, 5)
                                .onChange(of: messageDetial.initDone) { _ in
                                    if let lastId = messageDetial.chatHistory.last?.id {
                                        //一开始点击消息到出现最后一条
                                        proxy.scrollTo(lastId)
                                    }
                                }
                                .onChange(of: messageDetial.newMessageIndicator) { _ in
                                    if let lastId = messageDetial.chatHistory.last?.id {
                                        // 消息变化时跳到最后一条消息
                                        proxy.scrollTo(lastId)
                                    }
                                }
                                .onChange(of: self.keyboardHeightHelper.keyboardHeight) { _ in
                                    withAnimation{
                                        if let lastId = messageDetial.chatHistory.last?.id {
                                            // 键盘出现时消息跳最后一条
                                            proxy.scrollTo(lastId)
                                        }
                                    }
                                }
                                .onChange(of: messageDetial.fetchingOld) { _ in
                                    //加载历史数据时保持scrollView位置
                                    if let id = firstMessageID {
                                        
                                        proxy.scrollTo(id, anchor: .top)
                                        firstMessageID = messageDetial.chatHistory.first?.id
                                    }else{
                                        firstMessageID = messageDetial.chatHistory.first?.id
                                        proxy.scrollTo(firstMessageID, anchor: .top)
                                    }
                                }
                                
                            }
                        }
                        .enableRefresh()
                        .onReceive(timer) { _ in
                            if !messageDetial.fetchingNew{
                                messageDetial.fetchNewMessage()
                            }
                            
                        }
                        .onDisappear {
                            timer.upstream.connect().cancel()
                        }
                        
                        SendView(messageDetial: messageDetial, proxy: proxy)
                        
                    }
                    .edgesIgnoringSafeArea(.bottom)
                    
                }
                .padding(.top, 50)
                
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
                            
                            Text(recipient)
                                .font(.system(size: 20.0))
                                .foregroundColor(.black)
                                .lineLimit(1)
                                .frame(minWidth: 0, maxWidth: 150)
                            
                            Spacer()
                            
                        }.frame(width: UIScreen.main.bounds.size.width, height: 50)
                        
                    }
                }.frame(width: UIScreen.main.bounds.size.width, height: 50)
                
            }
            .navigationBarTitle(recipient)
            .navigationBarHidden(true)
            .onAppear {
                UIScrollView.appearance().keyboardDismissMode = .onDrag
            }
            .onDisappear{
                UIScrollView.appearance().keyboardDismissMode = .none
            }
        }
        .navigationBarTitle(recipient)
        .navigationBarHidden(true)
        
    }
    
    
}

//struct MessageDetailView_Previews: PreviewProvider {
//    static var previews: some View {
//        MessageDetailView()
//    }
//}

extension MessageDetailView {
    
    struct SendView: View {
        
        @StateObject var messageDetial: MessageDetail
        
        let proxy: GeometryProxy
        
        @State private var text: String = ""
        
        var body: some View {
            VStack(spacing:0){
                Divider()
                
                ZStack {
                    Color("SendViewBg")
                    
                    VStack {
                        HStack{
                            
                            TextView(text: $text) {
                                //                                print(text)
                                messageDetial.sendMessage(text)
                                text = ""
                            }
                            .frame(height: 40)
                            .cornerRadius(4)
                            
                            
                            if text.isEmpty{
                                Text("发送")
                                    .font(.system(size: 21.0))
                                    .foregroundColor(.gray)
                                    .padding(.horizontal, 10)
                                    .background(Color.gray.opacity(0.3))
                                    .cornerRadius(5)
                            }else{
                                Button {
                                    //                                    print(text)
                                    messageDetial.sendMessage(text)
                                    text = ""
                                } label: {
                                    Text("发送")
                                        .font(.system(size: 21.0))
                                        .foregroundColor(.white)
                                        .padding(.horizontal, 10)
                                        .background(Color.green)
                                        .cornerRadius(5)
                                }
                                
                            }
                        }
                        .frame(height: 56)
                        .padding(.horizontal, 12)
                        
                        Spacer()
                    }
                    
                }.frame(height: proxy.safeAreaInsets.bottom + 56)
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



