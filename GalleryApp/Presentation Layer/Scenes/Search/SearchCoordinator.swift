//
//  SearchCoordinator.swift
//  GalleryApp
//
//  Created by Krishantha Jayathilake on 2021-11-14.
//

import UIKit

protocol SearchCoordinatorType {
    func navigateToDetailScreen(photoId: String)
}

final class SearchCoordinator: CoordinatorType {
    
    private let navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let searchViewController = SearchViewController()
        let searchViewModel = SearchViewModel(
            dependencies: SearchViewModel.Dependencies(service: PhotosService(), coordinator: self)
        )
        searchViewController.viewModel = searchViewModel
        navigationController.viewControllers = [searchViewController]
    }
    
}

extension SearchCoordinator: SearchCoordinatorType {
    
    func navigateToDetailScreen(photoId: String) {
        let detailCoordinator = DetailCoordinator(navigationController: navigationController, photoId: photoId)
        coordinate(to: detailCoordinator)
    }
}
