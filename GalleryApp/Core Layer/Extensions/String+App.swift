//
//  String+App.swift
//  GalleryApp
//
//  Created by Krishantha Jayathilake on 2021-12-18.
//

import Foundation

extension String {
    
    /// Creates a localized string
    var localized: String {
        return NSLocalizedString(self, comment: "")
    }
}
