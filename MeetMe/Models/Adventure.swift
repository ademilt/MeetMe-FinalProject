////
////  Adventure.swift
////  MeetMe
////
////  Created by Annie DeMilt on 4/27/22.
////
//
//import Foundation
//import CoreLocation
//import Firebase
//import MapKit
//
//
//class Adventure: NSObject, MKAnnotation {
//    var coordinate: CLLocationCoordinate2D
//    
//    
//    var adventureName: String
//    var myName: String
//    var friendName: String
//    var myAddress: String
//    var friendAddress: String
//    var myCoordinate: CLLocationCoordinate2D
//    var friendCoordinate: CLLocationCoordinate2D
//    //var meetingCoordinate: CLLocationCoordinate2D
//    var notes: String
//    var postingUserID: String
//    var documentID: String
//    
//    var myLatitude: CLLocationDegrees {
//        return myCoordinate.latitude
//    }
//    var myLongitude: CLLocationDegrees {
//        return myCoordinate.longitude
//    }
//    var friendLatitude: CLLocationDegrees {
//        return friendCoordinate.latitude
//    }
//    var friendLongitude: CLLocationDegrees {
//        return friendCoordinate.longitude
//    }
//    
//    var myLocation: CLLocation {
//        return CLLocation(latitude: myLatitude, longitude: myLongitude)
//    }
//    var friendLocation: CLLocation {
//        return CLLocation(latitude: friendLatitude, longitude: friendLongitude)
//    }
//    
//    var dictionary: [String: Any] {
//        return ["adventureName":adventureName, "myName":myName, "friendName":friendName,"myAddress":myAddress,"friendAddress":friendAddress, "myCoordinate":myCoordinate, "friendCoordinate": friendCoordinate, "notes": notes, "postingUserID": postingUserID, "documentID": documentID]
//    }
//    
//    init(adventureName: String, myName: String, friendName: String, myAddress: String,
//    friendAddress: String, myCoordinate: CLLocationCoordinate2D, friendCoordinate: CLLocationCoordinate2D, notes: String, postingUserID: String, documentID: String) {
//        self.adventureName = adventureName
//        self.myName = myName
//        self.friendName = friendName
//        self.myAddress = myAddress
//        self.friendAddress = friendAddress
//        self.myCoordinate = myCoordinate
//        self.friendCoordinate = friendCoordinate
//        self.notes = notes
//        self.postingUserID = postingUserID
//        self.documentID = documentID
//    }
//    
//    override convenience init() {
//        self.init(adventureName: "", myName: "", friendName: "", myAddress: "", friendAddress: "", myCoordinate: CLLocationCoordinate2D(), friendCoordinate: CLLocationCoordinate2D(), notes: "", postingUserID: "", documentID: "")
//    }
//    
//    
//    convenience init(dictionary: [String: Any]) {
//        let adventureName = dictionary["adventureName"] as! String? ?? ""
//        let myName = dictionary["myName"] as! String? ?? ""
//        let friendName = dictionary["friendName"] as! String? ?? ""
//        let myAddress = dictionary["myAddress"] as! String? ?? ""
//        let friendAddress = dictionary["friendAddress"] as! String? ?? ""
//        let myLatitude = dictionary["myLatitude"] as! Double? ?? 0.0
//        let friendLatitude = dictionary["friendLatitude"] as! Double? ?? 0.0
//        let myLongitude = dictionary["myLongitude"] as! Double? ?? 0.0
//        let friendLongitude = dictionary["friendLongitude"] as! Double? ?? 0.0
//        let myCoordinate = CLLocationCoordinate2D(latitude: myLatitude, longitude: myLongitude)
//        let friendCoordinate = CLLocationCoordinate2D(latitude: friendLatitude, longitude: friendLongitude)
//        let notes = dictionary["notes"] as! String? ?? ""
//        let postingUserID = dictionary["postingUserID"] as! String? ?? ""
//        self.init(adventureName: adventureName, myName: myName, friendName: friendName, myAddress: myAddress, friendAddress: friendAddress, myCoordinate: myCoordinate, friendCoordinate: friendCoordinate, notes: notes, postingUserID: postingUserID, documentID: "")
//    }
//    
//    
//    
//    func saveData(completion: @escaping (Bool) -> ()) {
//        let db = Firestore.firestore()
//        // Grab the user id
//        guard let postingUserID = Auth.auth().currentUser?.uid else {
//            print("😡 ERROR: Could not save data because we don't have a valid postingUserID.")
//            return completion(false)
//        }
//        self.postingUserID = postingUserID
//        // Create the dictionary representing data we want to save
//        let dataToSave: [String: Any] = self.dictionary
//        // if we HAVE saved a record, we'll have an ID, otherwise .addDocument will create one
//        if self.documentID == "" {
//            var ref: DocumentReference? = nil // Firestore will create a new ID for us
//            ref = db.collection("adventures").addDocument(data: dataToSave){ error in
//                guard error == nil else {
//                    print("😡 ERROR: Adding document \(error!.localizedDescription).")
//                    return completion(false)
//                }
//                self.documentID = ref!.documentID
//                print("😀 Added document \(self.documentID) to the cloud. It worked!")
//                completion(true)
//            }
//        } else { // else save to the existing document id with .setData
//            let ref = db.collection("adventures").document(self.documentID)
//            ref.setData(dataToSave) { error in
//                guard error == nil else {
//                    print("😡 ERROR: Updating document \(error!.localizedDescription).")
//                    return completion(false)
//                }
//                print("😀 Updated document \(self.documentID) to the cloud. It worked!")
//                completion(true)
//            }
//        }
//        
//    }
//    
//}
//
//
