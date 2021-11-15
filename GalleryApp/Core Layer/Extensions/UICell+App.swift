//
//  UICollectionViewCell+App.swift
//  GalleryApp
//
//  Created by Krishantha Jayathilake on 11/5/21.
//

import UIKit

/// Convenience methods for getting reuse identifiers
protocol ReuseIdentifiable: AnyObject {
    static var reuseIdentifier: String { get }
}

extension ReuseIdentifiable {
    static var reuseIdentifier: String { .init(describing: self) }
}

extension UICollectionViewCell: ReuseIdentifiable {}
extension UITableViewCell: ReuseIdentifiable {}

