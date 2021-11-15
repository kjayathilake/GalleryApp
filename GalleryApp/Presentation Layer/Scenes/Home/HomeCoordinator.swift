//
//  HomeCoordinator.swift
//  GalleryApp
//
//  Created by Krishantha Jayathilake on 11/4/21.
//

import UIKit

protocol HomeCoordinatorType {
    func navigateToDetailScreen(photoId: String)
}

final class HomeCoordinator: CoordinatorType {
    
    private let navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let homeViewController = HomeViewController()
        let homeViewModel = HomeViewModel(
            dependencies: HomeViewModel.Dependencies(api: PhotosService(), coordinator: self)
        )
        homeViewController.viewModel = homeViewModel
        navigationController.viewControllers = [homeViewController]
    }
    
}

extension HomeCoordinator: HomeCoordinatorType {
    
    func navigateToDetailScreen(photoId: String) {
        let detailCoordinator = DetailCoordinator(navigationController: navigationController, photoId: photoId)
        coordinate(to: detailCoordinator)
    }
}
