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
    @IBOutlet weak var mapView: MKMapView!
    
    //var midpoint: MidpointLocation!
    //create new midpoint location class that holds address + location name of midpoint coordinates
    //need to create variables that store myInfo and friendInfo, to be accessed
   
    var me: PersonalLocation!
    var friend: FriendLocation!
    //var coordinates : [CLLocationCoordinate2D] = []
    //var midpoint: CLLocationCoordinate2D
    var regionDistance: CLLocationDegrees = 750.0
    var locationManager: CLLocationManager!
    
    //var meCoordinate: PersonalLocation!
    //var friendCoordinate: FriendLocation!
    //friend coordinates --> friend.coordinate
    //me coordinates --> me.coordinate
    //var coordinates = [me.coordinate, friend.coordinate]
//    me.coordinate,friend.coordinate
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        var coordinates : [CLLocationCoordinate2D] = []
        var midpoint: CLLocationCoordinate2D
        coordinates.append(me.coordinate)
        coordinates.append(friend.coordinate)
        midpoint = geographicMidpoint(betweenCoordinates: coordinates)
        print(midpoint)
//
        //call geographicMidpoint function
        //returns a coordinate
        //midpointLabel.text = midpoint.name
    }
    
    
    @IBAction func cancelButtonPressed(_ sender: UIBarButtonItem) {
    }
    

//    func setUpMapView() {
//        let region = MKCoordinateRegion(center: midpoint, latitudinalMeters: regionDistance, longitudinalMeters: regionDistance)
//        mapView.setRegion(region, animated: true)
//    }
//
//    func updateUserInterface() {
//        midpointLabel.text = "\(midpoint)"
//        updateMap()
//    }
//
//    func updateMap() {
//        mapView.removeAnnotations(mapView.annotations)
//        mapView.addAnnotation(midpoint as! MKAnnotation)
//        mapView.setCenter(midpoint, animated: true)
//    }
//
    //function adapted from Stack Overflow: https://stackoverflow.com/questions/10559219/determining-midpoint-between-2-coordinates
    
  func geographicMidpoint(betweenCoordinates coordinates: [CLLocationCoordinate2D]) -> CLLocationCoordinate2D {

        guard coordinates.count > 1 else {
            return coordinates.first ?? // return the only coordinate
                CLLocationCoordinate2D(latitude: 0, longitude: 0) // return null island if no coordinates were given
        }
        var x = Double(0)
        var y = Double(0)
        var z = Double(0)
      
        for coordinate in coordinates {
            let lat = coordinate.latitude
            let lon = coordinate.longitude
            x += cos(lat) * cos(lon)
            y += cos(lat) * sin(lon)
            z += sin(lat)
        }
      
        x /= Double(coordinates.count)
        y /= Double(coordinates.count)
        z /= Double(coordinates.count)

        let lon = atan2(y, x)
        let hyp = sqrt(x * x + y * y)
        let lat = atan2(z, hyp)

        return CLLocationCoordinate2D(latitude: lat, longitude: lon)
    }
}

//extension MidpointViewController: CLLocationManagerDelegate {
//
//    func getLocation() {
//        // Creating a CLLocationManager will automatically check authorization
//        locationManager = CLLocationManager()
//        locationManager.delegate = self
//    }
//
//    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
//        print("👮‍♀️👮‍♀️ Checking authentication status.")
//        handleAuthenticationStatus(status: status)
//    }
//
//    func handleAuthenticationStatus(status: CLAuthorizationStatus) {
//        switch status {
//        case .notDetermined:
//            locationManager.requestWhenInUseAuthorization()
//        case .restricted:
//            self.oneButtonAlert(title: "Location services denied", message: "It may be that parental controls are restricting location use in this app.")
//        case .denied:
//            showAlertToPrivacySettings(title: "User has not authorized location services", message: "Select 'Settings' below to open device settings and enable location services for this app.")
//        case .authorizedAlways, .authorizedWhenInUse:
//            locationManager.requestLocation()
//        @unknown default:
//            print("DEVELOPER ALERT: Unknown case of status in handleAuthnticationStatus\(status)")
//        }
//    }
//
//    func showAlertToPrivacySettings(title: String, message: String) {
//        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
//        guard let settingsURL = URL(string: UIApplication.openSettingsURLString) else {
//            print("Something went wrong getting the UIApplication.openSettingsURLString")
//            return
//        }
//        let settingsAction = UIAlertAction(title: "Settings", style: .default) { _ in
//            UIApplication.shared.open(settingsURL, options: [:], completionHandler: nil)
//        }
//        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
//        alertController.addAction(settingsAction)
//        alertController.addAction(cancelAction)
//        present(alertController, animated: true, completion: nil)
//    }
//
//    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//
//        let currentLocation = locations.last ?? CLLocation()
//        print("🗺 Current location is \(currentLocation.coordinate.latitude), \(currentLocation.coordinate.longitude)")
//        var name = ""
//        var address = ""
//        let geocoder = CLGeocoder()
//        geocoder.reverseGeocodeLocation(currentLocation) { (placemarks, error) in
//            if error != nil {
//                print("ERROR: retrieving place. \(error!.localizedDescription)")
//            }
//            if placemarks != nil {
//                // get the first placemark
//                let placemark = placemarks?.last
//                // assign placemark to locationName
//                name = placemark?.name ?? "Name Unknown"
//                if let postalAddress = placemark?.postalAddress {
//                    address = CNPostalAddressFormatter.string(from: postalAddress, style: .mailingAddress)
//                }
//            } else {
//                print("ERROR: retrieving placemark.")
//
//            }
//            // if there is no location data, make device location the location
//            if self.adventure.name == "" && self.adventure.address == "" {
//                self.adventure.name = name
//                self.adventure.address = address
//                self.adventure.coordinate = currentLocation.coordinate
//            }
//            self.mapView.userLocation.title = name
//            self.mapView.userLocation.subtitle = address.replacingOccurrences(of: "\n", with: ", ")
//            self.updateUserInterface()
//        }
//    }
//
//    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
//        print("ERROR: \(error.localizedDescription). Failed to get device location.")
//    }
//}
//
