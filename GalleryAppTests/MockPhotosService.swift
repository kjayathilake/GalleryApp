//
//  MockPhotosService.swift
//  GalleryAppTests
//
//  Created by Krishantha Jayathilake on 2021-12-18.
//

import Foundation
import RxSwift
@testable import GalleryApp

final class MockPhotosService: PhotosAPI {

    var photos: [Photo] = []
    var searchResponse: UnsplashSearchResponse? = nil
    var photo: Photo? = nil
    
    var error: Error? = nil
    var success: Bool = true
    
    func fetchPhotos(pageNumber: Int, perPage: Int) -> Single<[Photo]> {
        if self.success {
            return Single.just(self.photos)
        } else {
            return Single.error(self.error!)
        }
    }
    
    func searchPhotos(query: String, pageNumber: Int, perPage: Int) -> Single<UnsplashSearchResponse> {
        if self.success {
            return Single.just(self.searchResponse!)
        } else {
            return Single.error(self.error!)
        }
    }
    
    func fetchPhoto(id: String) -> Single<Photo> {
        if self.success {
            return Single.just(self.photo!)
        } else {
            return Single.error(self.error!)
        }
    }
}
