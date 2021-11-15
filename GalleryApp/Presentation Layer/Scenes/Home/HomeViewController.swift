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
        setupUI()
        //bindCollectionView()
        bindViewModel()
        ready.accept(())
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
    
    func bindCollectionView() {
        collectionView.rx.willDisplayCell
            .filter { $0.cell.isKind(of: PhotoCell.self) }
            .map { ($0.cell as! PhotoCell, $0.at.item)}
            .subscribe(onNext: { (cell, index) in
                cell.imageView.image = nil
            })
            .disposed(by: rx.disposeBag)
        
        
    }
    
    /// Bind View Model
    func bindViewModel() {
        
        let input = HomeViewModel.Input(
            ready: ready.asSignal(),
            reload: refreshHandler.refresh.asSignal(),
            more: collectionView.rx.reachedBottom().asSignal(),
            selected: collectionView.rx.modelSelected(PhotoViewModel.self).asSignal()
        )
        
        let output = viewModel.transform(input: input)
        
        output.results
            .do(onNext: { _ in self.refreshHandler.end() })
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
