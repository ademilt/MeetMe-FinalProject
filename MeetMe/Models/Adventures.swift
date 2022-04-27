//
//  Adventures.swift
//  MeetMe
//
//  Created by Annie DeMilt on 4/26/22.
//

import Foundation
import Firebase

class Adventures {
    var adventuresArray: [PersonalLocation] = []
    var db: Firestore!
    
    init() {
        db = Firestore.firestore()
    }
    
    func loadData(completed: @escaping () -> ()) {
        db.collection("adventures").addSnapshotListener { querySnapshot, error in
            guard error == nil else {
                print("😡 ERROR: adding ths snapshot listener \(error!.localizedDescription)")
                return completed()
            }
            self.adventuresArray = [] // clean out existing spotArray since new data will load
            // there are querySnapshot!.documents.count documents in the snapshot
            for document in querySnapshot!.documents {
                // You'll have to make sure you have a dictionary initializer in the singular class
                let location = PersonalLocation(dictionary: document.data())
                location.documentID = document.documentID
                self.adventuresArray.append(location)
            }
            completed()
        }
    }
}

