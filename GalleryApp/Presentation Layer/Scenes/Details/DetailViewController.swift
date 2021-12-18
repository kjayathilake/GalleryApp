//
//  DetailViewController.swift
//  GalleryApp
//
//  Created by Krishantha Jayathilake on 2021-11-10.
//

import UIKit
import SnapKit
import RxCocoa
import RxSwift
import Nuke
import RxNuke
import NSObject_Rx

class DetailViewController: UIViewController {
    
    var viewModel: DetailViewModel!
    var ready: PublishRelay = PublishRelay<Void>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        self.bindViewModelInputs()
        self.bindViewModelOutputs()
        self.ready.accept(())
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
    
    lazy var descriptionTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 14, weight: .semibold)
        return label
    }()
    
    lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.numberOfLines = 0
        return label
    }()
    
    lazy var dimentionTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 14, weight: .semibold)
        return label
    }()
    
    lazy var widthTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 14, weight: .regular)
        return label
    }()
    
    lazy var widthLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.textAlignment = .right
        return label
    }()
    
    lazy var heightTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 14, weight: .regular)
        return label
    }()
    
    lazy var heightLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.textAlignment = .right
        return label
    }()
    
    lazy var statisticsTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 14, weight: .semibold)
        return label
    }()
    
    lazy var viewsTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 14, weight: .regular)
        return label
    }()
    
    lazy var viewsLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.textAlignment = .right
        return label
    }()
    
    lazy var downloadsTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 14, weight: .regular)
        return label
    }()
    
    lazy var downloadsLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.textAlignment = .right
        return label
    }()
    
    lazy var topicsTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 14, weight: .semibold)
        return label
    }()
    
    lazy var topicsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .equalSpacing
        return stackView
    }()
    
}

private extension DetailViewController {
    func setupUI() {
        if #available(iOS 13.0, *) {
            self.overrideUserInterfaceStyle = .light
        }
        self.view.backgroundColor = .white
        self.navigationItem.largeTitleDisplayMode = .never
        
        // Add subviews
        
        self.view.addSubview(imageView)
        self.view.addSubview(profileImageView)
        self.view.addSubview(nameLabel)
        self.view.addSubview(likeIcon)
        self.view.addSubview(numberOfLikes)
        self.view.addSubview(descriptionTitleLabel)
        self.view.addSubview(descriptionLabel)
        self.view.addSubview(dimentionTitleLabel)
        self.view.addSubview(heightTitleLabel)
        self.view.addSubview(heightLabel)
        self.view.addSubview(widthTitleLabel)
        self.view.addSubview(widthLabel)
        self.view.addSubview(statisticsTitleLabel)
        self.view.addSubview(viewsTitleLabel)
        self.view.addSubview(viewsLabel)
        self.view.addSubview(downloadsTitleLabel)
        self.view.addSubview(downloadsLabel)
        self.view.addSubview(topicsTitleLabel)
        self.view.addSubview(topicsStackView)
        
        // Setup constraints with SnapKit
        
        imageView.snp.makeConstraints { (make) in
            make.left.equalTo(self.view).offset(15)
            make.top.equalTo(self.view).offset(15)
            make.right.equalTo(self.view).offset(-15)
            make.height.equalTo(250)
        }
        
        profileImageView.snp.makeConstraints { (make) in
            make.left.equalTo(self.view).offset(15)
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
            make.right.equalTo(self.view).offset(-15)
            make.centerY.equalTo(profileImageView)
            make.height.equalTo(20)
        }
        
        likeIcon.snp.makeConstraints { (make) in
            make.right.equalTo(self.numberOfLikes.snp.left).offset(-8)
            make.centerY.equalTo(profileImageView)
            make.height.equalTo(20)
            make.width.equalTo(20)
        }
        
        descriptionTitleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self.view).offset(15)
            make.right.equalTo(self.view).offset(-15)
            make.top.equalTo(self.profileImageView.snp.bottom).offset(15)
        }
        
        descriptionLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self.view).offset(15)
            make.right.equalTo(self.view).offset(-15)
            make.top.equalTo(self.descriptionTitleLabel.snp.bottom).offset(8)
        }
        
        dimentionTitleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self.view).offset(15)
            make.right.equalTo(self.view).offset(-15)
            make.top.equalTo(self.descriptionLabel.snp.bottom).offset(15)
        }
        
        widthLabel.snp.makeConstraints { (make) in
            make.right.equalTo(self.view).offset(-15)
            make.top.equalTo(self.dimentionTitleLabel.snp.bottom).offset(8)
            make.width.equalTo(75)
        }
        
        widthTitleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self.view).offset(15)
            make.right.equalTo(self.widthLabel.snp.left).offset(-8)
            make.top.equalTo(self.dimentionTitleLabel.snp.bottom).offset(8)
        }
        
        heightLabel.snp.makeConstraints { (make) in
            make.right.equalTo(self.view).offset(-15)
            make.top.equalTo(self.widthLabel.snp.bottom).offset(8)
            make.width.equalTo(75)
        }
        
        heightTitleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self.view).offset(15)
            make.right.equalTo(self.heightLabel.snp.left).offset(-8)
            make.top.equalTo(self.widthTitleLabel.snp.bottom).offset(8)
        }
        
        statisticsTitleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self.view).offset(15)
            make.right.equalTo(self.view).offset(-15)
            make.top.equalTo(self.heightTitleLabel.snp.bottom).offset(15)
        }
        
        viewsLabel.snp.makeConstraints { (make) in
            make.right.equalTo(self.view).offset(-15)
            make.top.equalTo(self.statisticsTitleLabel.snp.bottom).offset(8)
            make.width.equalTo(75)
        }
        
        viewsTitleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self.view).offset(15)
            make.right.equalTo(self.viewsLabel.snp.left).offset(-8)
            make.top.equalTo(self.statisticsTitleLabel.snp.bottom).offset(8)
        }
        
        downloadsLabel.snp.makeConstraints { (make) in
            make.right.equalTo(self.view).offset(-15)
            make.top.equalTo(self.viewsLabel.snp.bottom).offset(8)
            make.width.equalTo(75)
        }
        
        downloadsTitleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self.view).offset(15)
            make.right.equalTo(self.viewsLabel.snp.left).offset(-8)
            make.top.equalTo(self.viewsTitleLabel.snp.bottom).offset(8)
        }
        
        topicsTitleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self.view).offset(15)
            make.right.equalTo(self.view).offset(-15)
            make.top.equalTo(self.downloadsTitleLabel.snp.bottom).offset(15)
        }
        
        topicsStackView.snp.makeConstraints { (make) in
            make.left.equalTo(self.view).offset(15)
            make.right.equalTo(self.view).offset(-15)
            make.top.equalTo(self.topicsTitleLabel.snp.bottom).offset(8)
        }
    }
    
    func bindViewModelInputs() {
        self.ready
            .bind(to: self.viewModel.input.ready)
            .disposed(by: rx.disposeBag)
    }
    
    func bindViewModelOutputs() {
        self.viewModel.output.result
            .drive(onNext: { [weak self] data in
                guard let data = data,
                      let disposeBag = self?.rx.disposeBag else { return }
                
                self?.imageView.image = nil
                self?.imageView.backgroundColor = UIColor(hexString: data.color)
                self?.nameLabel.text = data.name
                self?.numberOfLikes.text = "\(data.likes)"
                let likeIconName = data.isLikedByUser ? "heart.fill" : "heart"
                self?.likeIcon.image = UIImage(systemName: likeIconName)
                
                self?.descriptionTitleLabel.text = "DESCRIPTION"
                self?.descriptionLabel.text = data.description?.capitalized ?? "No description"
                
                self?.dimentionTitleLabel.text = "DIMENTIONS"
                self?.widthTitleLabel.text = "Width"
                self?.widthLabel.text = "\(data.width) px"
                self?.heightTitleLabel.text = "Height"
                self?.heightLabel.text = "\(data.height) px"
                
                self?.statisticsTitleLabel.text = "STATISTICS"
                self?.viewsTitleLabel.text = "Views"
                self?.viewsLabel.text = "\(data.views)"
                self?.downloadsTitleLabel.text = "Downloads"
                self?.downloadsLabel.text = "\(data.downloads)"
                
                self?.topicsTitleLabel.text = "TOPICS"
                
                for topic in data.topics {
                    let label = UILabel()
                    label.text = topic
                    label.numberOfLines = 0
                    label.font = .systemFont(ofSize: 14, weight: .regular)
                    self?.topicsStackView.addArrangedSubview(label)
                }
                
                if data.topics.count == 0 {
                    let label = UILabel()
                    label.text = "No topics"
                    label.font = .systemFont(ofSize: 14, weight: .regular)
                    self?.topicsStackView.addArrangedSubview(label)
                }
                
                let pipeline = ImagePipeline.shared
                let mainImageURL = URL(string: data.mainImageURL)!
                let profileImageURL = URL(string: data.profileImageURL)!
                
                let cacheRequest = URLRequest(url: mainImageURL, cachePolicy: .returnCacheDataDontLoad)
                let networkRequest = URLRequest(url: mainImageURL, cachePolicy: .useProtocolCachePolicy)
                
                Observable.concat(pipeline.rx.loadImage(with: ImageRequest(urlRequest: cacheRequest)).orEmpty,
                                  pipeline.rx.loadImage(with: ImageRequest(urlRequest: networkRequest)).orEmpty)
                    .take(1)
                    .subscribe(onNext: { self?.imageView.image = $0.image })
                    .disposed(by: disposeBag)
                
                pipeline.rx.loadImage(with: profileImageURL)
                    .subscribe(onSuccess: { self?.profileImageView.image = $0.image })
                    .disposed(by: disposeBag)
                
            })
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
