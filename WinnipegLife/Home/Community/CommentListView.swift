//
//  CommentListView.swift
//  WinnipegLife
//
//  Created by changming wang on 7/2/21.
//

import SwiftUI

struct CommentListView: View {
    
    let commentCount: Int
    
    @Binding var models:[CommentsModel]
    
    @Binding var imageLinks:[String]
    
    @Binding var replyToWho: String
    
    @Binding var replyPid:String
    
    @Binding var showSendCommentView:Bool
    
    @Binding var noLoginAlert:Bool
    
    
    var body: some View {
        VStack{

            HStack(spacing:0){
                Text("全部")
                    .font(.title2)
                    .padding(.horizontal, 10)
                
                Text("\(commentCount)")
                    .font(.title2)
                

                Spacer()
            }.padding(.horizontal, 10)

            Divider()
            
            if commentCount == 0 {
                VStack{
                    Spacer()
                    Text("暂无评论")
                        .foregroundColor(.secondary)
                    Spacer()
                }.frame(height: 150)
            }else{
                VStack{
                    ForEach(models.indices, id: \.self){ index in
                        CommentRowView(model: $models[index], imageLinks: $imageLinks,replyToWho: $replyToWho, replyPid: $replyPid
                                       ,showSendCommentView: $showSendCommentView, noLoginAlert: $noLoginAlert)
                    }
                }

            }

        }
    }
}

//struct CommentListView_Previews: PreviewProvider {
//    static var previews: some View {
//        CommentListView()
//    }
//}
