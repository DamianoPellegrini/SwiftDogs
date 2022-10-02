//
//  GPSView.swift
//  Dogs
//
//  Created by Damiano Pellegrini on 02/10/22.
//

import SwiftUI
import MapKit
import CoreLocation

struct GPSView: View {
    @State private var coordinateRegion = MKCoordinateRegion(center: .init(latitude: 43, longitude: 11), latitudinalMeters: 500, longitudinalMeters: 500)
    
    @State private var userTrackingMode: MapUserTrackingMode = .follow
    
    @State private var resumed = false
    
    @ObservedObject private var locationManager = LocationManager()
    
    var body: some View {
        if locationManager.currentLocation == nil {
            ProgressView()
        } else {
            VStack {
                Text("\(locationManager.currentLocation!.coordinate.latitude), \(locationManager.currentLocation!.coordinate.longitude)")
                Map(coordinateRegion: $coordinateRegion, showsUserLocation: true, userTrackingMode: $userTrackingMode)
                    .ignoresSafeArea()
                    .onReceive(locationManager.$currentLocation) { value in
                        if value != nil {
                            coordinateRegion.center = value!.coordinate
                        }
                    }
            }
        }
    }
}

struct GPSView_Previews: PreviewProvider {
    static var previews: some View {
        GPSView()
    }
}
