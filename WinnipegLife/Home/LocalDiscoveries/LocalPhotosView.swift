//
//  LocalPhotosView.swift
//  WinnipegLife
//
//  Created by changming wang on 6/16/21.
//

import SwiftUI
import SDWebImageSwiftUI

struct LocalPhotosView: View {
    
    let imageUrls: [String]
    
    let offset: CGFloat
    
    var body: some View {
        TabView(){
            ForEach(imageUrls.indices, id:\.self){ index in
                WebImage(url: URL(string: imageUrls[index]))
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height/3 - 50 + (offset > 0 ? offset : 0))
                    
            }
        }.tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
        .frame(width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height/3 - 50 + (offset > 0 ? offset : 0))
        .offset(y: (offset > 0 ? -offset : 0))
    }
}

//struct LocalPhotosView_Previews: PreviewProvider {
//    static var previews: some View {
//        LocalPhotosView()
//    }
//}
