//
//  MockHomeCoordinator.swift
//  GalleryAppTests
//
//  Created by Krishantha Jayathilake on 2021-12-18.
//

import Foundation

import UIKit
@testable import GalleryApp

final class MockHomeCoordinator: CoordinatorType {
    
    func start() {
        
    }
}

extension MockHomeCoordinator: HomeCoordinatorType {
    
    func navigateToDetailScreen(photoId: String) {
        
    }
    
}
