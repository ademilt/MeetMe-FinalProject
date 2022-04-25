//
//  Spots.swift
//  MeetMe
//
//  Created by Annie DeMilt on 4/25/22.
//

import Foundation
import Firebase

class Spots{
    var spotArray: [Spot] = []
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
            self.spotArray = []
            for document in querySnapshot!.documents{
                let spot = Spot(dictionary: document.data())
                spot.documentID = document.documentID
                self.spotArray.append(spot)
            }
            completed()
        }
    }
}

