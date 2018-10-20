//
//  photoAnno.swift
//  Photo Map
//
//  Created by Sierra Klix on 10/20/18.
//  Copyright © 2018 Timothy Lee. All rights reserved.
//

import UIKit
import MapKit

class photoAnno: NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D = CLLocationCoordinate2DMake(0, 0)
    var photo: UIImage!
    
    var title: String? {
        return "\(coordinate.latitude)"
    }

}
