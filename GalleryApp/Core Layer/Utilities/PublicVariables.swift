//
//  PublicVariables.swift
//  GalleryApp
//
//  Created by Krishantha Jayathilake on 2021-11-14.
//

import UIKit

public func standardNavigationController() -> UINavigationController {
    let navigationController = UINavigationController()
    let appearance = UINavigationBarAppearance()
    appearance.configureWithOpaqueBackground()
    appearance.backgroundColor = .white
    navigationController.navigationBar.isTranslucent = false
    navigationController.navigationBar.standardAppearance = appearance
    navigationController.navigationBar.scrollEdgeAppearance = navigationController.navigationBar.standardAppearance
    
    return navigationController
}

public func standardTabBarController() -> UITabBarController {
    let tabBarController = UITabBarController()
    let appearance = UITabBarAppearance()
    appearance.configureWithOpaqueBackground()
    appearance.backgroundColor = .white
    tabBarController.tabBar.isTranslucent = false
    tabBarController.tabBar.standardAppearance = appearance
    if #available(iOS 15.0, *) {
        tabBarController.tabBar.scrollEdgeAppearance = tabBarController.tabBar.standardAppearance
    }
    
    return tabBarController
}
