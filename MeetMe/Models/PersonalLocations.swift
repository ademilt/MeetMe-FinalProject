//
//  PersonalLocations.swift
//  MeetMe
//
//  Created by Annie DeMilt on 4/26/22.
//

import Foundation
import Firebase

class PersonalLocations {
    var locationsArray: [PersonalLocation] = []
    var db: Firestore!
    
    init() {
        db = Firestore.firestore()
    }
    
    
    func loadData(user: AdventureUser, completed: @escaping () -> ()) {
        guard user.documentID != "" else {
            return
        }
        db.collection("users").document(user.documentID).collection("adventures").addSnapshotListener { querySnapshot, error in
            guard error == nil else {
                print("😡 ERROR: adding ths snapshot listener \(error!.localizedDescription)")
                return completed()
            }
            self.locationsArray = [] // clean out existing spotArray since new data will load
            // there are querySnapshot!.documents.count documents in the snapshot
            for document in querySnapshot!.documents {
                // You'll have to make sure you have a dictionary initializer in the singular class
                let adventure = PersonalLocation(dictionary: document.data())
                adventure.documentID = document.documentID
                self.locationsArray.append(adventure)
            }
            completed()
        }
    }
}

    
    
//    func loadData(user: AdventureUser, completed: @escaping () -> ()) {
//        guard user.documentID != "" else {
//            return
//        }
//        db.collection("users").document(user.documentID).collection("adventures").addSnapshotListener { querySnapshot, error in
//            guard error == nil else {
//                print("😡 ERROR: adding the snapshot listener \(error!.localizedDescription)")
//                return completed()
//            }
//            self.locationsArray = [] // clean out existing spotArray since new data will load
//            // there are querySnapshot!.documents.count documents in the snapshot
//            for document in querySnapshot!.documents {
//                // You'll have to make sure you have a dictionary initializer in the singular class
//                let adventure = AdventureUser(dictionary: document.data())
//                adventure.documentID = document.documentID
//                self.locationsArray.append(adventure)
//            }
//            completed()
//    }
//}
//}
