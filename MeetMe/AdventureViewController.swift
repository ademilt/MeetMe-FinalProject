//
//  AdventureViewController.swift
//  MeetMe
//
//  Created by Annie DeMilt on 4/25/22.
//

import UIKit

class AdventureViewController: UIViewController {
    
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var adventureTextView: UITextView!
    @IBOutlet weak var adventureImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func saveButtonPressed(_ sender: UIBarButtonItem) {
    }
}
