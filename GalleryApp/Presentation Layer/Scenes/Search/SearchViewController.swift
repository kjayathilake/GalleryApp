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
        setupUI()
        bindViewModel()
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
    
    /// Bind View Model
    func bindViewModel() {
        
        let input = SearchViewModel.Input(
            search: searchController.searchBar.rx.text.orEmpty.asDriver(),
            more: collectionView.rx.reachedBottom().asSignal(),
            selected: collectionView.rx.modelSelected(PhotoViewModel.self).asSignal()
        )
        
        let output = viewModel.transform(input: input)
        
        output.results
            .drive(
                collectionView.rx.items(
                    cellIdentifier: PhotoCell.reuseIdentifier, cellType: PhotoCell.self
                )
            ) { tableView, viewModel, cell in
                cell.bind(to: viewModel)
            }
            .disposed(by: rx.disposeBag)
        
        output.selected
            .emit()
            .disposed(by: rx.disposeBag)
    }

}
