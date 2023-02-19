//
//  RewardsView.swift
//  WinnipegLife
//
//  Created by changming wang on 10/26/21.
//

import SwiftUI

struct RewardsView: View {
    @Environment(\.presentationMode) var presentation
    
    @StateObject var content: RewardsModel
    
    var body: some View {
        ZStack(alignment: .top){
            
            ScrollView(showsIndicators: false){
                VStack(alignment: .leading){

                    Text("您当前的积分为: ")
                    + Text(content.rewardPoints)

                }.padding(.horizontal, 10)
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
                        
                        Text("我的积分")
                            .font(.system(size: 20.0))
                            .foregroundColor(.black)
                            .lineLimit(1)
                            .frame(minWidth: 0, maxWidth: 150)
                        
                        Spacer()
                        
                    }.frame(width: UIScreen.main.bounds.size.width, height: 50)
                    
                }
            }.frame(width: UIScreen.main.bounds.size.width, height: 50)
        }
        .navigationTitle("")
        .navigationBarHidden(true)
    }
}

//struct RewardsView_Previews: PreviewProvider {
//    static var previews: some View {
//        RewardsView()
//    }
//}
