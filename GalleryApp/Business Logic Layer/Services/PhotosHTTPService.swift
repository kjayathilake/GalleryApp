//
//  UnsplashHttpService.swift
//  GalleryApp
//
//  Created by Krishantha Jayathilake on 11/4/21.
//

import Foundation
import Alamofire

class PhotosHTTPService: HttpService {
    var sessionManager: Session = Session.default
    
    func request(_ urlRequest: URLRequestConvertible) -> DataRequest {
        return sessionManager.request(urlRequest).validate(statusCode: 200..<400)
    }
    
    
}
