//
//  LocalButtons.swift
//  WinnipegLife
//
//  Created by changming wang on 6/16/21.
//

import SwiftUI

struct LocalButtons: View {
    
    var body: some View {
        HStack{
            Button(action: {
                print("Hello")
                
            }){
                VStack{
                    ZStack {
                        Circle()
                            .frame(width: 50, height: 50)
                            .foregroundColor(Color.gray.opacity(0.6))
                        Image(systemName: "phone")
                            .resizable()
                            .frame(width: 25, height: 25)
                            .foregroundColor(.black)
                    }
                    Text("Call").foregroundColor(.secondary)
                }
                
            }
            Spacer()
            Button(action: {
                print("Hello")
                
            }){
                VStack{
                    ZStack {
                        Circle()
                            .frame(width: 50, height: 50)
                            .foregroundColor(Color.gray.opacity(0.6))
                        Image(systemName: "map")
                            .resizable()
                            .frame(width: 25, height: 25)
                            .foregroundColor(.black)
                    }
                    Text("View Map").foregroundColor(.secondary)
                }
            }
            Spacer()
            Button(action: {
                print("Hello")
                
            }){
                VStack{
                    ZStack {
                        Circle()
                            .frame(width: 50, height: 50)
                            .foregroundColor(Color.gray.opacity(0.6))
                        Image(systemName: "book")
                            .resizable()
                            .frame(width: 25, height: 25)
                            .foregroundColor(.black)
                    }
                    Text("Menu").foregroundColor(.secondary)
                }
                
            }
            Spacer()
            Button(action: {
                print("Hello")
                
            }){
                VStack{
                    ZStack {
                        Circle()
                            .frame(width: 50, height: 50)
                            .foregroundColor(Color.gray.opacity(0.6))
                        Image(systemName: "exclamationmark.circle")
                            .resizable()
                            .frame(width: 25, height: 25)
                            .foregroundColor(.black)
                    }
                    Text("More info").foregroundColor(.secondary)
                }
                
            }
            
        }
    }
}

struct LocalButtons_Previews: PreviewProvider {
    static var previews: some View {
        LocalButtons()
    }
}
