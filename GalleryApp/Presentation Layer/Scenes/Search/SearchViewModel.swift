//
//  SearchViewModel.swift
//  GalleryApp
//
//  Created by Krishantha Jayathilake on 2021-11-14.
//

import RxSwift
import RxCocoa

final class SearchViewModel: ViewModelType {

    struct Input {
        let search: Driver<String>
        let more: Signal<Void>
        let selected: Signal<PhotoViewModel>
    }

    struct Output {
        let results: Driver<[PhotoViewModel]>
        let selected: Signal<Void>
    }
    
    struct Dependencies {
        let api: PhotosAPI
        let coordinator: SearchCoordinatorType
    }
    
    private let dependencies: Dependencies
    private let count = 30
    private var page = 1
    private var hasMore = true
    private var searchtext = ""
    private var photos: [PhotoViewModel] = []
    
    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }
    
    func transform(input: Input) -> Output {
        
        let searchResults = input
            .search
            .distinctUntilChanged()
            .debounce(.milliseconds(300))
            .filter({ text in
                !text.isEmpty
            })
            .asObservable()
            .do(onNext: { text in
                self.searchtext = text
                self.page = 1
                self.hasMore = true
                print("x text: \(text)")
            })
            .flatMap { text in
                self.dependencies.api.searchPhotos(query: text, pageNumber: self.page, perPage: self.count)
            }
            .map { $0.results.map { PhotoViewModel(photo: $0) } }
            .do(onNext: { result in
                if result.count < self.count {
                    self.hasMore = false
                }
                self.photos = result
                print("x a count: \(result.count)")
            })
            .share()
        
        let loadMore = input
            .more
            .asObservable()
            .skip(1)
            .filter({ text in
                !self.searchtext.isEmpty
            })
            .filter({ self.hasMore })
            .do(onNext: {
                self.page += 1
                print("x page: \(self.page)")
            })
            .flatMap { _ in
                self.dependencies.api.searchPhotos(query: self.searchtext, pageNumber: self.page, perPage: self.count)
            }
            .map { $0.results.map { PhotoViewModel(photo: $0) } }
            .map { self.photos + $0 }
            .do(onNext: { result in
                if result.count < self.count {
                    self.hasMore = false
                }
                self.photos = result
                print("x s count: \(result.count)")
            })
            .share()
        
        let mappedResults = Observable
            .merge(searchResults, loadMore)
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
