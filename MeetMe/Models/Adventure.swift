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
    var me: PersonalLocation
    var friend: FriendLocation
    var postingUserID: String
    var documentID: String
    
    var dictionary: [String: Any] {
        return ["adventureName":adventureName, "me": me, "friend": friend, "postingUserID": postingUserID, "documentID": documentID]
    }
    
    init(adventureName: String, me: PersonalLocation, friend: FriendLocation, postingUserID: String, documentID: String) {
        self.adventureName = adventureName
        self.me = me
        self.friend = friend
        self.postingUserID = postingUserID
        self.documentID = documentID
    }
    
    convenience init() {
        self.init(adventureName:"", me: PersonalLocation(), friend: FriendLocation(), postingUserID: "", documentID: "")
    }
    
    convenience init(dictionary: [String: Any]) {
        let adventureName = dictionary["adventureName"] as! String? ?? ""
        let me = dictionary["me"] as! PersonalLocation? ?? nil
        let friend = dictionary["friend"] as! FriendLocation? ?? nil
        let postingUserID = dictionary["postingUserID"] as! String? ?? ""
        self.init(adventureName: adventureName, me: me!, friend:  friend!, postingUserID: postingUserID, documentID: "")
    }
    
    func saveData(person: PersonalLocation, friend: FriendLocation, midpoint: MidpointLocation, completion: @escaping (Bool) -> ()) {
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
            ref = db.collection("users").document(postingUserID).collection("adventures").document(person.documentID).collection("friend").document(friend.documentID).collection("midpoint").document(midpoint.documentID).collection("adventure").addDocument(data: dataToSave){ error in
                guard error == nil else {
                    print("😡 ERROR: Adding document \(error!.localizedDescription).")
                    return completion(false)
                }
                self.documentID = ref!.documentID
                print("😀 Added document \(self.documentID) to the cloud. It worked!")
                completion(true)
            }
        } else { // else save to the existing document id with .setData
            let ref = db.collection("users").document(postingUserID).collection("adventures").document(person.documentID).collection("friend").document(friend.documentID).collection("midpoint").document(midpoint.documentID).collection("adventure").document(self.documentID)
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
