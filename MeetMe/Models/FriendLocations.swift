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
    func loadData(person: PersonalLocation, completed: @escaping () -> ()) {
        guard person.documentID != "" else {
            return
        }
        db.collection("adventures").document(person.documentID).collection("friend").addSnapshotListener { querySnapshot, error in
            guard error == nil else {
                print("😡 ERROR: adding ths snapshot listener \(error!.localizedDescription)")
                return completed()
            }
            self.friendArray = [] // clean out existing spotArray since new data will load
            // there are querySnapshot!.documents.count documents in the snapshot
            for document in querySnapshot!.documents {
                // You'll have to make sure you have a dictionary initializer in the singular class
                let friend = FriendLocation(dictionary: document.data())
                friend.documentID = document.documentID
                self.friendArray.append(friend)
            }
            completed()
        }
    }
}

    
//    func loadData(location: PersonalLocation, completed: @escaping () -> ()) {
//        guard location.documentID != "" else {
//            return
//        }
//        db.collection("adventures").document(location.documentID).collection("friend").addSnapshotListener { querySnapshot, error in
//            guard error == nil else {
//                print("😡 ERROR: adding ths snapshot listener \(error!.localizedDescription)")
//                return completed()
//            }
//            self.friendArray = [] // clean out existing spotArray since new data will load
//            // there are querySnapshot!.documents.count documents in the snapshot
//            for document in querySnapshot!.documents {
//                // You'll have to make sure you have a dictionary initializer in the singular class
//                let friend = FriendLocation(dictionary: document.data())
//                friend.documentID = document.documentID
//                self.friendArray.append(friend)
//            }
//            completed()
//        }
//    }
//}
