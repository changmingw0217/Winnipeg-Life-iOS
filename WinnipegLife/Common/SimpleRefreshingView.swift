//
//  SimpleRefreshingView.swift
//  WinnipegLife
//
//  Created by changming wang on 6/22/21.
//

import SwiftUI
import SwiftUIX

struct SimpleRefreshingView: View {
    var body: some View {
        ActivityIndicator()
            .frame(minWidth: /*@START_MENU_TOKEN@*/0/*@END_MENU_TOKEN@*/,maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, minHeight: /*@START_MENU_TOKEN@*/0/*@END_MENU_TOKEN@*/, maxHeight: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
    }
}

struct SimpleRefreshingView_Previews: PreviewProvider {
    static var previews: some View {
        SimpleRefreshingView()
    }
}

