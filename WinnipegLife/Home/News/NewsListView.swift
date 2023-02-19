//
//  NewsListView.swift
//  WinnipegLife
//
//  Created by changming wang on 6/10/21.
//

import SwiftUI

struct NewsListView: View {
    
    @Binding var threads: [CommonThread]
    var models: [CommonViewModel]
    
    var body: some View {
            LazyVStack{
                
                ForEach(threads.indices, id: \.self){ index in
                    NavigationLink.init(
                        destination: NewsDetailView(content: models[index], title: threads[index].title),
                        label: {
                            NavigationLink(destination: EmptyView()) {
                                EmptyView()
                            }
//                            RowView(title: threads[index].title, summary: threads[index].summary, createTime: threads[index].createdAt, imageURL: threads[index].storeCover)
                            
                            NewRowView(title: threads[index].title, summary: threads[index].summary, createTime: threads[index].createdAt, imageURL: threads[index].storeCover, categoryId: threads[index].categoryId)
//                            Divider()
                        })
                    
                }
                
            }
        
    }
    
}

//struct NewsListView_Previews: PreviewProvider {
//    static var previews: some View {
//        NewsListView()
//    }
//}
