//
//  AdventureViewController.swift
//  MeetMe
//
//  Created by Annie DeMilt on 4/30/22.
//

import UIKit

class AdventureViewController: UIViewController {
    
    
    var me: PersonalLocation!
    var friend: FriendLocation!
    var midpoint: MidpointLocation!
   
    var adventure: Adventure!
    //var photo: Photo!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        adventure = Adventure()
        
        //hide keyboard if we tap outside of a field
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:)))
        tap.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tap)
        
        descriptionLabel.text = "\(me.firstName) and \(friend.friendName)'s adventure"
    }
    
    func updateFromUserInterface() {
        adventure.adventureName = descriptionLabel.text ?? "our adventure"
        adventure.notes = adventureTextView.text!
        adventure.me =  me.firstName
        adventure.friend = friend.friendName
    }
    
    func leaveViewController() {
        let isPresentingInAddMode = presentingViewController is UINavigationController
        if isPresentingInAddMode {
            dismiss(animated: true, completion: nil)
        } else {
            navigationController?.popViewController(animated: true)
        }
    }
    
    
}

