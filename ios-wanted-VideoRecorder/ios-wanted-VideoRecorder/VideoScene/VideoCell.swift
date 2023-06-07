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
        
        return imageView
    }()
    
    private var imageLabel: UILabel = {
        let label = UILabel()
        label.text = "3:21"
        label.backgroundColor = .black
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Nature.mp4"
        label.font = UIFont.preferredFont(forTextStyle: .title2)
        label.adjustsFontForContentSizeCategory = true
        
        return label
    }()
    
    private var dateLabel: UILabel = {
        let label = UILabel()
        label.text = "2022-09-22"
        label.font = UIFont.preferredFont(forTextStyle: .body)
        label.textColor = .systemGray6
        label.adjustsFontForContentSizeCategory = true
        
        return label
    }()
    
    private let informationStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 20
        
        return stackView
    }()
    
    private let moreButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "more"), for: .normal)
        
        return button
    }()
    
    private let contentStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        return stackView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureContentLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureContentLayout() {
        imageView.addSubview(imageLabel)
        
        NSLayoutConstraint.activate([
            imageLabel.bottomAnchor.constraint(equalTo: imageView.bottomAnchor, constant: -10),
            imageLabel.leadingAnchor.constraint(equalTo: imageView.leadingAnchor, constant: 10)
        ])
        
        informationStackView.addArrangedSubview(titleLabel)
        informationStackView.addArrangedSubview(dateLabel)
        
        contentStackView.addArrangedSubview(informationStackView)
        contentStackView.addArrangedSubview(moreButton)
        
        contentView.addSubview(imageView)
        contentView.addSubview(contentStackView)
        
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20),
            
            contentStackView.leadingAnchor.constraint(equalTo: imageView.leadingAnchor, constant: 10),
            contentStackView.topAnchor.constraint(equalTo: imageView.topAnchor, constant: 10),
            contentStackView.bottomAnchor.constraint(equalTo: imageView.bottomAnchor, constant: -10),
            contentStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10)
        ])
    }
}
