//
//  Adventures.swift
//  MeetMe
//
//  Created by Annie DeMilt on 4/26/22.
//

import Foundation
import CoreLocation


class Adventure {
    var myLocation: PersonalLocation
    var friendLocation: PersonalLocation
    var notes: String
    var postingUserID: String
    var documentID: String
    
    internal init(myLocation: PersonalLocation, friendLocation: PersonalLocation, notes: String, postingUserID: String, documentID: String) {
        self.myLocation = myLocation
        self.friendLocation = friendLocation
        self.notes = notes
        self.postingUserID = postingUserID
        self.documentID = documentID
    }
    
}

