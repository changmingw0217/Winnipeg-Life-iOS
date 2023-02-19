//
//  ShopView.swift
//  WinnipegLife
//
//  Created by changming wang on 10/11/21.
//

import SwiftUI
import SDWebImageSwiftUI
import WaterfallGrid
struct ShopView: View {
    
    @Environment(\.presentationMode) var presentation
    
    var body: some View {
        VStack(spacing :15){
            ZStack{
                Text("Moose Trading").font(.title)
                
                HStack(spacing: 18){
                    
                    Button(action: { presentation.wrappedValue.dismiss() }) {
                        Image(systemName: "chevron.left")
                            .imageScale(.large)
                            .foregroundColor(.orange)
                    }
                    
                    Spacer()
                    
                    Button(action : {
                        
                    }){
                        Image(systemName: "magnifyingglass.circle")
                            .imageScale(.large)
                            .foregroundColor(.orange)
                    }
                }
            }.background(Color.white)
                .padding([.leading, .trailing, .top], 15)
            
            
            ShopMainView()
        }.navigationBarBackButtonHidden(true)
            .navigationTitle("")
            .navigationBarHidden(true)
    }
}

//struct ShopView_Previews: PreviewProvider {
//    static var previews: some View {
//        ShopView()
//    }
//}

struct ShopMainView: View {
    
    let columns = Array(repeating: GridItem(.flexible()), count: 2)
    
    
    let cards = [ShopCard(name: "plastic fork(soft)", price: "12.68", image: "https://mose.lifewpg.com/image/cache/catalog/1863557-228x228.jpeg"),
                 
                 ShopCard(name: "plastic knife (soft）", price: "12.59", image: "https://mose.lifewpg.com/image/cache/catalog/1863873-228x228.jpeg"),
                 
                 ShopCard(name: "plastic spoon HD", price: "18.89", image: "https://mose.lifewpg.com/image/cache/catalog/814045-228x228.jpeg"),
                 
                 ShopCard(name: "Plastic spoon(soft）", price: "12.08", image: "https://mose.lifewpg.com/image/cache/catalog/814045-228x228.jpeg"),
                 
                 ShopCard(name: "plastic fork(soft)", price: "12.68", image: "https://mose.lifewpg.com/image/cache/catalog/1863557-228x228.jpeg"),
                 
                 ShopCard(name: "plastic knife (soft）", price: "12.59", image: "https://mose.lifewpg.com/image/cache/catalog/1863873-228x228.jpeg"),
                 
                 ShopCard(name: "plastic spoon HD", price: "18.89", image: "https://mose.lifewpg.com/image/cache/catalog/814045-228x228.jpeg"),
                 
                 ShopCard(name: "Bio Hinge Lid Sugarcane Box (M) 9x9x3", price: "71.79", image: "https://mose.lifewpg.com/image/cache/catalog/Biodegradable-and-Compostable-Sugarcane-Bagasse-Clamshells.17.3-2-228x228.jpg"),
                 
                 ShopCard(name: "Plastic spoon(soft）", price: "12.08", image: "https://mose.lifewpg.com/image/cache/catalog/814045-228x228.jpeg"),
                 
                 
                 
                 ShopCard(name: "Bio Hinge Lid Sugarcane Box-3 (L) 9x9x3", price: "71.94", image: "https://mose.lifewpg.com/image/cache/catalog/814045-228x228.jpeg")
    ]
    
    var body: some View{
        VStack{
            ScrollView{
                
                WaterfallGrid(cards){ card in
                    ShopCardView(card: card)
                    
                }
                .gridStyle(
                    columnsInPortrait: 2,
                    spacing: 8,
                    animation: nil
                )
                .padding(.horizontal, 10)
                
                
//                LazyVGrid(columns: columns){
//                    ShopCardView(card: ShopCard(name: "plastic fork(soft)", price: "12.68", image: "https://mose.lifewpg.com/image/cache/catalog/1863557-228x228.jpeg"))
//
//                    ShopCardView(card: ShopCard(name: "plastic knife (soft）", price: "12.59", image: "https://mose.lifewpg.com/image/cache/catalog/1863873-228x228.jpeg"))
//
//                    ShopCardView(card: ShopCard(name: "plastic spoon HD", price: "18.89", image: "https://mose.lifewpg.com/image/cache/catalog/814045-228x228.jpeg"))
//
//                    ShopCardView(card: ShopCard(name: "Plastic spoon(soft）", price: "12.08", image: "https://mose.lifewpg.com/image/cache/catalog/814045-228x228.jpeg"))
//
//                    ShopCardView(card: ShopCard(name: "plastic fork(soft)", price: "12.68", image: "https://mose.lifewpg.com/image/cache/catalog/1863557-228x228.jpeg"))
//
//                    ShopCardView(card: ShopCard(name: "plastic knife (soft）", price: "12.59", image: "https://mose.lifewpg.com/image/cache/catalog/1863873-228x228.jpeg"))
//
//                    ShopCardView(card: ShopCard(name: "plastic spoon HD", price: "18.89", image: "https://mose.lifewpg.com/image/cache/catalog/814045-228x228.jpeg"))
//
//                    ShopCardView(card: ShopCard(name: "Bio Hinge Lid Sugarcane Box (M) 9x9x3", price: "71.79", image: "https://mose.lifewpg.com/image/cache/catalog/Biodegradable-and-Compostable-Sugarcane-Bagasse-Clamshells.17.3-2-228x228.jpg"))
//
//                    ShopCardView(card: ShopCard(name: "Plastic spoon(soft）", price: "12.08", image: "https://mose.lifewpg.com/image/cache/catalog/814045-228x228.jpeg"))
//
//
//
//                    ShopCardView(card: ShopCard(name: "Bio Hinge Lid Sugarcane Box-3 (L) 9x9x3", price: "71.94", image: "https://mose.lifewpg.com/image/cache/catalog/814045-228x228.jpeg"))
//
//
//                }.padding(.horizontal, 10)
            }
        }
        .padding(.top, 10)
        .background(Color.black.opacity(0.05).ignoresSafeArea())
    }
}

struct ShopCardView : View {
    
    let card:ShopCard
    
    var body: some View{
        VStack(spacing: 8){
            if !card.image.isEmpty {
                WebImage(url: URL(string: card.image))
                    .resizable()
                    .indicator(Indicator.progress)
                    .aspectRatio(contentMode: .fit)
                    .clipped()
                    
            }else{
                Image("Logo").resizable()
                    .aspectRatio(contentMode: .fit)
                    .clipped()
                    
            }
            
            
            HStack{
                VStack(alignment:.leading,spacing: 10){
                    Text(card.name)
                    
                    Text("$")
                        .fontWeight(.heavy) +
                    Text(card.price)
                        .fontWeight(.heavy)
                }.padding(.leading, 8)
                
                
                Spacer()
            }.padding(.bottom, 10)
            
        }
        .cornerRadius(8)
        .background(
            RoundedRectangle(cornerRadius: 8)
                .stroke(Color.secondary.opacity(0.5))
        )
        
    }
}


struct ShopCard: Identifiable {
    var id = UUID()
    var name: String = ""
    var price: String = ""
    var image: String = ""
}
