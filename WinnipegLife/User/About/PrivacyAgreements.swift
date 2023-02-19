//
//  PrivacyAgreenemtsView.swift
//  WinnipegLife
//
//  Created by changming wang on 6/21/21.
//

import SwiftUI


struct PrivacyAgreementsView: View {
    @Environment(\.presentationMode) var presentation
    
    let documentURL = Bundle.main.url(forResource: "App-Privacy-Policy", withExtension: "pdf")
    
    var body: some View {
        ZStack(alignment: .top){
            
            VStack{
                PDFKitView(url: documentURL!)
            }.padding(.top, 50)
            
            
            
            ZStack{
                
                Color("SystemColor").frame(width: UIScreen.main.bounds.size.width, height: 50 + UIApplication.shared.windows[0].safeAreaInsets.top)
                    .ignoresSafeArea(.all, edges: .top)
                
                VStack(spacing: 0){
                    HStack{
                        Button(action: { presentation.wrappedValue.dismiss() }) {
                            Image(systemName: "chevron.left")
                                .imageScale(.large)
                                .foregroundColor(.orange)
                        }.padding(.leading, 10)
                        
                        Spacer()
                        
                        Text("隐私政策")
                            .font(.system(size: 20.0))
                            .foregroundColor(.black)
                            .lineLimit(1)
                            .frame(minWidth: 0, maxWidth: 150)
                        
                        Spacer()
                        
                    }.frame(width: UIScreen.main.bounds.size.width, height: 50)
                    
                }
            }.frame(width: UIScreen.main.bounds.size.width, height: 50)
        }
        .navigationBarHidden(true)

    }
}


