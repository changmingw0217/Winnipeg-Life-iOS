//
//  FoodDetailView.swift
//  WinnipegLife
//
//  Created by changming wang on 8/19/21.
//

import SwiftUI
import SDWebImageSwiftUI
import MapKit
import ActivityIndicatorView

struct FoodDetailView: View {
    
    let topSafeHeight = UIApplication.shared.windows[0].safeAreaInsets.top
    
    @Environment(\.presentationMode) var presentation
    
    @StateObject var content: CommonViewModel
    
    @StateObject var mapData = MapViewModel()
    
    @StateObject var viewer = ImageViewer()
    
    @State var isGalleryActive: Bool = false
    
    @State private var scrollOffset: CGFloat = .zero
    
    @GestureState var draggingOffset: CGSize = .zero
    
    @State var expectedTravelTime: String = ""
    
    @State var distance: String = ""
    
    @State var latitude: Double = 0
    
    @State var longitude: Double = 0
    
    @State private var showingOptions = false
    
    let title:String
    
    @State var buffer: Bool = false {
        didSet{
            if !buffer{
                isGalleryActive = true
            }
        }
    }
    
    var body: some View {
        NavigationView{
            ZStack{
                VStack{
                    if content.isLoading{
                        SimpleRefreshingView()
                            .padding()
                    }else{
                        ZStack(alignment: .top){
                            ZStack(alignment:. bottom){
                                ScrollViewOffset{  offset in
                                    
                                    DispatchQueue.main.async {
                                        scrollOffset = offset
                                    }
                                    
                                    if scrollOffset > (125 - topSafeHeight){
                                        buffer = true
                                    }else{
                                        if buffer{
                                            buffer = false
                                        }
                                    }
                                    
                                } content: {
                                    
                                    NavigationLink.init(destination: LocalGalleryView(imageLinks: content.viewContent.attachmentsImageUrls), isActive: $isGalleryActive) {}
                                    
                                    GeometryReader{reader -> AnyView in
                                        
                                        let offset = reader.frame(in: .global).minY
                                        
                                        return AnyView(
                                            ZStack(alignment: .bottomLeading){
                                                LocalPhotosView(imageUrls: content.viewContent.attachmentsImageUrls, offset: offset)
                                                    .overlay(
                                                        VStack(alignment: .leading){
                                                            Text(content.viewContent.storeName)
                                                                .font(.largeTitle)
                                                                .foregroundColor(.white)
                                                                .fontWeight(.bold)
                                                                .padding()
                                                            
                                                            
                                                            HStack{
                                                                Spacer()
                                                                Button(action: {
                                                                    isGalleryActive.toggle()
                                                                }){
                                                                    if offset < 125{
                                                                        Text("查看全部图片")
                                                                            .foregroundColor(.white)
                                                                            .background(
                                                                                Color.black.opacity(0.4)
                                                                            )
                                                                            .shadow(color: Color.black.opacity(0.4), radius: 5)
                                                                    }else{
                                                                        Text("释放查看全部")
                                                                            .foregroundColor(.white)
                                                                            .background(
                                                                                Color.black.opacity(0.4)
                                                                            )
                                                                            .shadow(color: Color.black.opacity(0.4), radius: 5)
                                                                    }
                                                                    
                                                                }
                                                                
                                                            }.padding(.trailing, 20)
                                                        }.padding(.bottom, 30)
                                                            .offset(y: (offset > 0 ? -offset : 0))
                                                        ,alignment: .bottom
                                                    )
                                            }
                                        )
                                    }
                                    .frame(width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height/3 - 50)
                                    
                                    
                                    if !content.viewContent.storeVideoId.isEmpty{
                                        HStack{
                                            Text("视频介绍")
                                                .font(.title)
                                            Spacer()
                                        }.padding([.top, .bottom, .leading], 10)
                                        
                                        
                                        youtubeView(videoID: content.viewContent.storeVideoId).frame(width: UIScreen.main.bounds.size.width, height: 200)
                                    }
                                    
                                    VStack(alignment: .leading){
                                        
                                        HStack{
                                            Text("店铺简介").font(.title)
                                            
                                            Spacer()
                                        }.padding(.bottom,10)
                                            .padding(.horizontal, 10)
                                        
                                        ForEach(0..<content.viewContent.htmlContent.count){ index in
                                            let data = content.viewContent.htmlContent[index]
                                            let key = Array(data.keys)[0]
                                            
                                            if key == "p" {
                                                Text(data["p"]!)
                                                    .fixedSize(horizontal: false, vertical: true)
                                                    .frame(maxWidth: .infinity, alignment: .leading)
                                                    .padding(.horizontal, 10)
                                            }else if key == "img" {
                                                let url = data["img"]!
                                                
                                                WebImage(url: URL(string: url))
                                                    .resizable()
                                                    .indicator(Indicator.progress)
                                                    .aspectRatio(contentMode: .fill)
                                                    .padding(10)
                                                    .onTapGesture(){
                                                        withAnimation(.easeInOut) {
                                                            UIScrollView.appearance().bounces = false
                                                            viewer.showImageViewer.toggle()
                                                            viewer.imageIndex = content.contentImageIndex[index]
                                                        }
                                                        
                                                    }
                                                
                                            }
                                        }
                                    }
                                    .frame(width: UIScreen.main.bounds.size.width)
                                    .padding(.top, 20)
                                    
                                    
                                    
                                    LocalMapView(address: content.viewContent.storeAddress, expectedTravelTime: $expectedTravelTime, distance: $distance ,latitude: $latitude, longitude:$longitude).environmentObject(mapData)
                                        .frame(height: 200)
                                        .padding(.top,20)
                                    VStack{
                                        VStack{
                                            HStack{
                                                Image(systemName: "car").font(.title2).foregroundColor(.primary)
                                                Text(self.expectedTravelTime).foregroundColor(.primary)
                                                Spacer()
                                                Text(self.distance).foregroundColor(.secondary)
                                            }
                                            
                                            HStack {
                                                Text(content.viewContent.storeAddress).font(.subheadline).foregroundColor(.secondary)
                                                Spacer()
                                            }
                                            
                                        }.padding(.horizontal, 10)
                                        
                                        Divider().padding(.horizontal, 10)
                                        
                                        Button(action: {
                                            showingOptions.toggle()
                                        }, label: {
                                            HStack{
                                                Text("地图导航").foregroundColor(.primary).font(.title2)
                                                Spacer()
                                                Image(systemName: "location.circle")
                                                    .font(.title2)
                                                    .foregroundColor(.primary)
                                            }
                                        })
                                            .actionSheet(isPresented: $showingOptions) {
                                                ActionSheet(
                                                    title: Text("请选择导航软件"),
                                                    buttons: [
                                                        .default(Text("打开Apple地图")) {
                                                            openAppleMap()
                                                        },
                                                        .default(Text("打开Google地图")) {
                                                            openGoogleMap()
                                                        },
                                                        .cancel(Text("取消"))
                                                    ]
                                                )
                                            }
                                            .padding(.horizontal, 10)
                                        
                                        Divider().padding(.horizontal, 10)
                                        
                                        Button(action: {
                                            let tel = "tel://"
                                            let formattedString = tel + content.viewContent.storePhone
                                            guard let url = URL(string: formattedString) else { return }
                                            UIApplication.shared.open(url)
                                        }, label: {
                                            HStack{
                                                VStack(alignment: .leading){
                                                    Text("联系电话").foregroundColor(.primary).font(.title2)
                                                        .foregroundColor(.primary)
                                                    Text(content.viewContent.formattedPhone).font(.subheadline).foregroundColor(.secondary)
                                                }
                                                
                                                Spacer()
                                                Image(systemName: "phone.arrow.up.right")
                                                    .font(.title2)
                                                    .foregroundColor(.primary)
                                            }
                                        })
                                            .padding(.horizontal, 10)
                                        
                                    }.padding(.top, 10)
                                    
                                    
                                    
                                }
                                .padding(.bottom, 50)
                                .overlay(
                                    
                                    Color.white
                                        .frame(height: UIApplication.shared.windows.first?.safeAreaInsets.top)
                                        .ignoresSafeArea(.all, edges: .top)
                                        .opacity(opacity)
                                    ,alignment: .top
                                )
                                
                                FoodOrderBar(storeOwnerId: content.viewContent.storeOwnerId, threadId: content.pid)
                            }
                            
                            ZStack{
                                
                                Color.white.frame(width: UIScreen.main.bounds.size.width, height: 50)
                                    .opacity(opacity)
                                
                                VStack(spacing: 0){
                                    HStack{
                                        Button(action: { presentation.wrappedValue.dismiss() }) {
                                            Image(systemName: "chevron.left")
                                                .foregroundColor(-scrollOffset > (opacityThreshold - 20) ? .orange : .white)
                                                .imageScale(.large)
                                        }.padding(.leading, 10)
                                        
                                        Spacer()
                                        
                                        Text(content.viewContent.storeName)
                                            .font(.system(size: 20.0))
                                            .foregroundColor(.black)
                                            .opacity(-scrollOffset > (opacityThreshold - 20) ? 1 : 0)
                                            .lineLimit(1)
                                            .frame(minWidth: 0, maxWidth: 150)
                                        
                                        Spacer()
                                        
                                    }.frame(width: UIScreen.main.bounds.size.width, height: 50)
                                    
                                }
                            }.frame(width: UIScreen.main.bounds.size.width, height: 50)
                            
                            
                        }
                    }
                }
            }
            .overlay(
                ImageView(urls: content.viewContent.contentImageUrls)
            )
            .environmentObject(viewer)
            .onAppear(perform: {
                content.requestData()
                mapData.startLocationServices()
            })
            .navigationBarTitle("")
            .navigationBarHidden(true)
        }
        .navigationBarTitle("")
        .navigationBarHidden(true)
    }
}

