//
//  FoodOrderBar.swift
//  WinnipegLife
//
//  Created by changming wang on 9/13/21.
//

import SwiftUI

struct FoodOrderBar: View {
    
    let storeOwnerId:String
    
    let threadId: String
    
    var body: some View {
        ZStack{
            Color.white.frame(width: UIScreen.main.bounds.size.width, height: 50)
            
            VStack{
                HStack{
                    
                    NavigationLink(destination: FoodOrderDetailView(storeOwnerId: storeOwnerId, threadId: threadId)) {
                        
                        NavigationLink(destination: EmptyView()) {
                            EmptyView()
                        }
                        Text("预约餐厅")
                            .font(.system(size: 14))
                            .foregroundColor(.white)
                            .fontWeight(.bold)
                            .padding(.vertical)
                            .frame(width: UIScreen.main.bounds.width - 50)
                            .background(
                                LinearGradient(gradient: .init(colors: [Color("Color"), Color("Color1")]), startPoint: .topLeading, endPoint: .bottomTrailing)
                            )
                            .cornerRadius(8)
                    }
                    .padding(.top, 15)

                }
            }
        }.frame(height: 50)
    }
}

//struct FoodOrderBar_Previews: PreviewProvider {
//    static var previews: some View {
//        FoodOrderBar()
//    }
//}
