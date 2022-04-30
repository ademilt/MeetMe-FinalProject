//
//  SavedTableViewCell.swift
//  MeetMe
//
//  Created by Annie DeMilt on 4/25/22.
//

import UIKit

class SavedTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var adventureLabel: UILabel!
    var adventure: Adventure!{
        didSet{adventureLabel.text = "\(adventure.adventureName)"
        }
    }
    
}
