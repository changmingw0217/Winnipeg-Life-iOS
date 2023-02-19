//
//  FoodListView.swift
//  WinnipegLife
//
//  Created by changming wang on 8/19/21.
//

import SwiftUI

struct FoodListView: View {
    
    
    @Binding var threads: [CommonThread]
    var models: [CommonViewModel]
    
    var body: some View {
        LazyVStack{
            
            ForEach(threads.indices, id: \.self){ index in
//                NavigationLink.init(
//                    destination: MerchantDetailView(content: models[index], title: threads[index].title),
//                    label: {
//                        MerchantsBoxView(thread: threads[index])
//                            .padding(.top, 5)
//                    })
                
                
                
                if !threads[index].storeName.isEmpty{
                    NavigationLink(destination: FoodDetailView(content: models[index], title: threads[index].storeName)) {
                        FoodRowView(thread: threads[index])
                    }

                }

                
            }
            
        }
    }
}

//struct FoodListView_Previews: PreviewProvider {
//    static var previews: some View {
//        FoodListView()
//    }
//}
