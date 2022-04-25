//
//  Adventures.swift
//  MeetMe
//
//  Created by Annie DeMilt on 4/25/22.
//

import Foundation
import Firebase

class Adventures{
    var adventureArray: [Spot] = []
    var db: Firestore!
    
    init(){
        db = Firestore.firestore()
    }
    
    func loadData(completed: @escaping () -> ()){
        db.collection("spots").addSnapshotListener { (querySnapshot, error) in
            guard error == nil else {
                print("ERROR: adding the snapshot listener \(error!.localizedDescription)")
                return completed()
            }
            self.adventureArray = []
            for document in querySnapshot!.documents{
                let spot = Spot(dictionary: document.data())
                spot.documentID = document.documentID
                self.adventureArray.append(spot)
            }
            completed()
        }
    }
}
