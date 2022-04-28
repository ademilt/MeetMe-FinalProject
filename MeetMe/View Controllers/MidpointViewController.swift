//
//  MidpointViewController.swift
//  MeetMe
//
//  Created by Annie DeMilt on 4/25/22.
//

import UIKit
import CoreLocation
import GooglePlaces
import MapKit
import Contacts


class MidpointViewController: UIViewController {
    
    @IBOutlet weak var midpointLabel: UILabel!
   // var midpoint: PersonalLocation!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //call geographicMidpoint function
        //returns a coordinate
        //midpointLabel.text = midpoint.name
    }
    
    @IBAction func cancelButtonPressed(_ sender: UIBarButtonItem) {
    }
    
    
    //function adapted from Stack Overflow: https://stackoverflow.com/questions/10559219/determining-midpoint-between-2-coordinates
    
//    func geographicMidpoint(betweenCoordinates coordinates: [CLLocationCoordinate2D]) -> CLLocationCoordinate2D {
//
//        guard coordinates.count > 1 else {
//            return coordinates.first ?? // return the only coordinate
//                CLLocationCoordinate2D(latitude: 0, longitude: 0) // return null island if no coordinates were given
//        }
//
//        var x = Double(0)
//        var y = Double(0)
//        var z = Double(0)
//
//        for coordinate in coordinates {
//            let lat = coordinate.latitude.toRadians()
//            let lon = coordinate.longitude.toRadians()
//            x += cos(lat) * cos(lon)
//            y += cos(lat) * sin(lon)
//            z += sin(lat)
//        }
//
//        x /= Double(coordinates.count)
//        y /= Double(coordinates.count)
//        z /= Double(coordinates.count)
//
//        let lon = atan2(y, x)
//        let hyp = sqrt(x * x + y * y)
//        let lat = atan2(z, hyp)
//
//        return CLLocationCoordinate2D(latitude: lat.toDegrees(), longitude: lon.toDegrees())
//    }
//}
}
