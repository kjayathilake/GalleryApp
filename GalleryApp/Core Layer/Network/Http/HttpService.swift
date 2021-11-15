//
//  HttpService.swift
//  GalleryApp
//
//  Created by Krishantha Jayathilake on 11/4/21.
//

import Alamofire

protocol HttpService {
    var sessionManager: Session { get set }
    func request(_ urlRequest: URLRequestConvertible) -> DataRequest
}
