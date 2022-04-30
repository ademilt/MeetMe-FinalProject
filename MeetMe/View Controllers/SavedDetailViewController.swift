//
//  SavedDetailViewController.swift
//  MeetMe
//
//  Created by Annie DeMilt on 4/25/22.
//

import UIKit

class SavedDetailViewController: UIViewController {
    
    @IBOutlet weak var adventureLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var notesField: UITextView!
    
    var adventure: Adventure!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //basic UI
        UISetup()
        updateUserInterface()
    }
    
    func updateUserInterface(){
        adventureLabel.text = "\(adventure.adventureName)"
        descriptionLabel.text = "\(adventure.me) started at \(adventure.myOriginalLocation) and \(adventure.friend) started at \(adventure.friendOriginalLocation)! we met halfway, around \(adventure.meetingLocation)."
        notesField.text = "\(adventure.notes)"
        notesField.isEditable = false
    }
}
extension SavedDetailViewController{
    func UISetup(){
        adventureLabel.layer.borderWidth = 0.5
        adventureLabel.layer.cornerRadius = 20
        adventureLabel.layer.borderColor = UIColor.white.cgColor
        adventureLabel.clipsToBounds = true
        adventureLabel.addShadow(offset: CGSize.init(width: 0, height: 3), color: UIColor.gray, radius: 2.0, opacity: 0.35)
        
        descriptionLabel.layer.cornerRadius = 20
        descriptionLabel.clipsToBounds = true
        descriptionLabel.addShadow(offset: CGSize.init(width: 0, height: 3), color: UIColor.gray, radius: 2.0, opacity: 0.35)
        
        notesField.layer.cornerRadius = 20
        notesField.clipsToBounds = true
        notesField.addShadow(offset: CGSize.init(width: 0, height: 3), color: UIColor.gray, radius: 2.0, opacity: 0.35)
    }
    
}
