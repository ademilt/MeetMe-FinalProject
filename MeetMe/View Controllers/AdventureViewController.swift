//
//  AdventureViewController.swift
//  MeetMe
//
//  Created by Annie DeMilt on 4/30/22.
//

import UIKit

class AdventureViewController: UIViewController {
    
    
    @IBOutlet weak var cancelBarButton: UIBarButtonItem!
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var saveBarButton: UIBarButtonItem!
    @IBOutlet weak var deleteButton: UIBarButtonItem!
    @IBOutlet weak var adventureTextView: UITextView!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    //inherited variables
    var me: PersonalLocation!
    var friend: FriendLocation!
    var midpoint: MidpointLocation!
    var currentUser: AdventureUser!
    
    var adventure: Adventure!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //basic UI
        UISetup()
        
        adventureTextView.text = "write about your favorite memories from this adventure to save and look back on."
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
        adventure.meetingLocation = midpoint.name
        adventure.friendOriginalLocation = friend.name
        adventure.myOriginalLocation = me.name
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        updateFromUserInterface()
        if segue.identifier == "savedAdventure" {
            let destination = segue.destination as! SavedViewController
            destination.me = me
            destination.friend = friend
            destination.midpoint = midpoint
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
    
    @IBAction func saveTryButtonPressed(_ sender: UIBarButtonItem) {
        updateFromUserInterface()
        print("Save button has been pressed.")
        adventure.saveData() {
            success in
            if success {
                self.performSegue(withIdentifier: "savedAdventure", sender: nil)
            } else {
                //ERROR during save occured
                self.oneButtonAlert(title: "Save Failed", message: "For some reason the data would not save to the cloud")
            }
        }
    }
    
    @IBAction func deleteButtonPressed(_ sender: Any) {
        adventure.deleteData(adventure: adventure) { success in
            if success {
                self.leaveViewController()
            } else {
                print("Delete unsuccessful")
            }
        }
    }
}

extension AdventureViewController{
    func UISetup(){
        descriptionLabel.layer.borderWidth = 0.5
        descriptionLabel.layer.cornerRadius = 20
        descriptionLabel.layer.borderColor = UIColor.white.cgColor
        descriptionLabel.clipsToBounds = true
        descriptionLabel.addShadow(offset: CGSize.init(width: 0, height: 3), color: UIColor.gray, radius: 2.0, opacity: 0.35)
        
        questionLabel.layer.cornerRadius = 20
        questionLabel.clipsToBounds = true
        questionLabel.addShadow(offset: CGSize.init(width: 0, height: 3), color: UIColor.gray, radius: 2.0, opacity: 0.35)
        
        adventureTextView.layer.cornerRadius = 20
        adventureTextView.clipsToBounds = true
        adventureTextView.addShadow(offset: CGSize.init(width: 0, height: 3), color: UIColor.gray, radius: 2.0, opacity: 0.35)
    }
}

