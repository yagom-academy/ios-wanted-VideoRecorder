//
//  VideoCell.swift
//  ios-wanted-VideoRecorder
//
//  Created by brody on 2023/06/07.
//

import UIKit

final class VideoCell: UICollectionViewListCell {
    private var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "mockImage")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 10
        imageView.clipsToBounds = true
        
        return imageView
    }()
    
    private var imageLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 12)
        label.text = "3:21"
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private var imageLabelView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        view.layer.cornerRadius = 4
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private var imageContainerView: UIView = {
        let view = UIView()
        view.layer.shadowOpacity = 0.1
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOffset = CGSize(width: 3, height: 3)
        view.layer.shadowRadius = 1
        
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Nature.mp4"
        label.textColor = .black
        label.font = UIFont.preferredFont(forTextStyle: .title2)
        label.adjustsFontForContentSizeCategory = true
        
        return label
    }()
    
    private var dateLabel: UILabel = {
        let label = UILabel()
        label.text = "2022-09-22"
        label.font = UIFont.preferredFont(forTextStyle: .body)
        label.textColor = .systemGray
        label.adjustsFontForContentSizeCategory = true
        
        return label
    }()
    
    private let informationStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        
        return stackView
    }()
    
    private let moreButton: UIButton = {
        let button = UIButton()
        let largeConfig = UIImage.SymbolConfiguration(pointSize: 20, weight: .bold, scale: .default)
        button.setImage(UIImage(systemName: "ellipsis", withConfiguration: largeConfig), for: .normal)
        button.tintColor = .systemGray
        button.layer.shadowOpacity = 0.2
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOffset = CGSize(width: 2, height: 4)
        button.layer.shadowRadius = 1
        
        return button
    }()
    
    private let contentStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        return stackView
    }()
    
    static let identifier = "cell"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureContentLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func provide(_ video: Video) {
        titleLabel.text = video.name
        dateLabel.text = video.date.description
    }
    
    private func configureContentLayout() {
        contentView.addSubview(imageContainerView)
        
        NSLayoutConstraint.activate([
            imageContainerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            imageContainerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            imageContainerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20),
            imageContainerView.widthAnchor.constraint(equalToConstant: 90),
            imageContainerView.heightAnchor.constraint(equalToConstant: 70),
        ])
        
        imageLabelView.addSubview(imageLabel)
        
        imageContainerView.addSubview(imageView)
        imageContainerView.addSubview(imageLabelView)
        
        
        NSLayoutConstraint.activate([
            imageLabelView.leadingAnchor.constraint(equalTo: imageContainerView.leadingAnchor, constant: 5),
            imageLabelView.bottomAnchor.constraint(equalTo: imageContainerView.bottomAnchor, constant: -5),
            imageLabelView.widthAnchor.constraint(greaterThanOrEqualToConstant: 15),
            imageLabelView.heightAnchor.constraint(greaterThanOrEqualToConstant: 5),
            
            imageLabel.topAnchor.constraint(equalTo: imageLabelView.topAnchor, constant: 2),
            imageLabel.bottomAnchor.constraint(equalTo: imageLabelView.bottomAnchor, constant: -2),
            imageLabel.leadingAnchor.constraint(equalTo: imageLabelView.leadingAnchor, constant: 2),
            imageLabel.trailingAnchor.constraint(equalTo: imageLabelView.trailingAnchor, constant: -2),
            
            imageView.leadingAnchor.constraint(equalTo: imageContainerView.leadingAnchor),
            imageView.topAnchor.constraint(equalTo: imageContainerView.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: imageContainerView.bottomAnchor),
            imageView.widthAnchor.constraint(equalTo: imageContainerView.widthAnchor),
            imageView.heightAnchor.constraint(equalTo: imageContainerView.heightAnchor)
        ])
        
        informationStackView.addArrangedSubview(titleLabel)
        informationStackView.addArrangedSubview(dateLabel)
        
        contentStackView.addArrangedSubview(informationStackView)
        contentStackView.addArrangedSubview(moreButton)
        
        contentView.addSubview(contentStackView)
        
        NSLayoutConstraint.activate([
            contentStackView.leadingAnchor.constraint(equalTo: imageContainerView.trailingAnchor, constant: 10),
            contentStackView.topAnchor.constraint(equalTo: imageContainerView.topAnchor),
            contentStackView.bottomAnchor.constraint(equalTo: imageContainerView.bottomAnchor),
            contentStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10)
        ])
    }
}
