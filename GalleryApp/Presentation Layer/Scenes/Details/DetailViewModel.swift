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
        let ready: Signal<Void>
    }

    struct Output {
        let result: Driver<PhotoDetailViewModel?>
    }
    
    struct Dependencies {
        let photoId: String
        let api: PhotosAPI
        let coordinator: DetailCoordinatorType
    }
    
    private let dependencies: Dependencies
    
    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }
    
    func transform(input: Input) -> Output {
                
        let result =  input
            .ready
            .asObservable()
            .flatMap { _ in
                self.dependencies.api.fetchPhoto(id: self.dependencies.photoId)
            }
            .map { photo -> PhotoDetailViewModel? in
                return PhotoDetailViewModel(photo: photo)
            }
            .asDriver(onErrorJustReturn: nil)
        
        return Output(result: result)
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
