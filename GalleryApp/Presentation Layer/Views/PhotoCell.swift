//
//  PhotoCell.swift
//  GalleryApp
//
//  Created by Krishantha Jayathilake on 11/5/21.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import Nuke
import RxNuke
import NSObject_Rx

class PhotoCell: UICollectionViewCell {
    
    // MARK: - Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Properties
    
    lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 10
        return imageView
    }()
    
    lazy var activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.hidesWhenStopped = true
        indicator.center = self.contentView.center
        return indicator
    }()
    
    lazy var profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = .lightGray
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 15
        return imageView
    }()
    
    lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 14, weight: .semibold)
        return label
    }()
    
    lazy var likeIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.tintColor = .systemPink
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    lazy var numberOfLikes: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 14, weight: .semibold)
        return label
    }()
    
    func bind(to viewModel: PhotoViewModel) {
        
        // Reset the image view
        self.imageView.image = nil
        self.profileImageView.image = nil
        
        self.imageView.backgroundColor = UIColor(hexString: viewModel.color)
        self.profileImageView.backgroundColor = UIColor(hexString: viewModel.color)
        self.nameLabel.text = viewModel.name
        self.numberOfLikes.text = "\(viewModel.likes)"
        
        let likeIconName = viewModel.isLikedByUser ? "heart.fill" : "heart"
        self.likeIcon.image = UIImage(systemName: likeIconName)
        
        let pipeline = ImagePipeline.shared
        
        let mainImageURL = URL(string: viewModel.mainImageURL)!
        let profileImageURL = URL(string: viewModel.profileImageURL)!
        
        let cacheRequest = URLRequest(url: mainImageURL, cachePolicy: .returnCacheDataDontLoad)
        let networkRequest = URLRequest(url: mainImageURL, cachePolicy: .useProtocolCachePolicy)
                
        Observable.concat(pipeline.rx.loadImage(with: ImageRequest(urlRequest: cacheRequest)).orEmpty,
                          pipeline.rx.loadImage(with: ImageRequest(urlRequest: networkRequest)).orEmpty)
            .take(1)
            .subscribe(onNext: { self.imageView.image = $0.image })
            .disposed(by: rx.disposeBag)
        
        pipeline.rx.loadImage(with: profileImageURL)
            .subscribe(onSuccess: { self.profileImageView.image = $0.image })
            .disposed(by: rx.disposeBag)
        
    }

}

// MARK: - UI Setup

private extension PhotoCell {
    
    func setupUI() {
        
        // Add subviews
        
        self.contentView.addSubview(imageView)
        self.contentView.addSubview(activityIndicator)
        self.contentView.addSubview(profileImageView)
        self.contentView.addSubview(nameLabel)
        self.contentView.addSubview(likeIcon)
        self.contentView.addSubview(numberOfLikes)
        
        // Setup constraints with SnapKit
        
        imageView.snp.makeConstraints { (make) in
            make.left.equalTo(self.contentView).offset(15)
            make.top.equalTo(self.contentView)
            make.right.equalTo(self.contentView).offset(-15)
            make.height.equalTo(250)
        }
        
        activityIndicator.snp.makeConstraints { (make) in
            make.centerX.equalTo(imageView)
            make.centerY.equalTo(imageView)
        }
        
        profileImageView.snp.makeConstraints { (make) in
            make.left.equalTo(self.contentView).offset(15)
            make.top.equalTo(self.imageView.snp.bottom).offset(8)
            make.height.equalTo(30)
            make.width.equalTo(30)
        }
        
        nameLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self.profileImageView.snp.right).offset(8)
            make.right.equalTo(self.likeIcon.snp.left).offset(-8)
            make.centerY.equalTo(profileImageView)
            make.height.equalTo(20)
        }
        
        numberOfLikes.snp.makeConstraints { (make) in
            make.right.equalTo(self.contentView).offset(-15)
            make.centerY.equalTo(profileImageView)
            make.height.equalTo(20)
        }
        
        likeIcon.snp.makeConstraints { (make) in
            make.right.equalTo(self.numberOfLikes.snp.left).offset(-8)
            make.centerY.equalTo(profileImageView)
            make.height.equalTo(20)
            make.width.equalTo(20)
        }
    }
}

struct PhotoViewModel {
    var id: String
    var name: String
    var mainImageURL: String
    var profileImageURL: String
    var likes: Int
    var blurHash: String
    var isLikedByUser: Bool
    var color: String
    
    init(photo: Photo) {
        self.id = photo.id
        self.name = photo.user.name
        self.likes = photo.likes
        self.blurHash = photo.blurHash
        self.mainImageURL = photo.urls.regular
        self.profileImageURL = photo.user.profileImage.small
        self.isLikedByUser = photo.likedByUser
        self.color = photo.color
    }
}
