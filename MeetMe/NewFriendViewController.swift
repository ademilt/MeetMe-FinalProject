//
//  NewFriendViewController.swift
//  MeetMe
//
//  Created by Annie DeMilt on 4/25/22.
//

import UIKit
import CoreLocation
import GooglePlaces
import MapKit
import Contacts

class NewFriendViewController: UIViewController {
   
    @IBOutlet weak var friendTextField: UITextField!
    @IBOutlet weak var friendLookupButton: UIButton!
    
    var location: PersonalLocation!
    let regionDistance: CLLocationDegrees = 750.0
    var locationManager: CLLocationManager!
    var currentLocation: CLLocation!
    
    var friendName: String? {
        get {
            return friendTextField.text
          }

          set {
              location.firstName = friendTextField.text!
          }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //hide keyboard if we tap outside of a field
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:)))
        tap.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tap)
    }
    
    @IBAction func friendLookupButtonPressed(_ sender: UIButton) {
    }
}
