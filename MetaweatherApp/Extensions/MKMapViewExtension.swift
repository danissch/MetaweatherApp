//
//  MKMapViewExtension.swift
//  MetaweatherApp
//
//  Created by Daniel Duran Schutz on 19/06/21.
//

import Foundation
import MapKit
import CoreLocation

extension MKMapView {
  func centerToLocation(
    _ location: CLLocation,
    regionRadius: CLLocationDistance = 40000
  ) {
    let coordinateRegion = MKCoordinateRegion(
      center: location.coordinate,
      latitudinalMeters: regionRadius,
      longitudinalMeters: regionRadius)
    setRegion(coordinateRegion, animated: true)
  }
}

