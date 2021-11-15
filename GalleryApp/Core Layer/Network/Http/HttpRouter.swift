//
//  HttpRouter.swift
//  GalleryApp
//
//  Created by Krishantha Jayathilake on 11/4/21.
//

import Foundation
import Alamofire

protocol HttpRouter {
    var baseURLString: String { get }
    var path: String { get }
    var method: HTTPMethod { get }
    var headers: HTTPHeaders? { get }
    var parameters: Parameters? { get }
    
    func body() throws -> Data?
    func request(usingHttpService service: HttpService) throws -> DataRequest
}

extension HttpRouter {
    
    var headers: HTTPHeaders? { return nil }
    var parameters: Parameters? { return nil }
    func body() throws -> Data? { return nil }
    
    func asUrlRequest() throws -> URLRequest {
        var url = try baseURLString.asURL()
        url.appendPathComponent(path)
        
        let request = AF.request(url,
                                 method: method,
                                 parameters: parameters,
                                 encoding: URLEncoding.queryString,
                                 headers: headers)
        
        //request.convertible.asURLRequest().httpBody = try body()
        return try request.convertible.asURLRequest()
    }
    
    func request(usingHttpService service: HttpService) throws -> DataRequest {
        return try service.request(asUrlRequest())
    }
}
