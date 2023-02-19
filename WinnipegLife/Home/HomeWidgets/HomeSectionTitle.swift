//
//  HomeSectionTitle.swift
//  WPGL
//
//  Created by changming wang on 6/2/21.
//

import SwiftUI

struct HomeSectionTitle: View {
    
    let title: LocalizedStringKey
    let subTitle: LocalizedStringKey
    let destination: AnyView
    
    var body: some View {
        
        HStack(alignment: .lastTextBaseline){
            HStack(spacing: 2){
                RoundedRectangle(cornerRadius: 25)
                    .frame(width: 25, height:15)
                    .foregroundColor(.orange)
                Text(title)
                    .font(.system(size: 20))
                    .fontWeight(.bold)
            }

            Spacer()
            
            NavigationLink(destination: destination){
                HStack{
                    Text(subTitle)
                        .foregroundColor(.black)
                        .fontWeight(.bold)
                    
                    Image(systemName: "chevron.forward")
                        .foregroundColor(.orange)
                }
            }
        }.frame(height: 30)
        .padding(.horizontal, 10)
        

    }
}

//struct HomeSectionTitle_Previews: PreviewProvider {
//    static var previews: some View {
//        HomeSectionTitle(title: "这里是区域标题", subTitle: "前往区域")
//    }
//}
