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

class HomeViewModelTests: XCTestCase {
    var viewModel: HomeViewModel!
    
    var scheduler: TestScheduler!
    var disposeBag: DisposeBag!
    var coordinator: HomeCoordinatorType!
    fileprivate var service : MockPhotosService!
    
    override func setUp() {
        print("=== setup ===")
        self.scheduler = TestScheduler(initialClock: 0)
        self.disposeBag = DisposeBag()
        self.service = MockPhotosService()
        self.coordinator = MockHomeCoordinator()
        
        self.viewModel = HomeViewModel(
            dependencies: HomeViewModel.Dependencies(service: self.service, coordinator: self.coordinator)
        )
    }
    
    override func tearDown() {
        print("=== tear down ===")
        self.viewModel = nil
        self.service = nil
        self.coordinator = nil
        super.tearDown()
    }
    
    func testFetchPhotosOnViewLoadSuccess() {
        let result = scheduler.createObserver([PhotoViewModel].self)
        let photos: [Photo] = self.loadJSON(name: "Photos")!
        let expectedResult = photos.map({ PhotoViewModel(photo: $0) })
        self.service.success = true
        self.service.photos = photos
        
        self.viewModel.output.results
            .drive(result)
            .disposed(by: disposeBag)
        
        scheduler.createColdObservable([.next(10, ())])
            .bind(to: self.viewModel.input.ready)
            .disposed(by: disposeBag)
        
        scheduler.start()
        
        XCTAssertEqual(result.events, [.next(10, expectedResult)])
    }
    
    func testFetchPhotosOnViewLoadFailure() {
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
            .bind(to: self.viewModel.input.ready)
            .disposed(by: disposeBag)
        
        scheduler.start()
        
        XCTAssertEqual(errorMessage.events, [.next(10, "Invalid Response")])
    }
    
    func testFetchPhotosOnViewReloadSuccess() {
        let result = scheduler.createObserver([PhotoViewModel].self)
        let photos: [Photo] = self.loadJSON(name: "Photos")!
        let expectedResult = photos.map({ PhotoViewModel(photo: $0) })
        self.service.success = true
        self.service.photos = photos
        
        self.viewModel.output.results
            .drive(result)
            .disposed(by: disposeBag)
  
        scheduler.createColdObservable([.next(10, ())])
            .bind(to: self.viewModel.input.reload)
            .disposed(by: disposeBag)
        
        scheduler.start()
        
        XCTAssertEqual(result.events, [.next(10, expectedResult)])
    }
    
    func testFetchPhotosOnViewReloadFailure() {
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
            .bind(to: self.viewModel.input.reload)
            .disposed(by: disposeBag)
        
        scheduler.start()
        
        XCTAssertEqual(errorMessage.events, [.next(10, "Invalid Response")])
    }
    
    func testFetchPhotosOnLoadMoreSuccess() {
        let result = scheduler.createObserver([PhotoViewModel].self)
        let photos: [Photo] = self.loadJSON(name: "Photos")!
        let expectedResult = photos.map({ PhotoViewModel(photo: $0) })
        self.service.success = true
        self.service.photos = photos
        
        self.viewModel.output.results
            .drive(result)
            .disposed(by: disposeBag)

        scheduler.createColdObservable([.next(10, ())])
            .bind(to: self.viewModel.input.more)
            .disposed(by: disposeBag)
        
        scheduler.start()
        
        XCTAssertEqual(result.events, [.next(10, expectedResult)])
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
        let photos: [Photo] = self.loadJSON(name: "Photos")!
        let expectedResult = photos.map({ PhotoViewModel(photo: $0) })
        self.service.success = true
        self.service.photo = photos.first
        
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
