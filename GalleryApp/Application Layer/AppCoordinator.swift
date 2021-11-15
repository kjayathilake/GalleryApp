//
//  AppCoordinator.swift
//  GalleryApp
//
//  Created by Krishantha Jayathilake on 2021-11-14.
//

import UIKit

class AppCoordinator: CoordinatorType {
    let window: UIWindow
    
    lazy var tabBar: UITabBarController = {
        return standardTabBarController()
    }()
    
    lazy var homeNavigator: UINavigationController = {
        let navigator = standardNavigationController()
        navigator.tabBarItem = UITabBarItem(title: "Home", image: UIImage(systemName: "house"), selectedImage: nil)
        return navigator
    }()
    
    lazy var searchNavigator: UINavigationController = {
        let navigator = standardNavigationController()
        navigator.tabBarItem = UITabBarItem(title: "Search", image: UIImage(systemName: "magnifyingglass"), selectedImage: nil)
        return navigator
    }()
    
    init(window: UIWindow) {
        self.window = window
    }
    
    /// Start app coordinator
    func start() {

        // Setup root view controller and present
        let homeCoordinator = HomeCoordinator(navigationController: homeNavigator)
        coordinate(to: homeCoordinator)
        
        let searchCoordinator = SearchCoordinator(navigationController: searchNavigator)
        coordinate(to: searchCoordinator)
        
        self.tabBar.viewControllers = [homeNavigator, searchNavigator]
        
        window.rootViewController = self.tabBar
        window.makeKeyAndVisible()
    }
}
