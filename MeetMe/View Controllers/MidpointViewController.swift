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
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var midpointIntro: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var saveBarButton: UIBarButtonItem!
    @IBOutlet weak var cancelBarButton: UIBarButtonItem!
    
    var me: PersonalLocation!
    var friend: FriendLocation!
    var midpoint: MidpointLocation!
    var currentUser: AdventureUser!

    var regionDistance: CLLocationDegrees = 750.0
    var locationManager: CLLocationManager!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        midpoint = MidpointLocation()
        
        //basic UI
        UISetup()
        
        //adding coordinates to list of CLLocationCoordinate2D type to convert to midpoint
        var coordinates : [CLLocationCoordinate2D] = []
        coordinates.append(me.coordinate)
        coordinates.append(friend.coordinate)
        midpoint.coordinate = geographicMidpoint(betweenCoordinates: coordinates)
        print(midpoint.coordinate)
        
        midpointIntro.text = "\(me.firstName) and \(friend.friendName)'s midpoint"
        
        getLocation()
        if midpoint == nil {
            midpoint = MidpointLocation()
        }
        setUpMapView()
        updateUserInterface()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        updateFromInterface()
        if segue.identifier == "midpointSearch" {
            let destination = segue.destination as! SearchViewController
            destination.me = me
            destination.friend = friend
            destination.midpoint = midpoint
            destination.currentUser = currentUser
        }
    }
    
    func setUpMapView() {
        let region = MKCoordinateRegion(center: midpoint.coordinate, latitudinalMeters: regionDistance, longitudinalMeters: regionDistance)
        mapView.setRegion(region, animated: true)
    }
    
    func updateUserInterface() {
        locationLabel.text = midpoint.name
        addressLabel.text = midpoint.address
        updateMap()
        setupAnnotations()
    }
    
    func updateMap() {
        mapView.removeAnnotations(mapView.annotations)
        mapView.addAnnotation(midpoint)
        mapView.setCenter(midpoint.coordinate, animated: true)
    }
    
    func setupAnnotations() {
        let places = me.map { placeOnMap -> MKPointAnnotation in
            let place = MKPointAnnotation()
            place.coordinate =  CLLocationCoordinate2D(latitude: placeOnMap.latitude, longitude: placeOnMap.longitude)
            place.title = placeOnMap.firstName
            return place
        }
        
        let places1 = friend.map { placeOnMap -> MKPointAnnotation in
            let place = MKPointAnnotation()
            place.coordinate =  CLLocationCoordinate2D(latitude: placeOnMap.latitude, longitude: placeOnMap.longitude)
            place.title = placeOnMap.friendName
            return place
        }
        mapView.addAnnotation(places!)
        mapView.addAnnotation(places1!)
        mapView.showAnnotations(self.mapView.annotations, animated: true)
    }
    
    func updateFromInterface() {
        midpoint.name = locationLabel.text!
        midpoint.address = addressLabel.text!
    }
    
    func leaveViewController(){
        let isPresentingInAddMode = presentingViewController is UINavigationController
        if isPresentingInAddMode{
            dismiss(animated: true, completion: nil)
        } else {
            navigationController?.popViewController(animated: true)
        }
    }
    
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
            let lat = coordinate.latitude.degreesToRadians
            let lon = coordinate.longitude.degreesToRadians
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
        
        return CLLocationCoordinate2D(latitude: lat.radiansToDegrees, longitude: lon.radiansToDegrees)
    }
    
    @IBAction func cancelButtonPressed(_ sender: UIBarButtonItem) {
        leaveViewController()
    }
    
    @IBAction func saveButtonPressed(_ sender: Any) {
        updateFromInterface()
        midpoint.saveData(person: me, friend: friend) { success in
            if success {
                self.performSegue(withIdentifier: "midpointSearch", sender: nil)
            } else {
                //ERROR during save occured
                self.oneButtonAlert(title: "Save Failed", message: "For some reason the data would not save to the cloud")
            }
        }
    }
}

