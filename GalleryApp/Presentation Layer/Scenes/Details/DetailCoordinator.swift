//
//  DetailNavigator.swift
//  GalleryApp
//
//  Created by Krishantha Jayathilake on 2021-11-10.
//

import UIKit

protocol DetailCoordinatorType {
    
}

final class DetailCoordinator: CoordinatorType {
    
    private let navigationController: UINavigationController
    private let photoId: String
    
    init(navigationController: UINavigationController, photoId: String) {
        self.navigationController = navigationController
        self.photoId = photoId
    }
    
    func start() {
        let detailViewModel = DetailViewModel(
            dependencies: DetailViewModel.Dependencies(photoId: self.photoId, api: PhotosService(), coordinator: self)
        )
        let detailViewController = DetailViewController()
        detailViewController.viewModel = detailViewModel
        self.navigationController.pushViewController(detailViewController, animated: true)
    }
}

extension DetailCoordinator: DetailCoordinatorType {
    
}
