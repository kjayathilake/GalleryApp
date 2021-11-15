//
//  RxSwift+App.swift
//  GalleryApp
//
//  Created by Krishantha Jayathilake on 2021-11-10.
//

import RxSwift

public extension RxSwift.PrimitiveSequence {
    var orEmpty: Observable<Element> {
        asObservable().catch { _ in .empty() }
    }
}
