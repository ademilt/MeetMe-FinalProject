//
//  Adventures.swift
//  MeetMe
//
//  Created by Annie DeMilt on 4/30/22.
//

import Foundation
import Firebase

class Adventures {
    var adventureArray: [MidpointLocation] = []
    var db: Firestore!
    
    init() {
        db = Firestore.firestore()
    }
    func loadData(user: AdventureUser, person: PersonalLocation, friend: FriendLocation, midpoint:  MidpointLocation, completed: @escaping () -> ()) {
        guard person.documentID != "" else {
                    return
                }

        db.collection("users").document(user.documentID).collection("adventures").document(person.documentID).collection("friend").document(friend.documentID).collection("midpoint").document(midpoint.documentID).collection("adventure").addSnapshotListener { querySnapshot, error in
            guard error == nil else {
                print("😡 ERROR: adding ths snapshot listener \(error!.localizedDescription)")
                return completed()
            }
            self.adventureArray = [] // clean out existing spotArray since new data will load
            // there are querySnapshot!.documents.count documents in the snapshot
            for document in querySnapshot!.documents {
                // You'll have to make sure you have a dictionary initializer in the singular class
                let adventure = MidpointLocation(dictionary: document.data())
                adventure.documentID = document.documentID
                self.adventureArray.append(adventure)
            }
            completed()
        }
    }
}
