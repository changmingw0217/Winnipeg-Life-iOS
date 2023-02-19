//
//  SearchDetailView.swift
//  WinnipegLife
//
//  Created by changming wang on 8/18/21.
//

import SwiftUI

struct SearchDetailView: View {
    
    let thread: SearchThread

    
    var body: some View {
        
        VStack{
//            if thread.categoriesID == localDiscoveriesId{
//                LocalDetailView(content: CommonViewModel(pid: String(thread.pid)), title: thread.title)
//            }else if ((communityID?.contains(thread.categoriesID)) != nil){
//                CommunityDetailView(content: DetailCommunityViewModel(pid: String(thread.pid)), title: thread.title)
//            }else if ((merchantsID?.contains(thread.categoriesID)) != nil){
//                MerchantDetailView(content: DetailCommunityViewModel(pid: String(thread.pid)), title: thread.title)
//            }else if ((newsId?.contains(thread.categoriesID)) != nil){
//                NewsDetailView(content: DetailCommunityViewModel(pid: String(thread.pid)), title: thread.title)
//            }
            if thread.categoryName == "news"{
                NewsDetailView(content: CommonViewModel(pid: String(thread.pid)), title: thread.title)
            }else if thread.categoryName == "merchant" {
                MerchantDetailView(content: CommonViewModel(pid: String(thread.pid)), title: thread.title)
            }else if thread.categoryName == "community" {
                CommunityDetailView(content: DetailCommunityViewModel(pid: String(thread.pid)), title: thread.title)
            }else if thread.categoryName == "local" {
                LocalDetailView(content: CommonViewModel(pid: String(thread.pid)), title: thread.title)
            }
        }
        .navigationBarTitle("")
        .navigationBarHidden(true)
        
    }
}

//struct SearchDetailView_Previews: PreviewProvider {
//    static var previews: some View {
//        SearchDetailView()
//    }
//}
