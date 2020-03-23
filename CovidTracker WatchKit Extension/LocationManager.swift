//
//  LocationManager.swift
//  CovidTracker
//
//  Created by Victor Santos on 3/23/20.
//  Copyright © 2020 Victor Santos. All rights reserved.
//

import Foundation
import CoreLocation
import Combine

class LocationManager: NSObject, ObservableObject {

    override init() {
        super.init()
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.startUpdatingLocation()
    }
    
    public var exposedLocation: CLLocation? {
           return self.locationManager.location
    }

    @Published var locationStatus: CLAuthorizationStatus? {
        willSet {
            objectWillChange.send()
        }
    }

    @Published var lastLocation: CLLocation? {
        willSet {
            objectWillChange.send()
        }
    }

    var statusString: String {
        guard let status = locationStatus else {
            return "unknown"
        }

        switch status {
        case .notDetermined: return "notDetermined"
        case .authorizedWhenInUse: return "authorizedWhenInUse"
        case .authorizedAlways: return "authorizedAlways"
        case .restricted: return "restricted"
        case .denied: return "denied"
        default: return "unknown"
        }

    }

    let objectWillChange = PassthroughSubject<Void, Never>()

    private let locationManager = CLLocationManager()
    
   
    
}

extension LocationManager: CLLocationManagerDelegate {

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        self.locationStatus = status
        print(#function, statusString)
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        self.lastLocation = location
  
        guard let loc = self.locationManager.location else { return }
        
        getPlace(for: loc) { (placemark) in
            print(placemark?.country)
            print(placemark?.administrativeArea)
        }
        print(#function, location)
    }
    
   
    
    func getPlace(for location: CLLocation, completion: @escaping (CLPlacemark?) -> Void) {
              
        
             let geocoder = CLGeocoder()
             geocoder.reverseGeocodeLocation(location) { placemarks, error in
                 
                 guard error == nil else {
                     print("*** Error in \(#function): \(error!.localizedDescription)")
                     completion(nil)
                     return
                 }
                 
                 guard let placemark = placemarks?[0] else {
                     print("*** Error in \(#function): placemark is nil")
                     completion(nil)
                     return
                 }
                 
                 completion(placemark)
             }
         }
      
}
