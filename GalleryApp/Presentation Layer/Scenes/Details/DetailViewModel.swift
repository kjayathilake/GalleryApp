//
//  DetailViewModel.swift
//  GalleryApp
//
//  Created by Krishantha Jayathilake on 2021-11-10.
//

import RxSwift
import RxCocoa

final class DetailViewModel: ViewModelType {
    
    struct Input {
        let ready: AnyObserver<Void>
    }

    struct Output {
        let result: Driver<PhotoDetailViewModel?>
        let error: Driver<String?>
    }
    
    struct Dependencies {
        let photoId: String
        let service: PhotosAPI
        let coordinator: DetailCoordinatorType
    }
    
    private(set) var input: Input!
    private(set) var output: Output!
    
    private let ready = PublishSubject<Void>()
    private let onError = PublishSubject<Error>()
    
    private let dependencies: Dependencies
    
    init(dependencies: Dependencies) {
        self.dependencies = dependencies
        
        self.input = Input(
            ready: ready.asObserver()
        )
        
        self.output = Output(
            result: result(),
            error: error()
        )
    }
    
    private func result() -> Driver<PhotoDetailViewModel?> {
        
        return self.ready
            .flatMap { _ in
                self.dependencies.service.fetchPhoto(id: self.dependencies.photoId)
                    .catch { error -> Single<Photo> in
                        self.onError.onNext(error)
                        return .never()
                    }
            }
            .map { photo -> PhotoDetailViewModel? in
                return PhotoDetailViewModel(photo: photo)
            }
            .asDriver(onErrorJustReturn: nil)
    }

    private func error() -> Driver<String?> {
        return self.onError
            .map { error -> String in
                return (error as! CustomError).description
            }
            .asDriver(onErrorJustReturn: CustomError.unknown.description)
    }
}

struct PhotoDetailViewModel {

    var id: String
    var name: String
    var mainImageURL: String
    var profileImageURL: String
    var likes: Int
    var blurHash: String
    var isLikedByUser: Bool
    var color: String
    var description: String?
    var views: Int
    var downloads: Int
    var topics: [String]
    var width: Int
    var height: Int
    
    init(photo: Photo) {
        self.id = photo.id
        self.name = photo.user.name
        self.likes = photo.likes
        self.blurHash = photo.blurHash ?? ""
        self.mainImageURL = photo.urls.regular
        self.profileImageURL = photo.user.profileImage.small
        self.isLikedByUser = photo.likedByUser
        self.color = photo.color ?? ""
        if let desc = photo.photoDescription, desc != "" {
            self.description = desc
        } else if let desc = photo.altDescription, desc != "" {
            self.description = desc
        }
        self.views = photo.views ?? 0
        self.downloads = photo.downloads ?? 0
        self.topics = []
        self.width = photo.width
        self.height = photo.height
        if let topics = photo.topics {
            for topic in topics {
                guard let title = topic.title else { return }
                self.topics.append(title)
            }
        }

    }
}
