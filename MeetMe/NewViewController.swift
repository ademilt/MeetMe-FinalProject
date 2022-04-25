//
//  NewViewController.swift
//  MeetMe
//
//  Created by Annie DeMilt on 4/24/22.
//

import UIKit

class NewViewController: UIViewController {
   
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var lookupButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func lookupButtonPressed(_ sender: UIButton) {
    }
    
    @IBAction func cancelButtonPressed(_ sender: UIBarButtonItem) {
    }
    
    
    
    
}

