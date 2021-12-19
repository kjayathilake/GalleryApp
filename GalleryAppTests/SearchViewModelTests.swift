//
//  HomeViewModelTests.swift
//  GalleryAppTests
//
//  Created by Krishantha Jayathilake on 2021-12-18.
//

import XCTest
import RxSwift
import RxBlocking
import RxTest
import RxRelay
import RxCocoa
@testable import GalleryApp

class SearchViewModelTests: XCTestCase {
    var viewModel: SearchViewModel!
    
    var scheduler: TestScheduler!
    var disposeBag: DisposeBag!
    var coordinator: SearchCoordinatorType!
    fileprivate var service : MockPhotosService!
    
    override func setUp() {
        print("=== setup ===")
        self.scheduler = TestScheduler(initialClock: 0)
        self.disposeBag = DisposeBag()
        self.service = MockPhotosService()
        self.coordinator = MockSearchCoordinator()
        
        self.viewModel = SearchViewModel(
            dependencies: SearchViewModel.Dependencies(service: self.service, coordinator: self.coordinator)
        )
    }
    
    override func tearDown() {
        print("=== tear down ===")
        self.viewModel = nil
        self.service = nil
        self.coordinator = nil
        super.tearDown()
    }
    
    func testFetchPhotosOnSearchSuccess() {
        let result = scheduler.createObserver([PhotoViewModel].self)
        let response: UnsplashSearchResponse = self.loadJSON(name: "Search")!
        let expectedResult = response.results.map({ PhotoViewModel(photo: $0) })
        self.service.success = true
        self.service.searchResponse = response
        
        self.viewModel.output.results
            .drive(result)
            .disposed(by: disposeBag)
        
        scheduler.createColdObservable([.next(10, "Apple")])
            .bind(to: self.viewModel.input.search)
            .disposed(by: disposeBag)
        
        scheduler.start()
        
        XCTAssertEqual(result.events, [.next(10, expectedResult)])
    }
    
    func testFetchPhotosOnSearchFailure() {
        let result = scheduler.createObserver([PhotoViewModel].self)
        let errorMessage = scheduler.createObserver(String?.self)
        
        self.service.success = false
        self.service.error = CustomError.decodingFailed
        
        self.viewModel.output.results
            .drive(result)
            .disposed(by: disposeBag)
        
        self.viewModel.output.error
            .drive(errorMessage)
            .disposed(by: disposeBag)
        
        scheduler.createColdObservable([.next(10, "Apple")])
            .bind(to: self.viewModel.input.search)
            .disposed(by: disposeBag)
        
        scheduler.start()
        
        XCTAssertEqual(errorMessage.events, [.next(10, "Invalid Response")])
    }
    
    func testFetchPhotosOnLoadMoreSuccess() {
        let result = scheduler.createObserver([PhotoViewModel].self)
        let response: UnsplashSearchResponse = self.loadJSON(name: "Search")!
        let expectedResult = response.results.map({ PhotoViewModel(photo: $0) })
        self.service.success = true
        self.service.searchResponse = response
        
        self.viewModel.output.results
            .drive(result)
            .disposed(by: disposeBag)
        
        // TODO: This unit test is failing. We shoul first fetch items and then trigger load more event. Then assert if the result contains more items.
        
        scheduler.createColdObservable([.next(10, "Apple")])
            .bind(to: self.viewModel.input.search)
            .disposed(by: disposeBag)

        scheduler.createColdObservable([.next(20, ())])
            .bind(to: self.viewModel.input.more)
            .disposed(by: disposeBag)
        
        scheduler.start()
        
        XCTAssertEqual(result.events, [
            .next(20, [])
        ])
    }
    
    func testFetchPhotosOnLoadMoreFailure() {
        let result = scheduler.createObserver([PhotoViewModel].self)
        let errorMessage = scheduler.createObserver(String?.self)
        
        self.service.success = false
        self.service.error = CustomError.decodingFailed
        
        self.viewModel.output.results
            .drive(result)
            .disposed(by: disposeBag)
        
        self.viewModel.output.error
            .drive(errorMessage)
            .disposed(by: disposeBag)
        
        scheduler.createColdObservable([.next(10, ())])
            .bind(to: self.viewModel.input.more)
            .disposed(by: disposeBag)
        
        scheduler.start()
        
        XCTAssertEqual(errorMessage.events, [.next(10, "Invalid Response")])
    }
    
    func testSelectPhotoSuccess() {
        let result = scheduler.createObserver(PhotoViewModel.self)
        let response: UnsplashSearchResponse = self.loadJSON(name: "Search")!
        let expectedResult = response.results.map({ PhotoViewModel(photo: $0) })
        self.service.success = true
        self.service.photo = response.results.first
        
        self.viewModel.output.selectedItem
            .drive(result)
            .disposed(by: disposeBag)

        scheduler.createColdObservable([.next(10, expectedResult.first!)])
            .bind(to: self.viewModel.input.selectItem)
            .disposed(by: disposeBag)
        
        scheduler.start()
        
        XCTAssertEqual(result.events, [.next(10, expectedResult.first!)])
    }
    
    func loadJSON<T: Decodable>(name: String) -> T? {
      guard let filePath = Bundle(for: type(of: self)).url(forResource: name, withExtension: "json") else {
        return nil
      }

      guard let jsonData = try? Data(contentsOf: filePath, options: .mappedIfSafe) else {
        return nil
      }

      return try? JSONDecoder().decode(T.self, from: jsonData)
    }
    
}
