//
//  SavedTableViewCell.swift
//  MeetMe
//
//  Created by Annie DeMilt on 4/25/22.
//

import UIKit

class SavedTableViewCell: UITableViewCell {

    var adventure: Adventure!
    @IBOutlet weak var adventureLabel: UILabel!
    func didSet() {
        adventureLabel.text = adventure.adventureName
    }
}
