//
//  PhotosAPI.swift
//  GalleryApp
//
//  Created by Krishantha Jayathilake on 11/4/21.
//

import RxSwift

protocol PhotosAPI {
    func fetchPhotos(pageNumber: Int, perPage: Int) -> Single<[Photo]>
    func searchPhotos(query: String, pageNumber: Int, perPage: Int) -> Single<UnsplashSearchResponse>
    func fetchPhoto(id: String) -> Single<Photo>
}
