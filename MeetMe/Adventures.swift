//
//  Adventures.swift
//  MeetMe
//
//  Created by Annie DeMilt on 4/26/22.
//

import Foundation
import CoreLocation
import Firebase
import MapKit


class Adventure {
    
    var adventureName: String
    var myName: String
    var friendName: String
    var myCoordinate: CLLocationCoordinate2D
    var friendCoordinate: CLLocationCoordinate2D
    //var meetingCoordinate: CLLocationCoordinate2D
    var notes: String
    var postingUserID: String
    var documentID: String
    
    var myLatitude: CLLocationDegrees {
        return myCoordinate.latitude
    }
    var myLongitude: CLLocationDegrees {
        return myCoordinate.longitude
    }
    var friendLatitude: CLLocationDegrees {
        return friendCoordinate.latitude
    }
    var friendLongitude: CLLocationDegrees {
        return friendCoordinate.longitude
    }
    
    var myLocation: CLLocation {
        return CLLocation(latitude: myLatitude, longitude: myLongitude)
    }
    var friendLocation: CLLocation {
        return CLLocation(latitude: friendLatitude, longitude: friendLongitude)
    }
    
    var dictionary: [String: Any] {
        return ["adventureName":adventureName, "myName":myName, "friendName":friendName, "myCoordinate":myCoordinate, "friendCoordinate": friendCoordinate, "notes": notes, "postingUserID": postingUserID, "documentID": documentID]
    }
    
    init(adventureName: String, myName: String, friendName: String, myCoordinate: CLLocationCoordinate2D, friendCoordinate: CLLocationCoordinate2D, notes: String, postingUserID: String, documentID: String) {
        self.adventureName = adventureName
        self.myName = myName
        self.friendName = friendName
        self.myCoordinate = myCoordinate
        self.friendCoordinate = friendCoordinate
        self.notes = notes
        self.postingUserID = postingUserID
        self.documentID = documentID
    }
    
    
    
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
            ref = db.collection("adventures").addDocument(data: dataToSave){ error in
                guard error == nil else {
                    print("😡 ERROR: Adding document \(error!.localizedDescription).")
                    return completion(false)
                }
                self.documentID = ref!.documentID
                print("😀 Added document \(self.documentID) to the cloud. It worked!")
                completion(true)
            }
        } else { // else save to the existing document id with .setData
            let ref = db.collection("adventures").document(self.documentID)
            ref.setData(dataToSave) { error in
                guard error == nil else {
                    print("😡 ERROR: Updating document \(error!.localizedDescription).")
                    return completion(false)
                }
                print("😀 Updated document \(self.documentID) to the cloud. It worked!")
                completion(true)
            }
        }
        
    }
    
}


