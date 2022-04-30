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
        print(adventure.meetingLocation)
        adventureLabel.text = "\(adventure.adventureName)"
        descriptionLabel.text = "\(adventure.me) started at \(adventure.myOriginalLocation) and \(adventure.friend) started at \(adventure.friendOriginalLocation)! we met halfway around \(adventure.meetingLocation)."
        notesField.text = "\(adventure.notes)"
        notesField.isEditable = false
        
}
}
