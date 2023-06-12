//
//  VideoListCell.swift
//  VideoRecoder
//
//  Created by kimseongjun on 2023/06/05.
//

import UIKit

class VideoListCell: UITableViewCell {
    private let standardPadding: CGFloat = 20
    
    private let labelStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        return stackView
    }()
    
    private let videoThumbnailView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .title2)
        
        return label
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .caption1)
        label.textColor = .systemGray3
        
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI() {
        contentView.addSubview(videoThumbnailView)
        contentView.addSubview(labelStackView)
        labelStackView.addArrangedSubview(titleLabel)
        labelStackView.addArrangedSubview(dateLabel)
        
        NSLayoutConstraint.activate([
            videoThumbnailView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: standardPadding),
            videoThumbnailView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: standardPadding),
            videoThumbnailView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -standardPadding),
            
            labelStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: standardPadding),
            labelStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: standardPadding),
            labelStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -standardPadding),
            labelStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -standardPadding)
        ])
    }
    
    func configureCell(video: Video) {
        titleLabel.text = video.title
        dateLabel.text = video.date
    }
}
