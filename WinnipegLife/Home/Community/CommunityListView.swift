//
//  CommunityListView.swift
//  WinnipegLife
//
//  Created by changming wang on 6/28/21.
//

import SwiftUI
import WaterfallGrid

struct CommunityListView: View {
    
    @Binding var threads: [CommonThread]
    var models: [DetailCommunityViewModel]
    
    let coloums = Array(repeating: GridItem(.fixed((UIScreen.main.bounds.size.width/2) - 10)), count: 2)
    
    var body: some View {
//        LazyVGrid(columns: coloums){
//            ForEach(threads.indices, id:\.self){ index in
//                let thread = threads[index]
//                let model = models[index]
//                NavigationLink(destination: CommunityDetailView(content: model, title: thread.title)){
//                    CardView(thread: thread)
//                }
//
//            }
//        }
        
        WaterfallGrid(threads.indices, id: \.self) { index in
            NavigationLink(destination: CommunityDetailView(content: models[index], title: threads[index].title)){
                NavigationLink(destination: EmptyView()) {
                    EmptyView()
                }
                CardView(thread: threads[index])
            }
            
        }
        .gridStyle(
            columnsInPortrait: 2,
            spacing: 8,
            animation: nil
        )
        
        .padding(.horizontal, 5)
    }
}

//struct CommunityListView_Previews: PreviewProvider {
//    static var previews: some View {
//        CommunityListView()
//    }
//}
