//
//  HomeViewController.swift
//  MeetMe
//
//  Created by Annie DeMilt on 4/25/22.
//

import UIKit
import SwiftUI


class HomeViewController: UIViewController {
    
    @IBOutlet weak var newMeetButton: UIButton!
    @IBOutlet weak var savedMeetButton: UIButton!
    @IBOutlet weak var meetLabel: UILabel!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        UISetup()
    }
    
    //setting up uniform UI
    func UISetup(){
        newMeetButton.addBorder(width: 0, radius: 20, color: UIColor.clear)
        newMeetButton.layer.shadowRadius = 4
        newMeetButton.layer.shadowOpacity = 0.4
        
        savedMeetButton.addBorder(width: 0, radius: 20, color: UIColor.clear)
        savedMeetButton.layer.shadowRadius = 4
        savedMeetButton.layer.shadowOpacity = 0.4
        
        meetLabel.layer.cornerRadius = 20
        meetLabel.clipsToBounds = true
        meetLabel.addShadow(offset: CGSize.init(width: 0, height: 3), color: UIColor.gray, radius: 2.0, opacity: 0.35)
    }
}

