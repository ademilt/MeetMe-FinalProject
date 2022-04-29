//
//  FriendLocations.swift
//  MeetMe
//
//  Created by Annie DeMilt on 4/27/22.
//

import Foundation
import Firebase

class FriendLocations {
    var friendArray: [FriendLocation] = []
    var db: Firestore!
    
    init() {
        db = Firestore.firestore()
    }
    func loadData(user: AdventureUser, person: PersonalLocation, completed: @escaping () -> ()) {
        guard person.documentID != "" else {
                    return
                }
        
        db.collection("users").document(user.documentID).collection("adventures").document(person.documentID).collection("friend").addSnapshotListener { querySnapshot, error in
            guard error == nil else {
                print("😡 ERROR: adding ths snapshot listener \(error!.localizedDescription)")
                return completed()
            }
            self.friendArray = [] // clean out existing spotArray since new data will load
            // there are querySnapshot!.documents.count documents in the snapshot
            for document in querySnapshot!.documents {
                // You'll have to make sure you have a dictionary initializer in the singular class
                let location = FriendLocation(dictionary: document.data())
                location.documentID = document.documentID
                self.friendArray.append(location)
            }
            completed()
        }
    }
}
