//
//  MKPlacemark.swift
//  MeetMe
//
//  Created by Annie DeMilt on 4/29/22.
//

//from Apple Developer
import MapKit
import Contacts

extension MKPlacemark {
    var formattedAddress: String? {
        guard let postalAddress = postalAddress else { return nil }
        return CNPostalAddressFormatter.string(from: postalAddress, style: .mailingAddress).replacingOccurrences(of: "\n", with: " ")
    }
}
