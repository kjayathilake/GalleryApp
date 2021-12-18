//
//  HomeViewModel.swift
//  GalleryApp
//
//  Created by Krishantha Jayathilake on 11/4/21.
//

import RxSwift
import RxCocoa

final class HomeViewModel: ViewModelType {
    
    struct Input {
        let ready: AnyObserver<Void>
        let reload: AnyObserver<Void>
        let more: AnyObserver<Void>
        let selectItem: AnyObserver<PhotoViewModel>
    }
    
    struct Output {
        let results: Driver<[PhotoViewModel]>
        let selectedItem: Driver<PhotoViewModel>
        let error: Driver<String?>
    }
    
    struct Dependencies {
        let service: PhotosAPI
        let coordinator: HomeCoordinatorType
    }
    
    private(set) var input: Input!
    private(set) var output: Output!
    
    private let ready = PublishSubject<Void>()
    private let reload = PublishSubject<Void>()
    private let more = PublishSubject<Void>()
    private let selectItem = PublishSubject<PhotoViewModel>()
    private let onError = PublishSubject<Error>()
    
    private let dependencies: Dependencies
    private let count = 30
    private var page = 1
    private var hasMore = true
    private var shouldAppend: Bool = false
    private var photos: [PhotoViewModel] = []
    
    init(dependencies: Dependencies) {
        self.dependencies = dependencies
        
        self.input = Input(
            ready: ready.asObserver(),
            reload: reload.asObserver(),
            more: more.asObserver(),
            selectItem: selectItem.asObserver()
        )
        
        self.output = Output(
            results: results(),
            selectedItem: selectedItem(),
            error: error()
        )
    }
    
    private func results() -> Driver<[PhotoViewModel]> {
        
        let reload = self.reload
            .do(onNext: {
                self.shouldAppend = false
                self.page = 1
            })
            .share()
        
        let loadMore = self.more
                .filter({ self.hasMore })
            .do(onNext: {
                self.shouldAppend = true
                self.page += 1
            })
            .share()
        
        return Observable
                .merge(ready, reload, loadMore)
                .flatMap { value in
                    self.dependencies.service.fetchPhotos(pageNumber: self.page, perPage: self.count)
                        .catch { error -> Single<[Photo]> in
                            self.onError.onNext(error)
                            return .never()
                        }
                }
                .map { $0.map { PhotoViewModel(photo: $0) } }
                .map { result -> [PhotoViewModel] in
                    var photos: [PhotoViewModel] = result
                    if result.count < self.count {
                        self.hasMore = false
                    }
                    if self.shouldAppend {
                        self.shouldAppend = false
                        photos = self.photos + result
                    }
                    self.photos = photos
                    return photos
                }
                .asDriver(onErrorJustReturn: [])
    }
    
    private func selectedItem() -> Driver<PhotoViewModel> {
        
        return self.selectItem
            .do(onNext: { model in
                self.dependencies.coordinator.navigateToDetailScreen(photoId: model.id)
            })
            .asDriver(onErrorJustReturn: PhotoViewModel())
    }
    
    private func error() -> Driver<String?> {
        return self.onError
            .map { error -> String in
                return (error as! CustomError).description
            }
            .asDriver(onErrorJustReturn: CustomError.unknown.description)
    }
}
