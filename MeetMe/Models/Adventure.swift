//
//  Adventure.swift
//  MeetMe
//
//  Created by Annie DeMilt on 4/29/22.
//

import Foundation
import Firebase
import MapKit
import FirebaseAuth
import FirebaseAuthUI

class Adventure{
    
    var adventureName: String
    var me: String
    var friend: String
    var myOriginalLocation: String
    var friendOriginalLocation: String
    var meetingLocation: String
    var notes: String
    var postingUserID: String
    var documentID: String
    
    var dictionary: [String: Any] {
        return ["adventureName":adventureName, "me": me, "friend": friend,"myOriginalLocation":myOriginalLocation, "friendOriginalLocation":friendOriginalLocation, "meetingLocation":meetingLocation, "notes":notes,"postingUserID": postingUserID, "documentID": documentID]
    }
    
    init(adventureName: String, me: String, friend: String, myOriginalLocation: String, friendOriginalLocation: String, meetingLocation: String, notes: String, postingUserID: String, documentID: String) {
        self.adventureName = adventureName
        self.me = me
        self.friend = friend
        self.myOriginalLocation = myOriginalLocation
        self.friendOriginalLocation = friendOriginalLocation
        self.meetingLocation = meetingLocation
        self.notes = notes
        self.postingUserID = postingUserID
        self.documentID = documentID
    }
    
    convenience init() {
        self.init(adventureName:"", me: "", friend: "",myOriginalLocation: "",friendOriginalLocation: "",meetingLocation:"", notes: "", postingUserID: "", documentID: "")
    }
    
    convenience init(dictionary: [String: Any]) {
        let adventureName = dictionary["adventureName"] as! String? ?? ""
        let me = dictionary["me"] as! String? ?? ""
        let friend = dictionary["friend"] as! String? ?? ""
        let myOriginalLocation = dictionary["myOriginalLocation"] as! String? ?? ""
        let friendOriginalLocation = dictionary["friendOriginalLocation"] as! String? ?? ""
        let meetingLocation = dictionary["meetingLocation"] as! String? ?? ""
        let notes = dictionary["notes"] as! String? ?? ""
        let postingUserID = dictionary["postingUserID"] as! String? ?? ""
        self.init(adventureName: adventureName, me: me, friend:  friend, myOriginalLocation: myOriginalLocation, friendOriginalLocation: friendOriginalLocation, meetingLocation: meetingLocation, notes:notes, postingUserID: postingUserID, documentID: "")
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
            ref = db.collection("users").document(postingUserID).collection("adventure").addDocument(data: dataToSave){ error in
                guard error == nil else {
                    print("😡 ERROR: Adding document \(error!.localizedDescription).")
                    return completion(false)
                }
                self.documentID = ref!.documentID
                print("😀 Added document \(self.documentID) to the cloud. It worked!")
                completion(true)
            }
        } else { // else save to the existing document id with .setData
            let ref = db.collection("users").document(postingUserID).collection("adventure").document(self.documentID)
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
    
    func deleteData(adventure: Adventure, completion: @escaping (Bool) -> ()) {
        let db = Firestore.firestore()
        db.collection("adventure").document(documentID).delete { error in
            if let error = error {
                print("ERROR: deleting adventure documentID \(self.documentID). Error: \(error.localizedDescription)")
                completion(false)
            } else {
                print("Successfully deleted document \(self.documentID)")
                completion(true)
            }
        }
    }
}
