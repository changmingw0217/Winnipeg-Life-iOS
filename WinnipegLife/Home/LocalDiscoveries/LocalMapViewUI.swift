//
//  MapView.swift
//  WPGLife
//
//  Created by changming wang on 4/28/21.
//

import Foundation
import SwiftUI
import MapKit

struct LocalMapView: UIViewRepresentable{
    @EnvironmentObject var mapData: MapViewModel
    
    var address:String
    
    @Binding var expectedTravelTime:String
    @Binding var distance:String
    @Binding var latitude:Double
    @Binding var longitude:Double


    func makeUIView(context: UIViewRepresentableContext<LocalMapView>) -> MKMapView {
        let map = mapData.mapView
        map.showsUserLocation = true
        map.isRotateEnabled = false
        map.isUserInteractionEnabled = false
        map.delegate = context.coordinator
        if !address.isEmpty{
            let request = MKLocalSearch.Request()
            request.naturalLanguageQuery = address
            
            MKLocalSearch(request: request).start{(respons, _) in
                guard let result = respons else {return}
                for item in result.mapItems{
                    let start = MKPlacemark(coordinate: map.userLocation.coordinate)
                    let end = MKPlacemark(coordinate: item.placemark.coordinate)
                    latitude = end.coordinate.latitude
                    longitude = end.coordinate.longitude
                    let request = MKDirections.Request()
                    request.source = MKMapItem(placemark: start)
                    request.destination = MKMapItem(placemark: end)
                    request.transportType = .automobile
                    
                    let directions = MKDirections(request: request)
                    
                    let endAnnotation = MKPointAnnotation()
                    endAnnotation.coordinate = item.placemark.coordinate

                
                    directions.calculate { response, error in
                        guard let route = response?.routes.first else { return }
                        expectedTravelTime = mapData.expectedTravelTimeString(seconds: route.expectedTravelTime)
//                        distance = mapData.distanceSting(distance: route.distance)
                        let formatter = MKDistanceFormatter()
                        formatter.unitStyle = .default
                        distance = formatter.string(fromDistance: route.distance)
                        map.addAnnotation(endAnnotation)
                        map.addOverlay(route.polyline)
                        map.setVisibleMapRect(
                          route.polyline.boundingMapRect,
                          edgePadding: UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20),
                          animated: true)
                      }
                    
                    break
                }
            }
        }
        
        return map
    }
    
    
    
    func updateUIView(_ uiView: LocalMapView.UIViewType, context: UIViewRepresentableContext<LocalMapView>){

    }
    
    func makeCoordinator() -> Coordinator {
        return LocalMapView.Coordinator()
    }
    
    final class Coordinator: NSObject, MKMapViewDelegate{
        func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
            let renderer = MKPolylineRenderer(overlay: overlay)
            renderer.strokeColor = .systemBlue
            renderer.lineWidth = 4
            return renderer
        }
        
    }
}


