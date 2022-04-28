//
//  AdventureUsers.swift
//  MeetMe
//
//  Created by Annie DeMilt on 4/27/22.
//

import Foundation
import Firebase

class AdventureUsers {
    var userArray: [AdventureUser] = []
    var db: Firestore!
    
    init() {
        db = Firestore.firestore()
    }
    
    func loadData(completed: @escaping () -> ()) {
        db.collection("users").addSnapshotListener { querySnapshot, error in
            guard error == nil else {
                print("😡 ERROR: adding ths snapshot listener \(error!.localizedDescription)")
                return completed()
            }
            self.userArray = [] // clean out existing userArray since new data will load
            // there are querySnapshot!.documents.count documents in the snapshot
            for document in querySnapshot!.documents {
                // You'll have to make sure you have a dictionary initializer in the singular class
                let adventureUser = AdventureUser(dictionary: document.data())
                adventureUser.documentID = document.documentID
                self.userArray.append(adventureUser)
            }
            completed()
        }
    }
}


