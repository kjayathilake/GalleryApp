//
//  RefreshHandler.swift
//  GalleryApp
//
//  Created by Krishantha Jayathilake on 2021-11-09.
//

import Foundation
import RxSwift
import RxCocoa

/// Helper class for handling refresh control
class RefreshHandler: NSObject {
    let refresh = PublishRelay<Void>()
    let refreshControl = UIRefreshControl()
    
    init(view: UIScrollView) {
        super.init()
        refreshControl.attributedTitle = NSAttributedString(string: "Fetch new images")
        view.addSubview(refreshControl)
        refreshControl.addTarget(self, action: #selector(refreshControlDidRefresh(_: )), for: .valueChanged)
    }
    
    // MARK: - Action
    @objc func refreshControlDidRefresh(_ control: UIRefreshControl) {
        refreshControl.attributedTitle = NSAttributedString(string: "Fetching new images")
        refresh.accept(())
    }
    
    func end() {
        refreshControl.endRefreshing()
        refreshControl.attributedTitle = NSAttributedString(string: "Fetch new images")
    }
    
}
