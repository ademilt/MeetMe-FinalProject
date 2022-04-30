//
//  AdventureViewController.swift
//  MeetMe
//
//  Created by Annie DeMilt on 4/25/22.
//

import UIKit

class AdventureViewController1: UIViewController {
    

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
        
    }@IBAction func cancelButtonPressed(_ sender: Any) {
        leaveViewController()
    }
    
    
    @IBAction func deleteButtonPressed(_ sender: UIBarButtonItem) {
        adventure.deleteData(adventure: adventure) { success in
            if success {
                self.leaveViewController()
            } else {
                print("Delete unsuccessful")
            }
        }
    }
    
    @IBAction func saveButtonPressed(_ sender: UIBarButtonItem) {
        updateFromUserInterface()
        adventure.saveData(person: me, friend: friend, midpoint: midpoint) { success in
            if success {
                self.leaveViewController()
            } else {
                print("ERROR: Can't unwind segue from adventure because of adventure saving error.")
            }
        }
//        photo.saveData(adventure: adventure) { success in
//            if success {
//                self.leaveViewController()
//            } else {
//                print("ERROR: Can't unwind segue from PhotoViewControlloer because of photo saving error.")
//            }
//    }
}
}
