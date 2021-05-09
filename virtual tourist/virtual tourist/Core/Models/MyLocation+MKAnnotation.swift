//
//  MyLocation+MKAnnotation.swift
//  virtual tourist
//
//  Created by César Ferreira on 08/05/21.
//

import Foundation
import MapKit

extension MyLocation: MKAnnotation {
    
    public var coordinate: CLLocationCoordinate2D {
        let latDegrees = CLLocationDegrees(latitude)
        let longDegrees = CLLocationDegrees(longitude)
        return CLLocationCoordinate2D(latitude: latDegrees, longitude: longDegrees)
    }
}
