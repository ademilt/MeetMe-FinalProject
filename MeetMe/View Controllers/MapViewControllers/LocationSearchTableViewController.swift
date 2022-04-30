//
//  LocationSearchTableViewController.swift
//  MeetMe
//
//  Created by Annie DeMilt on 4/29/22.
//

//search code adapted from https://medium.com/@pravinbendre772/search-for-places-and-display-results-using-mapkit-a987bd6504df

import UIKit
import CoreLocation
import MapKit

class LocationSearchTableViewController: UITableViewController {
    var matchingItems:[MKMapItem] = []
    var mapView: MKMapView? = nil
    var handleMapSearchDelegate:HandleMapSearch? = nil
    
//    func showPointsOfInterest() {
//            let searchRequest = MKLocalPointsOfInterestRequest(center: midpoint.coordinate, radius: 10)
//            // searchRequest.naturalLanguageQuery = "tesla chargers"
//            searchRequest.pointOfInterestFilter = MKPointOfInterestFilter(including: [.bank, .atm])
//            searchRequest.region = mapView.region
//            searchRequest.resultTypes = [.pointOfInterest, .address]
//
//            let search = MKLocalSearch(request: searchRequest)
//            search.start { response, error in
//                guard let response = response else {
//                    print("Error: \(error?.localizedDescription ?? "No error specified").")
//                    return
//                }
//                // Create annotation for every map item
//                for mapItem in response.mapItems {
//                    let annotation = MKPointAnnotation()
//                    annotation.coordinate = mapItem.placemark.coordinate
//
//                    annotation.title = mapItem.name
//                    annotation.subtitle = mapItem.phoneNumber
//
//                    self.mapView.addAnnotation(annotation)
//                }
//                self.mapView.setRegion(response.boundingRegion, animated: true)
//            }
//        }
    }
    

extension LocationSearchTableViewController : UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
                guard let mapView = mapView,
                    let searchBarText = searchController.searchBar.text else { return }
                let request = MKLocalSearch.Request()
                request.naturalLanguageQuery = searchBarText
                request.region = mapView.region
                let search = MKLocalSearch(request: request)
        search.start { response, _ in
                    guard let response = response else {
                        return
                    }
                    self.matchingItems = response.mapItems
                    self.tableView.reloadData()
                }
            }
}

extension LocationSearchTableViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return matchingItems.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")!
            let selectedItem = matchingItems[indexPath.row].placemark
            cell.textLabel?.text = selectedItem.name
            let address = "\(selectedItem.thoroughfare ?? ""), \(selectedItem.locality ?? ""), \(selectedItem.subLocality ?? ""), \(selectedItem.administrativeArea ?? ""), \(selectedItem.postalCode ?? ""), \(selectedItem.country ?? "")"
    cell.detailTextLabel?.text = address
            return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedItem = matchingItems[indexPath.row].placemark
        handleMapSearchDelegate?.dropPinZoomIn(placemark: selectedItem)
        dismiss(animated: true, completion: nil)
    }
}
