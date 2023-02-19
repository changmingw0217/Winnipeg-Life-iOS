//
//  FoodRowView.swift
//  WinnipegLife
//
//  Created by changming wang on 8/19/21.
//

import SwiftUI
import SDWebImageSwiftUI

struct FoodRowView: View {
    
    let thread: CommonThread
    
    var body: some View {
        VStack{
            HStack{
                ZStack{
                    
                    if thread.storeCover.isEmpty{
                        Image("Logo").resizable()
                            .frame(width: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, height: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/)
                            .aspectRatio(contentMode: .fill)
                            .padding(.horizontal, 10)
                            .cornerRadius(5)
                    }else{
                        WebImage(url: URL(string: thread.storeCover))
                            .resizable()
                            .indicator(.activity)
                            .frame(width: 100, height: 100)
                            .aspectRatio(contentMode: .fill)
                            .cornerRadius(5)
                            
                        
                    }
                }
                
                VStack(alignment:.leading){
                    Text(thread.storeName)
                        .foregroundColor(.primary)
                    
                    Spacer()
                    
                    Text(LocalizedStringKey(thread.categoryId))
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
            }.padding(.horizontal, 5)
            
            Divider()
        }
    }
}

//struct FoodRowView_Previews: PreviewProvider {
//    static var previews: some View {
//        FoodRowView()
//    }
//}
