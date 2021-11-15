//
//  Dimensions.swift
//  GalleryApp
//
//  Created by Krishantha Jayathilake on 11/5/21.
//

import UIKit

struct Dimensions {
    static let screenWidth: CGFloat = UIScreen.main.bounds.width
    static let screenHeight: CGFloat = UIScreen.main.bounds.height
    
    /// Calculate collection view item size based on screen width
    static let photoItemSize = CGSize(width: Dimensions.screenWidth * 0.95, height: 300)
}
