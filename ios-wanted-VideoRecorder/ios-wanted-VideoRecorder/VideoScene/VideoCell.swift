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
        imageView.layer.cornerRadius = 10
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    
    private var imageLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 12)
        label.textColor = .white
        label.backgroundColor = .black.withAlphaComponent(0.5)
        label.layer.cornerRadius = 4
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
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
        label.font = UIFont.preferredFont(forTextStyle: .caption1)
        label.textColor = .systemGray
        label.adjustsFontForContentSizeCategory = true
        
        
        return label
    }()
    
    private let informationStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 10
        
        return stackView
    }()
    
    private let moreButton: UIButton = {
        let button = UIButton()
        let config = UIImage.SymbolConfiguration(pointSize: 20, weight: .bold, scale: .default)
        button.setImage(UIImage(systemName: "ellipsis", withConfiguration: config), for: .normal)
        button.tintColor = .systemGray
        button.layer.shadowOpacity = 0.2
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOffset = CGSize(width: 2, height: 4)
        button.layer.shadowRadius = 1
        button.contentHorizontalAlignment = .trailing
        
        return button
    }()
    
    private let contentStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .fill
        stackView.spacing = 15
        stackView.layoutMargins = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        stackView.isLayoutMarginsRelativeArrangement = true
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
    
    func provide(_ video: VideoEntity, _ dateFormatter: DateFormatter) {
        titleLabel.text = video.name
        dateLabel.text = dateFormatter.string(from: video.date)
        imageLabel.text = video.duration
        
        DispatchQueue.global().async {
            let image = ImageFileManager.shared.loadImageFromDocumentsDirectory(fileName: video.thumbnail)
            
            DispatchQueue.main.async {
                self.imageView.image = image
            }
        }
    }
    
    private func configureContentLayout() {
        informationStackView.addArrangedSubview(titleLabel)
        informationStackView.addArrangedSubview(dateLabel)
        
        imageView.addSubview(imageLabel)
        
        contentStackView.addArrangedSubview(imageView)
        contentStackView.addArrangedSubview(informationStackView)
        contentStackView.addArrangedSubview(moreButton)
        
        contentView.addSubview(contentStackView)
        
        NSLayoutConstraint.activate([
            contentStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            contentStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            contentStackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            contentStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            imageView.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.25),
            imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor, multiplier: 0.8),
            
            imageLabel.leadingAnchor.constraint(equalTo: imageView.leadingAnchor, constant: 5),
            imageLabel.bottomAnchor.constraint(equalTo: imageView.bottomAnchor, constant: -5),
        ])
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.titleLabel.text = ""
        self.dateLabel.text = ""
        self.imageLabel.text = ""
        self.imageView.image = nil
    }
}
