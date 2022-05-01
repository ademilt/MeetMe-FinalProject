//
//  SearchViewController.swift
//  MeetMe
//
//  Created by Annie DeMilt on 4/29/22.
//

//search code adapted from https://medium.com/@pravinbendre772/search-for-places-and-display-results-using-mapkit-a987bd6504df

import UIKit
import CoreLocation
import GooglePlaces
import MapKit
import Contacts

//can only constrain map search to specific region, but may not stay within the bounds (manually Zoom in to region to emphasize constraints)

protocol HandleMapSearch {
    func dropPinZoomIn(placemark:MKPlacemark)
}

class SearchViewController: UIViewController, MKMapViewDelegate {
    
    //@IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var nextBarButton: UIBarButtonItem!
    
    var me: PersonalLocation!
    var friend: FriendLocation!
    var midpoint: MidpointLocation!
    var currentUser: AdventureUser!
    var regionDistance: CLLocationDegrees = 750.0
    var locationManager: CLLocationManager!
    var resultSearchController:UISearchController? = nil
    var selectedPin:MKPlacemark? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let locationSearchTable = storyboard!.instantiateViewController(withIdentifier: "LocationSearchTable") as! LocationSearchTableViewController
        resultSearchController = UISearchController(searchResultsController: locationSearchTable)
        resultSearchController?.searchResultsUpdater = locationSearchTable
        
        let searchBar = resultSearchController!.searchBar
        searchBar.sizeToFit()
        searchBar.placeholder = "Search for somewhere to meet halfway!"
        navigationItem.searchController = resultSearchController
        
        resultSearchController?.hidesNavigationBarDuringPresentation = false
        resultSearchController?.dimsBackgroundDuringPresentation = true
        definesPresentationContext = true
        
        locationSearchTable.mapView = mapView
        locationSearchTable.handleMapSearchDelegate = self
        
        setUpMapView()
        setupAnnotations()
        updateUserInterface()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "saveAdventure" {
            let destination = segue.destination as! AdventureViewController
            destination.me = me
            destination.friend = friend
            destination.midpoint = midpoint
        }
    }
    
    func setUpMapView() {
        let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        let region = MKCoordinateRegion(center: midpoint.coordinate, span: span)
        mapView.setRegion(region, animated: true)
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
    
    func updateUserInterface() {
        updateMap()
    }
    
    func updateMap() {
        //mapView.removeAnnotations(mapView.annotations)
        mapView.addAnnotation(midpoint)
        //mapView.setCenter(midpoint.coordinate, animated: true)
    }
    
    func leaveViewController(){
        let isPresentingInAddMode = presentingViewController is UINavigationController
        if isPresentingInAddMode{
            dismiss(animated: true, completion: nil)
        } else {
            navigationController?.popViewController(animated: true)
        }
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier:
                                                                        MKMapViewDefaultAnnotationViewReuseIdentifier,
                                                                      for: annotation) as? MKMarkerAnnotationView {
            //annotationView.markerTintColor = UIColor.green
            if annotation is MKPointAnnotation {
                annotationView.glyphText = "H"
                annotationView.markerTintColor = nil
            }
                return annotationView
        }
        return nil
    }
    
    
    @IBAction func nextButtonTryPressed(_ sender: Any) {
        self.performSegue(withIdentifier: "saveAdventure", sender: nil)
    }
}

extension SearchViewController: CLLocationManagerDelegate {
    
    func getLocation() {
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

extension SearchViewController: HandleMapSearch {
    func dropPinZoomIn(placemark:MKPlacemark){
        // cache the pin
        selectedPin = placemark
        // keep existing annotations
        //mapView.removeAnnotations(mapView.annotations)
        let annotation = MKPointAnnotation()
        annotation.coordinate = placemark.coordinate
        annotation.title = placemark.name
        //annotation.markerTintColor = UIColor.green
        if let city = placemark.locality,
           let state = placemark.administrativeArea {
            annotation.subtitle = "(city) (state)"
        }
        mapView.addAnnotation(annotation)
        let span = MKCoordinateSpan(latitudeDelta: 0.03, longitudeDelta: 0.03)
        let region = MKCoordinateRegion(center: placemark.coordinate, span: span)
        mapView.setRegion(region, animated: true)
    }
}
