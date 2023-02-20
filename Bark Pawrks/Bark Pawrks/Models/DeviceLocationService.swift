//
//  ParkLocation.swift
//  Bark Pawrks
//
//  Created by Naser Sadat on 11/14/22.
//

import Foundation
import Combine
import CoreLocation

/* Location Class from
 https://www.kiloloco.com/articles/014-device-location-ios/
 */
//Class to get device location from iphone and publishes it for the app to use
class DeviceLocationService: NSObject, CLLocationManagerDelegate, ObservableObject {
    //Publishes longitude and latitude coodinates
    var coordinatesPublisher = PassthroughSubject<CLLocationCoordinate2D, Error>()
    //Checks if location permission is granted or denied
    var deniedLocationAccessPublisher = PassthroughSubject<Void, Never>()

    private override init() {
        super.init()
    }
    //Instance of device location service
    static let shared = DeviceLocationService()

    private lazy var locationManager: CLLocationManager = {
        let manager = CLLocationManager()
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.delegate = self
        return manager
    }()
    
    //function that requests location service authorization status
    func requestLocationUpdates() {
        switch locationManager.authorizationStatus {
            
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
            
        case .authorizedWhenInUse, .authorizedAlways:
            locationManager.startUpdatingLocation()
            
        default:
            deniedLocationAccessPublisher.send()
        }
    }
    
    //Function that prompts for location authorization permission
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
            
        case .authorizedWhenInUse, .authorizedAlways:
            manager.startUpdatingLocation()
            
        default:
            manager.stopUpdatingLocation()
            deniedLocationAccessPublisher.send()
        }
    }
    
    //function that gets the last location coordinates
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print(locations)
        guard let location = locations.last else { return }
        coordinatesPublisher.send(location.coordinate)
    }
    
    //Publishes errors
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        coordinatesPublisher.send(completion: .failure(error))
    }
}
