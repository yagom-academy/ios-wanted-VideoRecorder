//
//  VideoListCell.swift
//  VideoRecorder
//
//  Created by kokkilE on 2023/06/06.
//

import UIKit
import Combine

final class VideoListCell: UICollectionViewCell {
    private let thumbnailView = {
        let view = UIView()
        
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 8
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOffset = CGSize(width: 3, height: 3)
        view.layer.shadowOpacity = 0.6
        view.layer.shadowRadius = 1
        
        return view
    }()
    
    private let thumbnailImageView = {
        let imageView = UIImageView()
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 8
        imageView.layer.masksToBounds = true
        
        return imageView
    }()
    
    private let thumbnailTimeLabelStackView = {
        let stackView = UIStackView()
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.backgroundColor = .black.withAlphaComponent(0.6)
        stackView.layer.cornerRadius = 4
        stackView.layer.masksToBounds = true
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.layoutMargins = UIEdgeInsets(top: 2, left: 4, bottom: 2, right: 4)
        
        return stackView
    }()
    
    private let thumbnailTimeLabel = {
        let label = UILabel()
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .preferredFont(forTextStyle: .caption1)
        label.textColor = .white
        
        return label
    }()
    
    private let titleLabel = {
        let label = UILabel()
        
        label.font = .preferredFont(forTextStyle: .title2)
        label.setContentHuggingPriority(.defaultLow, for: .vertical)
        
        return label
    }()
    
    private let dateLabel = {
        let label = UILabel()
        
        label.font = .preferredFont(forTextStyle: .body)
        label.textColor = .systemGray
        label.setContentHuggingPriority(.defaultHigh, for: .vertical)
        
        return label
    }()
    
    private let labelStackView = {
        let stackView = UIStackView()
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.distribution = .fillEqually
        stackView.spacing = 0
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.layoutMargins = UIEdgeInsets(top: 4, left: 20, bottom: 4, right: 20)
        
        return stackView
    }()
    
    private let mainStackView = {
        let stackView = UIStackView()
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.layoutMargins = UIEdgeInsets(top: 8, left: 4, bottom: 8, right: 4)
        
        return stackView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupCell()
        addSubviews()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(title: String, date: Date) {
        titleLabel.text = title
        dateLabel.text = DateFormatter.dateToText(date)
    }
    
    func configureThumbnail(image: UIImage) {
        thumbnailImageView.image = image
    }
    
    func configureThumbnail(timeText: String) {
        thumbnailTimeLabel.text = timeText
    }
    
    private func setupCell() {
        backgroundColor = .systemBackground
    }
    
    private func addSubviews() {
        labelStackView.addArrangedSubview(titleLabel)
        labelStackView.addArrangedSubview(dateLabel)
        
        thumbnailTimeLabelStackView.addArrangedSubview(thumbnailTimeLabel)
        thumbnailView.addSubview(thumbnailImageView)
        thumbnailView.addSubview(thumbnailTimeLabelStackView)
        
        mainStackView.addArrangedSubview(thumbnailView)
        mainStackView.addArrangedSubview(labelStackView)
        
        addSubview(mainStackView)
    }
    
    private func layout() {
        let safe = safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            mainStackView.topAnchor.constraint(equalTo: safe.topAnchor, constant: 4),
            mainStackView.leadingAnchor.constraint(equalTo: safe.leadingAnchor, constant: 4),
            mainStackView.trailingAnchor.constraint(equalTo: safe.trailingAnchor, constant: -4),
            mainStackView.bottomAnchor.constraint(equalTo: safe.bottomAnchor, constant: -4),
            
            thumbnailImageView.topAnchor.constraint(equalTo: thumbnailView.topAnchor),
            thumbnailImageView.leadingAnchor.constraint(equalTo: thumbnailView.leadingAnchor),
            thumbnailImageView.trailingAnchor.constraint(equalTo: thumbnailView.trailingAnchor),
            thumbnailImageView.bottomAnchor.constraint(equalTo: thumbnailView.bottomAnchor),
            
            thumbnailTimeLabelStackView.leadingAnchor.constraint(equalTo: thumbnailView.leadingAnchor, constant: 4),
            thumbnailTimeLabelStackView.bottomAnchor.constraint(equalTo: thumbnailView.bottomAnchor, constant: -4),
            
            thumbnailView.widthAnchor.constraint(equalTo: mainStackView.widthAnchor, multiplier: 0.25),
            thumbnailView.heightAnchor.constraint(equalTo: mainStackView.widthAnchor, multiplier: 0.18)
        ])
    }
}
