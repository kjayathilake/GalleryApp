//
//  UIViewController+Rx.swift
//  GalleryApp
//
//  Created by Krishantha Jayathilake on 2021-11-08.
//

import RxSwift
import RxCocoa
import UIKit

extension Reactive where Base: UIViewController {
    var viewWillAppear: ControlEvent<Void> {
        let source = self.methodInvoked(#selector(Base.viewWillAppear(_:))).map { _ in }
        return ControlEvent(events: source)
    }
    
    var viewDidLoad: ControlEvent<Void> {
        let source = self.methodInvoked(#selector(Base.viewDidLoad)).map { _ in }
        return ControlEvent(events: source)
    }
}
