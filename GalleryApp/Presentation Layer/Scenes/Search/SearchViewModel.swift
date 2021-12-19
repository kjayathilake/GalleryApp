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
        let search: AnyObserver<String>
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
        let coordinator: SearchCoordinatorType
    }
    
    private(set) var input: Input!
    private(set) var output: Output!
    
    private let search = PublishSubject<String>()
    private let more = PublishSubject<Void>()
    private let selectItem = PublishSubject<PhotoViewModel>()
    private let onError = PublishSubject<Error>()
    
    private let dependencies: Dependencies
    private let count = 30
    private var page = 1
    private var pageCount = 1
    private var shouldAppend: Bool = false
    private var searchtext = ""
    private var photos: [PhotoViewModel] = []
    
    init(dependencies: Dependencies) {
        self.dependencies = dependencies
        
        self.input = Input(
            search: search.asObserver(),
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
        
        let search = self.search
            .filter({ text in
                !text.isEmpty
            })
            .do(onNext: { text in
                self.shouldAppend = false
                self.page = 1
                self.pageCount = 1
                self.searchtext = text
            })
            .share()
        
        let loadMore = self.more
            .filter({ self.page < self.pageCount - 1 })
            .do(onNext: {
                self.shouldAppend = true
                self.page += 1
            })
            .map({ self.searchtext })
            .share()
        
        return Observable
                .merge(search, loadMore)
                .flatMap { text in
                    self.dependencies.service.searchPhotos(query: text, pageNumber: self.page, perPage: self.count)
                        .catch { error -> Single<UnsplashSearchResponse> in
                            self.onError.onNext(error)
                            return .never()
                        }
                }
                .do(onNext: { result in
                    self.page = result.total
                    self.pageCount = result.totalPages
                })
                .map { $0.results.map { PhotoViewModel(photo: $0) } }
                .map { result -> [PhotoViewModel] in
                    var photos: [PhotoViewModel] = result
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
