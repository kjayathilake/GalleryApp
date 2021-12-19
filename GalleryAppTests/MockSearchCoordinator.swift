//
//  MockSearchCoordinator.swift
//  GalleryAppTests
//
//  Created by Krishantha Jayathilake on 2021-12-19.
//

import Foundation

import UIKit
@testable import GalleryApp

final class MockSearchCoordinator: CoordinatorType {
    
    func start() {
        
    }
}

extension MockSearchCoordinator: SearchCoordinatorType {
    
    func navigateToDetailScreen(photoId: String) {
        
    }
    
}
