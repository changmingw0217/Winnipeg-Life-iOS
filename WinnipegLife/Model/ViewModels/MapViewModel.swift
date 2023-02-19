//
//  MapViewModel.swift
//  WPGLife
//
//  Created by changming wang on 4/28/21.
//

import SwiftUI
import MapKit
import CoreLocation

class MapViewModel: NSObject,ObservableObject, CLLocationManagerDelegate{
    
    @Published var mapView = MKMapView()
    
    @Published var routePolyline: MKPolyline?
    @Published var distance:String?
    @Published var expectedTravelTime:String?
    
    var requestedDirections = false
    var startLocation: CLLocation?
    var endLocation: CLLocation?
    var locationManager = CLLocationManager()
    
    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    func startLocationServices() {
        if locationManager.authorizationStatus == .authorizedAlways || locationManager.authorizationStatus == .authorizedWhenInUse {
            locationManager.startUpdatingLocation()
        } else {
            locationManager.requestWhenInUseAuthorization()
        }
    }
    
    
    func secondsToHoursMinutesSeconds (seconds : Double) -> (Int, Int, Int) {
        let (hr,  minf) = modf (seconds / 3600)
        let (min, secf) = modf (60 * minf)
        return (Int(hr), Int(min), Int(60 * secf))
    }
    
    func expectedTravelTimeString(seconds: Double) -> String{
        
        let time = self.secondsToHoursMinutesSeconds(seconds: seconds)
        var hours:String = ""
        var min:String = ""
        let seconds:String = String(time.2)
        let str = "Drive"
        var final:String
        if time.0 != 0 {
            hours = String(time.0)
        }
        
        if time.1 != 0 {
            min = String(time.1)
        }
        
        if !hours.isEmpty {
            if !min.isEmpty {
                final = hours + " Hours " + min + " Mins " + str
            }else{
                final = hours + " Hours " + str
            }
        }else{
            if !min.isEmpty{
                
                if time.2 > 30 {
                    min = String(time.1 + 1)
                    final = min + " Mins " + str
                }else{
                    final = min + " Mins " + str
                }
                
            }else{
                final = seconds + " Sec " + str
            }
        }
        
        return final
    }
    
    func requestDirections(address: String) {
        if !address.isEmpty{
            let request = MKLocalSearch.Request()
            request.naturalLanguageQuery = address
            
            MKLocalSearch(request: request).start{(respons, _) in
                guard let result = respons else {return}
                
                for item in result.mapItems{
                    self.endLocation = item.placemark.location
                    break
                }
            }
        }
        startLocationServices()
        requestedDirections = true
    }
    
    func fetchDirections() {

        guard let startLocation = startLocation, let endLocation = endLocation else {
            return
        }
        let startMapItem = MKMapItem(placemark: MKPlacemark(coordinate: startLocation.coordinate))
        let endMapItem = MKMapItem(placemark: MKPlacemark(coordinate: endLocation.coordinate))
        let request = MKDirections.Request()
        request.source = startMapItem
        request.destination = endMapItem
        request.requestsAlternateRoutes = false
        request.transportType = .automobile
        let mapDirections = MKDirections(request: request)
        mapDirections.calculate { [weak self] response, error in
            if let route = response?.routes.first {
                self?.routePolyline = route.polyline
                let formatter = MKDistanceFormatter()
                formatter.unitStyle = .default
                self?.distance = formatter.string(fromDistance: route.distance)
                self?.expectedTravelTime = self!.expectedTravelTimeString(seconds: route.expectedTravelTime)
            }
        }
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        if locationManager.authorizationStatus == .authorizedAlways || locationManager.authorizationStatus == .authorizedWhenInUse {
            locationManager.startUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        guard let clError = error as? CLError else { return }
        switch clError {
        case CLError.denied:
            print("Access denied")
        default:
            print("Catch all errors")
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let loction = locations.first else {return}
        
        if requestedDirections {
            startLocation = loction
            fetchDirections()
            requestedDirections = false
        }
    }
    
    
}

