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
        let ready: Signal<Void>
        let reload: Signal<Void>
        let more: Signal<Void>
        let selected: Signal<PhotoViewModel>
    }
    
    struct Output {
        let results: Driver<[PhotoViewModel]>
        let selected: Signal<Void>
    }
    
    struct Dependencies {
        let api: PhotosAPI
        let coordinator: HomeCoordinatorType
    }
    
    private let dependencies: Dependencies
    private let count = 30
    private var page = 1
    private var hasMore = true
    private var photos: [PhotoViewModel] = []
    
    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }
    
    func transform(input: Input) -> Output {
        
        let ready = input.ready.asObservable()
        let reload = input.reload.asObservable()
        
        let results = Observable
            .merge(ready, reload)
            .do(onNext: {
                self.page = 1
                self.hasMore = true
            })
            .flatMap { value in
                self.dependencies.api.fetchPhotos(pageNumber: self.page, perPage: self.count)
            }
            .map { $0.map { PhotoViewModel(photo: $0) } }
            .do(onNext: { result in
                if result.count < self.count {
                    self.hasMore = false
                }
                self.photos = result
            })
            .share()
        
        let loadMore = input
            .more
            .asObservable()
            .skip(1)
            .filter({ self.hasMore })
            .do(onNext: {
                self.page += 1
            })
            .flatMap { value in
                self.dependencies.api.fetchPhotos(pageNumber: self.page, perPage: self.count)
            }
            .map { $0.map { PhotoViewModel(photo: $0) } }
            .map { self.photos + $0 }
            .do(onNext: { result in
                if result.count < self.count {
                    self.hasMore = false
                }
                self.photos = result
            })
            .share()
                
        let mappedResults = Observable
            .merge(results, loadMore)
            .asDriver(onErrorJustReturn: [])
                
        let selected = input
            .selected
            .asObservable()
            .do(onNext: { model in
                self.dependencies.coordinator.navigateToDetailScreen(photoId: model.id)
            })
            .map { _ in () }
            .asSignal(onErrorJustReturn: ())
        
        return Output(results: mappedResults, selected: selected)
    }
}
