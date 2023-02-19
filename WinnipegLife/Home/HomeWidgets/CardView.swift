//
//  CardView.swift
//  WPGL
//
//  Created by changming wang on 6/4/21.
//

import SwiftUI
import SDWebImageSwiftUI

struct CardView: View {
//    let card: Card
    let thread: CommonThread
    
    var body: some View {
        VStack() {
            if thread.imageUrls.count > 0 {
                WebImage(url: URL(string: thread.imageUrls[0]))
                    .resizable()
                    .indicator(Indicator.progress)
                    .aspectRatio(contentMode: .fit)
                    .clipped()
                    .layoutPriority(97)
            }else{
                Image("Logo").resizable()
                    .aspectRatio(contentMode: .fit)
                    .clipped()
                    .layoutPriority(97)
            }
            
            HStack{
                Text(thread.title)
                    .font(.headline)
                    .foregroundColor(.primary)
                    .padding([.bottom, .horizontal], 8)
                    .fixedSize(horizontal: false, vertical: true)
                
                Spacer()
            }.layoutPriority(98)
            
            
            HStack(alignment: .lastTextBaseline) {
                
                if thread.userAvatar.isEmpty{
                    Image("defaultusericon")
                        .resizable()
                        .frame(width: 18, height: 18)
                        .clipShape(Circle())
                }else{
                    WebImage(url: URL(string: thread.userAvatar))
                        .resizable()
                        .frame(width: 18, height: 18)
                        .clipShape(Circle())
                }
                
                Text(thread.userName)
                    .foregroundColor(.secondary)
                
                Spacer()
                
                Image(systemName: "eye")
                    .resizable()
                    .frame(width: 18, height: 11)
                    .foregroundColor(.secondary)
                
                Text(thread.viewCount >= 999 ? "999+" : String(thread.viewCount))
                    .foregroundColor(.secondary)
                
            }
            .padding(8)
            .layoutPriority(99)

        }
        .cornerRadius(8)
        .background(
            RoundedRectangle(cornerRadius: 8)
                .stroke(Color.secondary.opacity(0.5))
        )
    }
}

//struct CardView_Previews: PreviewProvider {
//    static var previews: some View {
//        CardView(card: Card(imageUrl: "https://images.unsplash.com/photo-1593642634402-b0eb5e2eebc9?ixid=MnwxMjA3fDF8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=1650&q=80", title: "Title"))
//            .padding()
//            .previewLayout(.sizeThatFits)
//    }
//}

//struct CardView_Previews: PreviewProvider {
//    static var previews: some View {
//        HStack{
//            CardView()
//            CardView()
//        }
//    }
//}
