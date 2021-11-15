//
//  UnsplashHttpRouter.swift
//  GalleryApp
//
//  Created by Krishantha Jayathilake on 11/4/21.
//

import Alamofire

enum PhotosHttpRouter {
    case fetchPhotos(pageNumber: Int, perPage: Int)
    case searchPhotos(query: String, pageNumber: Int, perPage: Int)
    case fetchPhoto(id: String)
}

extension PhotosHttpRouter: HttpRouter {
    var baseURLString: String {
        return BaseURLs.unsplash
    }
    
    var path: String {
        switch self {
        case .fetchPhotos:
            return PhotosEndpoints.getPhotos
        case .searchPhotos:
            return PhotosEndpoints.searchPhotos
        case .fetchPhoto(id: let id):
            return PhotosEndpoints.getPhotoById + id
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .fetchPhotos, .searchPhotos, .fetchPhoto:
            return .get
        }
    }
    
    var headers: HTTPHeaders? {
        return HTTPHeaders(["Authorization" : "Client-ID \(APIKeys.unsplash)"])
    }
    
    var parameters: Parameters? {
        switch self {
        case .fetchPhotos(pageNumber: let page, perPage: let count):
            return ["page": String(page), "per_page": String(count)]
        case .searchPhotos(query: let query, pageNumber: let page, perPage: let count):
            return ["query": query, "page": String(page), "per_page": String(count)]
        case .fetchPhoto:
            return nil
        }
    }
}
