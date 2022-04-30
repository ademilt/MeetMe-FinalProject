//
//  UIView+addBorder.swift
//  MeetMe
//
//  Created by Annie DeMilt on 4/29/22.
//

import UIKit

extension UIView {
    func addBorder(width: CGFloat, radius: CGFloat, color: UIColor) {
        self.layer.borderWidth = width
        self.layer.borderColor = color.cgColor
        self.layer.cornerRadius = radius
    }
    func noBorder() {
        self.layer.borderWidth = 0.0
    }
    
}
