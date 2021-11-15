//
//  ViewModelType.swift
//  GalleryApp
//
//  Created by Krishantha Jayathilake on 2021-11-07.
//

import Foundation

protocol ViewModelType {
    associatedtype Input
    associatedtype Output
    
    func transform(input: Input) -> Output
}
