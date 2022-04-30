//
//  AdventureViewController.swift
//  MeetMe
//
//  Created by Annie DeMilt on 4/30/22.
//

import UIKit

class AdventureViewController: UIViewController {
    
    
    @IBOutlet weak var cancelBarButton: UIBarButtonItem!
    @IBOutlet weak var saveBarButton: UIBarButtonItem!
    @IBOutlet weak var deleteButton: UIBarButtonItem!
    @IBOutlet weak var adventureImageView: UIImageView!
    @IBOutlet weak var adventureTextView: UITextView!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    var me: PersonalLocation!
    var friend: FriendLocation!
    var midpoint: MidpointLocation!
    var currentUser: AdventureUser!

   
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        updateFromUserInterface()
        if segue.identifier == "saveAdventure" {
            let destination = segue.destination as! SavedViewController
            destination.me = me
            destination.friend = friend
            destination.midpoint = midpoint
            destination.currentUser = currentUser
        }
    }
    
    func leaveViewController() {
        let isPresentingInAddMode = presentingViewController is UINavigationController
        if isPresentingInAddMode {
            dismiss(animated: true, completion: nil)
        } else {
            navigationController?.popViewController(animated: true)
        }
    }
    
    @IBAction func cancelButtonPressed(_ sender: Any) {
        leaveViewController()
    }
    
    @IBAction func saveButtonPressed(_ sender: Any) {
        updateFromUserInterface()
        adventure.saveData(person: me, friend: friend, midpoint: midpoint) { success in
            if success {
                self.performSegue(withIdentifier: "saveAdventure", sender: nil)
            } else {
                //ERROR during save occured
                self.oneButtonAlert(title: "Save Failed", message: "For some reason the data would not save to the cloud")
            }
        }
    }
    
    @IBAction func deleteButtonPressed(_ sender: Any) {
    }
}

