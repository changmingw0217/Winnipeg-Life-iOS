//
//  OrdersRowView.swift
//  WinnipegLife
//
//  Created by changming wang on 9/21/21.
//

import SwiftUI
import SDWebImageSwiftUI

struct OrdersRowView: View {
    
    let order:RestaOrder
    
    var body: some View {
        VStack{
            
            HStack{
                
                VStack{
                    if order.storeCover.isEmpty{
                        Image("defaultusericon")
                            .resizable()
                            .frame(width: 25, height: 25)
                            .clipShape(Circle())
                    }else{
                        WebImage(url: URL(string: order.storeCover))
                            .resizable()
                            .frame(width: 50, height: 50)
                            .clipShape(Rectangle())
                            .cornerRadius(10)
                    }
                    Spacer()
                }
                .padding(.leading, 10)
                
                
                VStack(spacing: 20){
                    HStack{
                        Text(order.storeName)
                        Spacer()
                        HStack{
                            
                            Circle()
                                .fill(order.color)
                                .frame(width: 5, height: 5)
                            
                            
                            Text(order.status.rawValue)
                        }
                        
                        
                    }.padding(.horizontal, 10)
                    
                    HStack{
                        Text("预约时间")
                            + Text(order.time)
                        
                        Spacer()
                        
                        Text("预约人数")
                            + Text(order.numberOfPeople)
                    }.padding(.horizontal, 10)
                    
                    HStack{
                        
                        Spacer()
                        
                        Text("预约订单")
                            .foregroundColor(.secondary)
                            .font(.footnote)
                    }.padding(.horizontal, 10)

                }
            }
            
            Divider()
        }
    }
}

//struct OrdersRowView_Previews: PreviewProvider {
//    static var previews: some View {
//        OrdersRowView()
//    }
//}
