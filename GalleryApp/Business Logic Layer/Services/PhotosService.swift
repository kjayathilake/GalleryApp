//
//  PhotosService.swift
//  GalleryApp
//
//  Created by Krishantha Jayathilake on 11/4/21.
//

import Foundation
import RxSwift
import Alamofire

class PhotosService {
    
    private lazy var httpService = PhotosHTTPService()
    static let shared: PhotosService = PhotosService()
    private var tasks: [Int: DataRequest] = [:]
}

extension PhotosService: PhotosAPI {
    
    func fetchPhoto(id: String) -> Single<Photo> {
        return Single.create { [httpService] (single) -> Disposable in
            do {
                try PhotosHttpRouter.fetchPhoto(id: id)
                    .request(usingHttpService: httpService)
                    .responseJSON(completionHandler: { (result) in
                        do {
                            let photo = try PhotosService.parsePhotos(
                                type: Photo.self,
                                result: result
                            )
                            single(.success(photo))
                        } catch {
                            single(.failure(error))
                        }
                    })
            } catch {
                single(.failure(NetworkError.invalidURL))
            }
            return Disposables.create()
        }
    }

    func fetchPhotos(pageNumber: Int, perPage: Int) -> Single<[Photo]> {
        return Single.create { [httpService] (single) -> Disposable in
            do {
                try PhotosHttpRouter.fetchPhotos(pageNumber: pageNumber, perPage: perPage)
                    .request(usingHttpService: httpService)
                    .responseJSON(completionHandler: { (result) in
                        do {
                            let photos = try PhotosService.parsePhotos(
                                type: UnsplashResponse.self,
                                result: result
                            )
                            single(.success(photos))
                        } catch {
                            single(.failure(error))
                        }
                    })
            } catch {
                single(.failure(NetworkError.invalidURL))
            }
            return Disposables.create()
        }
    }
    
    func searchPhotos(query: String, pageNumber: Int, perPage: Int) -> Single<UnsplashSearchResponse> {
        print("x query: \(query)")
        return Single.create { [httpService] (single) -> Disposable in
            do {
                try PhotosHttpRouter.searchPhotos(query: query, pageNumber: pageNumber, perPage: perPage)
                    .request(usingHttpService: httpService)
                    .responseJSON(completionHandler: { (result) in
                        do {
                            let photos = try PhotosService.parsePhotos(
                                type: UnsplashSearchResponse.self,
                                result: result
                            )
                            print("x success")
                            single(.success(photos))
                        } catch {
                            print("x failed \(error.localizedDescription)")
                            single(.failure(error))
                        }
                    })
            } catch {
                print("x failed")
                single(.failure(NetworkError.invalidURL))
            }
            return Disposables.create()
        }
    }
}

extension PhotosService {
    static func parsePhotos<T: Decodable>(type: T.Type, result: AFDataResponse<Any>) throws -> T {
        guard let data = result.data else {
            throw NetworkError.decodingFailed
        }
        
        do {
            let photosResponse = try JSONDecoder().decode(T.self, from: data)
            return photosResponse
        } catch {
            print(error)
            throw error
        }
    }
}