private extension FoodDetailView{
    
    var opacityThreshold: CGFloat {
        return UIScreen.main.bounds.size.height/3 - 50 - topSafeHeight
    }
    
    
    var opacity: Double {
        switch scrollOffset {
        case -(opacityThreshold)...0:
            return Double(-scrollOffset) / Double(opacityThreshold)
        case ...(-opacityThreshold):
            return 1
        default:
            return 0
        }
    }
    
    func openAppleMap() {
        let latitude: CLLocationDegrees = latitude
        let longitude: CLLocationDegrees = longitude
        let regionDistance:CLLocationDistance = 1000
        let coordinates = CLLocationCoordinate2DMake(latitude, longitude)
        let regionSpan = MKCoordinateRegion(center: coordinates, latitudinalMeters: regionDistance, longitudinalMeters: regionDistance)
        let options = [
            MKLaunchOptionsMapCenterKey: NSValue(mkCoordinate: regionSpan.center),
            MKLaunchOptionsMapSpanKey: NSValue(mkCoordinateSpan: regionSpan.span)
        ]
        let placemark = MKPlacemark(coordinate: coordinates, addressDictionary: nil)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = content.viewContent.storeName
        mapItem.openInMaps(launchOptions: options)
    }
    
    func openGoogleMap() {
        let queryString = content.viewContent.storeAddress.replacingOccurrences(of: " ", with: "+")
        UIApplication.shared.open(URL(string: "http://maps.google.com/maps?q=" + queryString + "&center=\(latitude),\(longitude)&zoom=15&views=traffic")!, options: [:], completionHandler: nil)
        
    }
}

//struct FoodDetailView_Previews: PreviewProvider {
//    static var previews: some View {
//        FoodDetailView()
//    }
//}
