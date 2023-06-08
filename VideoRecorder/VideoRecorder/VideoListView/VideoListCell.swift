//
//  VideoListCell.swift
//  VideoRecorder
//
//  Created by Rowan on 2023/06/08.
//

import UIKit

final class VideoListCell: UITableViewCell {
    static let identifier = "VideoListCell"
    
    let titleLabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .title2)
        label.textColor = .black
        label.adjustsFontForContentSizeCategory = true
        
        return label
    }()
    
    let dateLabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .body)
        label.textColor = .systemGray4
        label.adjustsFontForContentSizeCategory = true
        
        return label
    }()
    
    let thumbnailView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 10
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    
    let shadowView = {
        let view = UIView()
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOffset = CGSize(width: 2, height: 4)
        view.layer.shadowOpacity = 0.3
        view.layer.shadowRadius = 1.0
        
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = .white
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        thumbnailView.image = nil
        titleLabel.text = nil
        dateLabel.text = nil
    }
    
    private func configureLayout() {
        let textStackView = UIStackView(arrangedSubviews: [titleLabel, dateLabel])
        textStackView.axis = .vertical
        textStackView.distribution = .fillProportionally
        textStackView.alignment = .leading
        textStackView.spacing = 10
        
        shadowView.addSubview(thumbnailView)
        
        let contentStackView = UIStackView(arrangedSubviews: [shadowView, textStackView])
        contentStackView.axis = .horizontal
        contentStackView.distribution = .fill
        contentStackView.alignment = .center
        contentStackView.spacing = 10
        contentStackView.translatesAutoresizingMaskIntoConstraints = false

        contentView.addSubview(contentStackView)
        
        NSLayoutConstraint.activate([
            contentStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            contentStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            contentStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 18),
            contentStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -18),
            
            thumbnailView.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.25),
            thumbnailView.heightAnchor.constraint(equalTo: thumbnailView.widthAnchor, multiplier: 0.75),
            thumbnailView.topAnchor.constraint(equalTo: shadowView.topAnchor),
            thumbnailView.bottomAnchor.constraint(equalTo: shadowView.bottomAnchor),
            thumbnailView.leadingAnchor.constraint(equalTo: shadowView.leadingAnchor),
            thumbnailView.trailingAnchor.constraint(equalTo: shadowView.trailingAnchor)
        ])
    }
}
