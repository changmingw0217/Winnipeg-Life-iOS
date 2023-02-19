//
//  ScrollTabbarView.swift
//  WinnipegLife
//
//  Created by changming wang on 6/6/21.
//

import SwiftUI

struct ScrollTabbarView: View {
    
    @AppStorage("appLanguage") var appLanguage: String = Locale.current.languageCode ?? "zh"
    
    @Binding var titleIndex:Int
    @Namespace var name
    
    let titles: [String]
    let nameSpaceName: String
    private let leftOffset: CGFloat = 0.60
    
    var body: some View {
        
        ScrollViewReader{ proxy in
            
            ScrollView(.horizontal, showsIndicators: false){
                HStack(spacing: 20){
                    ForEach(0..<titles.count){ index in
                        Button(action: {
                            withAnimation(){
                                titleIndex = index
                            }
                        }, label: {
                            VStack(spacing: 5){
                                Text(LocalizedStringKey(titles[index]))
                                    .font(.system(size: 20))
                                    .fixedSize()
                                    .foregroundColor(titleIndex == index ? .black : .gray)
                                
                                ZStack{
                                    Capsule()
                                        .fill(Color.black.opacity(0.04))
                                        .frame(width:30,height:4)
                                    
                                    if titleIndex == index {
                                        Capsule()
                                            .fill(Color(.orange))
                                            .frame(width:30,height:4)
                                            .matchedGeometryEffect(id: nameSpaceName, in: name)
                                    }
                                }
                            }
                        }).id(index)
                    }
                }
                .padding(.horizontal, 10)
            }
            .padding(.trailing, 40)
            .onAppear(perform: {
                withAnimation {
                    if titleIndex < titles.count - 2 {
                        proxy.scrollTo(titleIndex, anchor: UnitPoint(x: UnitPoint.leading.x + leftOffset, y: UnitPoint.leading.y))
                    }else{
                        proxy.scrollTo(titleIndex)
                    }
                    
                }
            })
            .onChange(of: titleIndex){ value in
                
                withAnimation {
                    if titleIndex < titles.count - 2 {
                        proxy.scrollTo(value, anchor: UnitPoint(x: UnitPoint.leading.x + leftOffset, y: UnitPoint.leading.y))
                    }else{
                        proxy.scrollTo(value)
                    }
                    
                }
            }.animation(.easeInOut)
            
        }.frame(height: 40)
    }
}

//struct ScrollTabbarView_Previews: PreviewProvider {
//    static var previews: some View {
//        ScrollTabbarView()
//    }
//}
