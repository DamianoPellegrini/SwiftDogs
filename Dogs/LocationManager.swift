//
//  LocationManager.swift
//  Dogs
//
//  Created by Damiano Pellegrini on 02/10/22.
//

import Foundation
import CoreLocation

final class LocationManager : NSObject, ObservableObject {
    private let locationManager = CLLocationManager()
    
    @Published var currentLocation: CLLocation?
    @Published var currentHeading: CLHeading?
    
    private var resumeLocationUpdates: (() -> Void)?
    
    func onResumeLocationUpdates(action callback: @escaping () -> Void) {
        
        resumeLocationUpdates = callback
    }
    
    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
    }
}

extension LocationManager: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations: [CLLocation]) {
        for location in didUpdateLocations {
            currentLocation = location
        }
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError: Error) {
        
    }
    
    func locationManagerDidPauseLocationUpdates(_ manager: CLLocationManager){
        
    }
    
    func locationManagerDidResumeLocationUpdates(_ manager: CLLocationManager) {
        resumeLocationUpdates?()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateHeading: CLHeading) {
        self.currentHeading = didUpdateHeading
    }
}
