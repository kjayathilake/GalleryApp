//
//  CoordinatorType.swift
//  GalleryApp
//
//  Created by Krishantha Jayathilake on 2021-11-14.
//

import Foundation

protocol CoordinatorType: AnyObject {
    func start()
    func coordinate(to coordinator: CoordinatorType)
}

extension CoordinatorType {
    func coordinate(to coordinator: CoordinatorType) {
        coordinator.start()
    }
}
