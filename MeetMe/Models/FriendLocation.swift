//
//  FriendLocation.swift
//  MeetMe
//
//  Created by Annie DeMilt on 4/26/22.
//

import Foundation
import Firebase
import MapKit
import FirebaseAuth
import FirebaseAuthUI

class FriendLocation: NSObject, MKAnnotation {
    var friendName: String
    var name: String
    var address: String
    var coordinate: CLLocationCoordinate2D
    var postingUserID: String
    var documentID: String
    
    var dictionary: [String: Any] {
        return ["friendName": friendName, "name": name, "address": address, "latitude": latitude, "longitude": longitude, "postingUserID": postingUserID, "documentID": documentID]
    }
    
    var latitude: CLLocationDegrees {
        return coordinate.latitude
    }
    
    var longitude: CLLocationDegrees {
        return coordinate.longitude
    }
    
    var location: CLLocation {
        return CLLocation(latitude: latitude, longitude: longitude)
    }
    
    init(friendName: String, name: String, address: String, coordinate: CLLocationCoordinate2D, postingUserID: String, documentID: String) {
        self.friendName = friendName
        self.name = name
        self.address = address
        self.coordinate = coordinate
        self.postingUserID = postingUserID
        self.documentID = documentID
    }
    
    override convenience init() {
        self.init(friendName: "", name: "", address: "", coordinate: CLLocationCoordinate2D(), postingUserID: "", documentID: "")
    }
    
    convenience init(dictionary: [String: Any]) {
        let friendName = dictionary["friendName"] as! String? ?? ""
        let name = dictionary["name"] as! String? ?? ""
        let address = dictionary["address"] as! String? ?? ""
        let latitude = dictionary["latitude"] as! Double? ?? 0.0
        let longitude = dictionary["longitude"] as! Double? ?? 0.0
        let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        let postingUserID = dictionary["postingUserID"] as! String? ?? ""
            self.init(friendName: friendName, name: name, address: address, coordinate: coordinate, postingUserID: postingUserID, documentID: "")
    }
    
//    func saveData(person: PersonalLocation, completion: @escaping (Bool) -> ()) {
    func saveData(completion: @escaping (Bool) -> ()) {
        let db = Firestore.firestore()
        // Grab the user id
        guard let postingUserID = Auth.auth().currentUser?.uid else {
            print("😡 ERROR: Could not save data because we don't have a valid postingUserID.")
            return completion(false)
        }
        self.postingUserID = postingUserID
        // Create the dictionary representing data we want to save
        let dataToSave: [String: Any] = self.dictionary
        // if we HAVE saved a record, we'll have an ID, otherwise .addDocument will create one
        if self.documentID == "" {
            var ref: DocumentReference? = nil // Firestore will create a new ID for us
            ref = db.collection("adventures").document(postingUserID).collection("friend").addDocument(data: dataToSave) { error in
                guard error == nil else {
                    print("😡 ERROR: Adding document \(error!.localizedDescription).")
                    return completion(false)
                }
                self.documentID = ref!.documentID
                print("😀 Added document \(self.documentID) to spot: \(postingUserID). It worked!")
                     completion(true)
                
            }
        } else { // else save to the existing document id with .setData
            let ref = db.collection("adventures").document(postingUserID).collection("friend").document(self.documentID)
            ref.setData(dataToSave) { error in
                guard error == nil else {
                    print("😡 ERROR: Updating document \(error!.localizedDescription).")
                    return completion(false)
                }
                print("😀 Updated document \(self.documentID) in spot: \(postingUserID). It worked!")
                     completion(true)
                
            }
        }
        
    }
}
