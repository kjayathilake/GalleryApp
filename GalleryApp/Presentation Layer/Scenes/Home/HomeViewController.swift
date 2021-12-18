//
//  HomeViewController.swift
//  GalleryApp
//
//  Created by Krishantha Jayathilake on 11/4/21.
//

import UIKit
import SnapKit
import RxCocoa
import RxSwift
import NSObject_Rx

class HomeViewController: UIViewController {
    
    var viewModel: HomeViewModel!
    private var refreshHandler: RefreshHandler!
    var ready: PublishRelay = PublishRelay<Void>()
    
    lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout())
        collectionView.backgroundColor = .white
        collectionView.register(PhotoCell.self, forCellWithReuseIdentifier: PhotoCell.reuseIdentifier)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        self.bindViewModelInputs()
        self.bindViewModelOutputs()
        self.ready.accept(())
    }
}

private extension HomeViewController {
    
    /// Setup UI
    func setupUI() {
        if #available(iOS 13.0, *) {
            self.overrideUserInterfaceStyle = .light
        }
        self.view.backgroundColor = .white
        self.view.addSubview(collectionView)
        self.title = "Home"
        
        // Setup view constraints with SnapKit
        collectionView.snp.makeConstraints { (make) in
            make.left.equalTo(self.view)
            make.top.equalTo(self.view)
            make.right.equalTo(self.view)
            make.bottom.equalTo(self.view)
        }
        
        refreshHandler = RefreshHandler(view: self.collectionView)
        
    }
    
    /// Setup collection view layout
    func collectionViewLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.itemSize = Dimensions.photoItemSize
        // Calculate number of cells based on screen width
        let numberOfCellsInRow = floor(Dimensions.screenWidth / Dimensions.photoItemSize.width)
        let inset = (Dimensions.screenWidth - (numberOfCellsInRow * Dimensions.photoItemSize.width)) / (numberOfCellsInRow + 1)
        layout.sectionInset = .init(top: inset,
                                    left: inset,
                                    bottom: inset,
                                    right: inset)
        return layout
    }
    
    func bindViewModelInputs() {
        self.ready
            .bind(to: self.viewModel.input.ready)
            .disposed(by: rx.disposeBag)
        
        self.refreshHandler.refresh
            .bind(to: self.viewModel.input.reload)
            .disposed(by: rx.disposeBag)
        
        self.collectionView.rx.reachedBottom()
            .bind(to: self.viewModel.input.more)
            .disposed(by: rx.disposeBag)
        
        self.collectionView.rx.modelSelected(PhotoViewModel.self)
            .bind(to: self.viewModel.input.selectItem)
            .disposed(by: rx.disposeBag)
    }
    
    func bindViewModelOutputs() {
        self.viewModel.output.results
            .do(onNext: { _ in self.refreshHandler.end() })
            .drive(
                collectionView.rx.items(
                    cellIdentifier: PhotoCell.reuseIdentifier, cellType: PhotoCell.self
                )
            ) { row, viewModel, cell in
                cell.bind(to: viewModel)
            }
            .disposed(by: rx.disposeBag)
        
        self.viewModel.output.selectedItem
            .drive()
            .disposed(by: rx.disposeBag)
        
        self.viewModel.output.error
            .drive(onNext: { message in
                if message != nil {
                    self.showErrorMessage(message: message!)
                }
            })
            .disposed(by: rx.disposeBag)
    }
    
    func showErrorMessage(message: String) {
                
        let alert = UIAlertController(title: kError.localized, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: kOK.localized, style: .default) { _ in
            alert.dismiss(animated: true, completion: nil)
        }
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
}
