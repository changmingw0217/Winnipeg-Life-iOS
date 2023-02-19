//
//  MessageRow.swift
//  WinnipegLife
//
//  Created by changming wang on 7/14/21.
//

import SwiftUI
import SDWebImageSwiftUI

struct MessageDetailRowView: View {
    
    let message:DetailMessage
    
    var body: some View {
        HStack(alignment: .top, spacing: 8){
            if message.isMe { Spacer() } else { Avatar(icon: message.member.icon) }
            
            TextMessage(isMe: message.isMe, text: message.text)
            
            if message.isMe { Avatar(icon: message.member.icon) } else { Spacer() }
        }.padding(.init(top: 8, leading: 12, bottom: 8, trailing: 12))
    }
}

extension MessageDetailRowView {
    
    struct Avatar: View {
        let icon: String
        
        var body: some View {
            if icon.isEmpty{
                Image("defaultusericon")
                    .resizable()
                    .frame(width: 40, height: 40)
                    .cornerRadius(4)
            }else{
                WebImage(url: URL(string: icon))
                    .resizable()
                    .frame(width: 40, height: 40)
                    .cornerRadius(4)
            }
        }
    }
    
    struct TextMessage: View {
        let isMe: Bool
        let text: String
        
        var body: some View {
            HStack(alignment: .top, spacing: 0) {
                if !isMe { Arrow(isMe: isMe) }
                
                Text(text)
                    .font(.system(size: 17))
                    .padding(.horizontal, 12)
                    .padding(.vertical, 10)
                    .background(background)
                
                if isMe { Arrow(isMe: isMe) }
            }
        }
        
        private var background: some View {
            RoundedRectangle(cornerRadius: 4)
                .foregroundColor(Color("chat_\(isMe ? "me" : "friend")_background"))
        }
    }
    
    struct Arrow: View {
        let isMe: Bool
        
        var body: some View {
            Path { path in
                path.move(to: .init(x: isMe ? 0 : 6, y: 14))
                path.addLine(to: .init(x: isMe ? 0 : 6, y: 26))
                path.addLine(to: .init(x: isMe ? 6 : 0, y: 20))
                path.addLine(to: .init(x: isMe ? 0 : 6, y: 14))
            }
            .fill(Color("chat_\(isMe ? "me" : "friend")_background"))
            .frame(width: 6, height: 30)
        }
    }
}

//struct MessageRow_Previews: PreviewProvider {
//    static var previews: some View {
//        MessageRow()
//    }
//}
struct MessageDetailTimeView: View {
    let time: String
    
    var body: some View{
        Text(time)
            .foregroundColor(.secondary)
            .font(.system(size: 14, weight: .medium))
            .frame(maxWidth: .infinity)
            .padding(.vertical, 4)
    }
}
