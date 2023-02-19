//
//  RowViewWidget.swift
//  WPGL
//
//  Created by changming wang on 5/28/21.
//

import SwiftUI
import SDWebImageSwiftUI

struct RowView: View {
    
    let title: String
    let summary: String
    let createTime: String
    let imageURL:String
    var reverse:Bool = false
    
    
        var body: some View {
            if reverse{
                GroupBox{
                    HStack{
    
    
                        VStack(alignment: .leading){
                            Text(title)
                                .font(.title)
                                .lineLimit(1)
                                .foregroundColor(.primary)
                            Spacer()
                            Text(summary)
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                            Spacer()
                            Text(createTime)
                                .font(.subheadline)
                                .foregroundColor(.secondary)
    
                        }
                        Spacer()
                        if imageURL.isEmpty{
                            Image("Logo").resizable()
                                .frame(width: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, height: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/)
                                .padding(.horizontal, 10)
                        }else{
                            WebImage(url: URL(string: imageURL))
                                .resizable()
                                .indicator(.activity)
                                .transition(.fade(duration: 0.5))
                                .scaledToFit()
                                .frame(width: 100, height: 100)
    
                        }
                    }.frame(maxWidth: .infinity)
                    .frame(height: 100)
    
                }.padding(.horizontal, 5)
    
    
            }else{
                GroupBox{
                    HStack{
    
                        if imageURL.isEmpty{
                            Image("Logo").resizable()
                                .frame(width: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, height: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/)
                        }else{
                            WebImage(url: URL(string: imageURL))
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 100, height: 100)
    
                        }
                        VStack(alignment: .leading){
                            Text(title)
                                .font(.title)
                                .lineLimit(1)
                                .foregroundColor(.primary)
                            Spacer()
                            Text(summary)
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                            Spacer()
                            Text(createTime)
                                .font(.subheadline)
                                .foregroundColor(.secondary)
    
                        }
                        Spacer()
                    }.frame(maxWidth: .infinity)
                    .frame(height: 100)
    
                }.padding(.horizontal, 5)
    
            }
    
        }
}

struct RowView_Previews: PreviewProvider {
    static var previews: some View {
        VStack{
            RowView(title: "这是一个标题", summary: "这个是店铺的Title, 很好的一家餐厅, 中西合璧, 各种好吃的。", createTime: "2021/4/21", imageURL: "")
            RowView(title: "这是一个标题", summary: "这个是店铺的Titl", createTime: "2021/4/21", imageURL: "", reverse: true)
            RowView(title: "这是一个标题", summary: "这个是店铺的Title, 很好的一家餐厅, 中西合璧, 各种好吃的。", createTime: "2021/4/21", imageURL: "")
        }
    }
}


struct NewRowView: View {
    
    let title: String
    let summary: String
    let createTime: String
    let imageURL:String
    let categoryId:String
    
    
    
    var body: some View{
        
        VStack(){
            HStack{
                if imageURL.isEmpty{
                    Image("Logo").resizable()
                        .frame(width: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, height: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/)
                }else{
                    WebImage(url: URL(string: imageURL))
                        .resizable()
                        .frame(width: 100, height: 100)
                        .aspectRatio(contentMode: .fill)
                        .cornerRadius(5)
                }
                
                VStack(alignment: .leading){
                    Text(title)
                        .font(.title)
                        .lineLimit(1)
                        .foregroundColor(.primary)
                        .padding(.trailing, 10)
                    Spacer()
                    Text(summary)
                        .font(.subheadline)
                        .lineLimit(2)
                        .foregroundColor(.secondary)
                        
                    Spacer()
                    HStack{
                        
                        Text(LocalizedStringKey(categoryId))
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        
                        Spacer()
                        
                        Text(createTime)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }.padding(.trailing, 10)
                    
                        
                }
                
                Spacer()
                
            }.padding(.horizontal, 10)
            
            Divider().padding(.horizontal, 10)
        }
        
        
    }
}

struct DiscoveriesRowView: View {
    
    let title: String
    let summary: String
    let createTime: String
    let imageURL:String
    
    var body: some View{
        
        VStack(){
            HStack{
                if imageURL.isEmpty{
                    Image("Logo").resizable()
                        .frame(width: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, height: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/)
                }else{
                    WebImage(url: URL(string: imageURL))
                        .resizable()
                        .frame(width: 100, height: 100)
                        .aspectRatio(contentMode: .fill)
                        .cornerRadius(5)
                }
                
                VStack(alignment: .leading){
                    Text(title)
                        .font(.title)
                        .lineLimit(1)
                        .foregroundColor(.primary)
                        .padding(.trailing, 10)
                    Spacer()
                    Text(summary)
                        .font(.subheadline)
                        .lineLimit(2)
                        .foregroundColor(.secondary)
                        
                    Spacer()
                    HStack{
                        
                        
                        Text(createTime)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        
                        Spacer()
                    }.padding(.trailing, 10)
                    
                        
                }
                
                Spacer()
                
            }.padding(.horizontal, 10)
            
            Divider().padding(.horizontal, 10)
        }
        
        
    }
}
