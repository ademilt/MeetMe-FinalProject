//
//  UILabelEnhancement.swift
//  MeetMe
//
//  Created by Annie DeMilt on 4/30/22.
//

import UIKit
import SwiftUI
import MapKit

extension UILabel {
    func addShadow(offset: CGSize, color: UIColor, radius: CGFloat, opacity: Float) {
           layer.masksToBounds = false
           layer.shadowOffset = offset
           layer.shadowColor = color.cgColor
           layer.shadowRadius = radius
           layer.shadowOpacity = opacity

           let backgroundCGColor = backgroundColor?.cgColor
           backgroundColor = nil
           layer.backgroundColor =  backgroundCGColor
       }
}

extension UITextView {
    func addShadow(offset: CGSize, color: UIColor, radius: CGFloat, opacity: Float) {
           layer.masksToBounds = false
           layer.shadowOffset = offset
           layer.shadowColor = color.cgColor
           layer.shadowRadius = radius
           layer.shadowOpacity = opacity

           let backgroundCGColor = backgroundColor?.cgColor
           backgroundColor = nil
           layer.backgroundColor =  backgroundCGColor
       }
}

extension UITextField {
    func addShadow(offset: CGSize, color: UIColor, radius: CGFloat, opacity: Float) {
           layer.masksToBounds = false
           layer.shadowOffset = offset
           layer.shadowColor = color.cgColor
           layer.shadowRadius = radius
           layer.shadowOpacity = opacity

           let backgroundCGColor = backgroundColor?.cgColor
           backgroundColor = nil
           layer.backgroundColor =  backgroundCGColor
       }
}

extension MKMapView {
    func addShadow(offset: CGSize, color: UIColor, radius: CGFloat, opacity: Float) {
           layer.masksToBounds = false
           layer.shadowOffset = offset
           layer.shadowColor = color.cgColor
           layer.shadowRadius = radius
           layer.shadowOpacity = opacity

           let backgroundCGColor = backgroundColor?.cgColor
           backgroundColor = nil
           layer.backgroundColor =  backgroundCGColor
       }
}
