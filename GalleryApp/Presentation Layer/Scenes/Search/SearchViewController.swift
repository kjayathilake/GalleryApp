//
//  SearchViewController.swift
//  GalleryApp
//
//  Created by Krishantha Jayathilake on 2021-11-14.
//

import UIKit
import SnapKit
import RxCocoa
import RxSwift
import NSObject_Rx

class SearchViewController: UIViewController {
    
    var viewModel: SearchViewModel!
    
    lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout())
        collectionView.backgroundColor = .white
        collectionView.register(PhotoCell.self, forCellWithReuseIdentifier: PhotoCell.reuseIdentifier)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    lazy var searchController: UISearchController = {
        let controller = UISearchController()
        controller.hidesNavigationBarDuringPresentation = true
        controller.definesPresentationContext = true
        controller.searchBar.searchBarStyle = .prominent
        controller.automaticallyShowsCancelButton = true
        controller.searchBar.placeholder = "Search photos"
        return controller
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        self.bindViewModelInputs()
        self.bindViewModelOutputs()
    }
}

private extension SearchViewController {
    
    /// Setup UI
    func setupUI() {
        if #available(iOS 13.0, *) {
            self.overrideUserInterfaceStyle = .light
        }
        self.view.backgroundColor = .white
        self.view.addSubview(collectionView)
        self.navigationItem.searchController = searchController
        self.title = "Search"
        
        // Setup view constraints with SnapKit
        collectionView.snp.makeConstraints { (make) in
            make.left.equalTo(self.view)
            make.top.equalTo(self.view)
            make.right.equalTo(self.view)
            make.bottom.equalTo(self.view)
        }
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
        
        self.searchController.searchBar.rx.text.orEmpty
            .bind(to: self.viewModel.input.search)
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
