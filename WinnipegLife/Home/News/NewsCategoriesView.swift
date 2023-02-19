//
//  NewsCategoriesView.swift
//  WinnipegLife
//
//  Created by changming wang on 6/11/21.
//

import SwiftUI

struct NewsCategoriesView: View {
    
    @Binding var titleIndex: Int
    @Binding var showCategoties: Bool
    let titles: [String]
    let coloums = Array(repeating: GridItem(.flexible()), count: 3)
    
    var body: some View {
        
        VStack{
            HStack{
                Text("全部分类")
                    .font(.system(size:20))
                    .fontWeight(.bold)
                    .padding(.leading,5)
                Spacer()
            }.padding(10)
            
            LazyVGrid(columns: coloums){
                
                ForEach(0..<titles.count){ index in
                    
                    Button(action: {
                        showCategoties.toggle()
                        titleIndex = index
                    }){
                        Text(LocalizedStringKey(titles[index]))
                            .padding(.horizontal, 20)
                            .padding(.top, 5)
                            .padding(.bottom, 5)
                            .foregroundColor(titleIndex == index ? Color.orange : Color.primary)
                            
                            .cornerRadius(3)
                    }.border(titleIndex == index ? Color.orange : Color.gray, width: 1)
                }
            }.padding(.bottom, 10)
            
        }.background(
            RoundedRectangle(cornerRadius: 5)
                
                .foregroundColor(.white)
                .shadow(radius: 2)
        ).frame(minWidth: 0,
                maxWidth: 360,
                minHeight: 0,
                maxHeight: .infinity,
                alignment: .topLeading)
        
    }
}

//struct NewsCategoriesView_Previews: PreviewProvider {
//    static var previews: some View {
//        NewsCategoriesView()
//    }
//}
