//
//  UIBarButtonItem+Hide.swift
//  MeetMe
//
//  Created by Annie DeMilt on 4/26/22.
//

import UIKit

extension UIBarButtonItem {
    func hide() {
        self.isEnabled = false
        self.tintColor = .clear
    }
}
