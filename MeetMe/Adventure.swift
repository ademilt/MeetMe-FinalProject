//
//  Adventure.swift
//  MeetMe
//
//  Created by Annie DeMilt on 4/25/22.
//

import Foundation
import Firebase
import MapKit

class Adventure: NSObject, MKAnnotation{
    var name: String
    var friendName: String
    var address: String
    var coordinate: CLLocationCoordinate2D
    var notes: String
    var postingUserID: String
    var documentID: String
    
    var dictionary: [String: Any] {
        return ["name":name, "friendName":friendName, "address":address, "latitude":latitude, "longitude":longitude, "notes":notes, "postingUserID":postingUserID, "documentID":documentID]
    }
    var latitude: CLLocationDegrees{
        return coordinate.latitude
    }
    
    var longitude: CLLocationDegrees{
        return coordinate.longitude
    }
    
    var location: CLLocation {
        return CLLocation(latitude: latitude, longitude: longitude)
    }
    
    var title: String? {
        return name
    }
    
    var subtitle: String? {
        return address
    }
    
    init(name: String, friendName: String, address: String, coordinate: CLLocationCoordinate2D, notes: String, postingUserID: String, documentID: String){
        self.name = name
        self.friendName = friendName
        self.address = address
        self.coordinate = coordinate
        self.notes = notes
        self.postingUserID = postingUserID
        self.documentID = documentID
    }
    
    convenience override init(){
        self.init(name: "", friendName: "", address: "", coordinate: CLLocationCoordinate2D(), notes: "", postingUserID: "", documentID: "")
    }
    
    convenience init(dictionary: [String: Any]) {
        let name = dictionary["name"] as! String? ?? ""
        let friendName = dictionary["friendName"] as! String? ?? ""
        let address = dictionary["address"] as! String? ?? ""
        let latitude = dictionary["latitude"] as! Double? ?? 0.0
        let longitude = dictionary["longitude"] as! Double? ?? 0.0
        let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        let notes = dictionary["notes"] as! String? ?? ""
        let postingUserID = dictionary["postingUserID"] as! String? ?? ""
        self.init(name: name, friendName: friendName, address: address, coordinate: coordinate, notes: notes, postingUserID: postingUserID, documentID: "")
    }
    
    func saveData(completion: @escaping (Bool) -> ()){
        let db = Firestore.firestore()
        //Grab the user ID
        guard let postingUserID = (Auth.auth().currentUser?.uid) else{
            print("ERROR: Could not save data because we don't have a valid postingUserID")
            return completion(false)
        }
        self.postingUserID = postingUserID
        //Create the dictionary representing data we want to save
        let dataToSave: [String: Any] = self.dictionary
        //if we HAVE saved a record, we'll have an ID
        if self.documentID == ""{//Create a new document via .addDocument
            var ref: DocumentReference? = nil //Firestore will create a new ID for us
            ref = db.collection("spots").addDocument(data:dataToSave){ (error) in
                guard error == nil else{
                    print("ERROR: adding document \(error!.localizedDescription)")
                    return completion(false)
                }
                self.documentID = ref!.documentID
                print("Added document: \(self.documentID)") //It worked!
                completion(true)
            }
        } else{ //else save to the existing document ID
            let ref = db.collection("spots").document(self.documentID)
            ref.setData(dataToSave){(error) in
                guard error == nil else {
                    print("ERROR: updating document \(error!.localizedDescription)")
                    return completion(false)
                }
                print("Updated document: \(self.documentID)") //It worked!
                completion(true)
            }
        }
    }
}