//extension to convert given lat/long coordinates between radians and degrees and find midpoint
extension FloatingPoint {
    var degreesToRadians: Self { self * .pi / 180 }
    var radiansToDegrees: Self { self * 180 / .pi }
}

extension MidpointViewController: CLLocationManagerDelegate {
    
    func getLocation() {
        // Creating a CLLocationManager will automatically check authorization
        locationManager = CLLocationManager()
        locationManager.delegate = self
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        print("👮‍♀️👮‍♀️ Checking authentication status.")
        handleAuthenticationStatus(status: status)
    }
    
    func handleAuthenticationStatus(status: CLAuthorizationStatus) {
        switch status {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .restricted:
            self.oneButtonAlert(title: "Location services denied", message: "It may be that parental controls are restricting location use in this app.")
        case .denied:
            showAlertToPrivacySettings(title: "User has not authorized location services", message: "Select 'Settings' below to open device settings and enable location services for this app.")
        case .authorizedAlways, .authorizedWhenInUse:
            locationManager.requestLocation()
        @unknown default:
            print("DEVELOPER ALERT: Unknown case of status in handleAuthnticationStatus\(status)")
        }
    }
    
    func showAlertToPrivacySettings(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        guard let settingsURL = URL(string: UIApplication.openSettingsURLString) else {
            print("Something went wrong getting the UIApplication.openSettingsURLString")
            return
        }
        let settingsAction = UIAlertAction(title: "Settings", style: .default) { _ in
            UIApplication.shared.open(settingsURL, options: [:], completionHandler: nil)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(settingsAction)
        alertController.addAction(cancelAction)
        present(alertController, animated: true, completion: nil)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let currentLocation: CLLocation =  CLLocation(latitude: midpoint.latitude, longitude: midpoint.longitude)
    
        var name = ""
        var address = ""
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(currentLocation) { (placemarks, error) in
            if error != nil {
                print("ERROR: retrieving place. \(error!.localizedDescription)")
            }
            if placemarks != nil {
                // get the first placemark
                let placemark = placemarks?.last
                // assign placemark to locationName
                name = placemark?.name ?? "Name Unknown"
                if let postalAddress = placemark?.postalAddress {
                    address = CNPostalAddressFormatter.string(from: postalAddress, style: .mailingAddress)
                }
            } else {
                print("ERROR: retrieving placemark.")
                
            }
            // if there is no location data, make device location the location
            if self.midpoint.name == "" && self.midpoint.address == "" {
                self.midpoint.name = name
                self.midpoint.address = address
                self.midpoint.coordinate = currentLocation.coordinate
            }
            self.mapView.userLocation.title = name
            self.mapView.userLocation.subtitle = address.replacingOccurrences(of: "\n", with: ", ")
            self.updateUserInterface()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("ERROR: \(error.localizedDescription). Failed to get device location.")
    }
}

extension MidpointViewController{
    func UISetup(){
    midpointIntro.layer.borderWidth = 0.5
    midpointIntro.layer.cornerRadius = 20
    midpointIntro.layer.borderColor = UIColor.white.cgColor
    midpointIntro.clipsToBounds = true
    midpointIntro.addShadow(offset: CGSize.init(width: 0, height: 3), color: UIColor.gray, radius: 2.0, opacity: 0.35)
    
    locationLabel.layer.cornerRadius = 20
    locationLabel.clipsToBounds = true
    locationLabel.addShadow(offset: CGSize.init(width: 0, height: 3), color: UIColor.gray, radius: 2.0, opacity: 0.35)
    addressLabel.layer.cornerRadius = 20
    addressLabel.clipsToBounds = true
    addressLabel.addShadow(offset: CGSize.init(width: 0, height: 3), color: UIColor.gray, radius: 2.0, opacity: 0.35)
    mapView.addShadow(offset: CGSize.init(width: 0, height: 3), color: UIColor.gray, radius: 2.0, opacity: 0.35)
}
}
