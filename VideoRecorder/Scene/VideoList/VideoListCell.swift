//
//  VideoCell.swift
//  VideoRecorder
//
//  Created by 권준상 on 2022/10/11.
//

import UIKit

final class VideoListCell: UITableViewCell {
    
    let thumbnailImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleToFill
        imageView.image = UIImage(named: "sample")
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 6
        return imageView
    }()
    
    let runningTimeView: UIView = {
        let view = UIView()
        view.backgroundColor = Color.opacityBlack
        view.layer.zPosition = 1
        return view
    }()
    
    let runningTimeLabel: UILabel = {
        let label = UILabel()
        label.textColor = Color.white
        label.font = Font.caption2
        label.adjustsFontForContentSizeCategory = true
        label.translatesAutoresizingMaskIntoConstraints = false
        label.layer.zPosition = 2
        return label
    }()
    
    let labelStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.alignment = .leading
        stackView.spacing = 7
        return stackView
    }()
    
    let videoNameLabel: UILabel = {
        let label = UILabel()
        label.textColor = Color.label
        label.font = Font.headline
        label.adjustsFontForContentSizeCategory = true
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let dateLabel: UILabel = {
        let label = UILabel()
        label.textColor = Color.darkGray
        label.font = Font.caption2
        label.adjustsFontForContentSizeCategory = true 
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let nextImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "chevron.right")
        imageView.tintColor = Color.darkGray
        return imageView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = .white
        contentView.addSubviews(thumbnailImageView, labelStackView, nextImageView)
        thumbnailImageView.addSubview(runningTimeView)
        runningTimeView.addSubview(runningTimeLabel)
        labelStackView.addArrangedSubview(videoNameLabel)
        labelStackView.addArrangedSubview(dateLabel)
        [thumbnailImageView, labelStackView, nextImageView, runningTimeView, runningTimeLabel].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        NSLayoutConstraint.activate([
            thumbnailImageView.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.25),
            thumbnailImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            thumbnailImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            thumbnailImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20),
            
            runningTimeView.leadingAnchor.constraint(equalTo: thumbnailImageView.leadingAnchor, constant: 5),
            runningTimeView.bottomAnchor.constraint(equalTo: thumbnailImageView.bottomAnchor, constant: -5),
            runningTimeLabel.leadingAnchor.constraint(equalTo: runningTimeView.leadingAnchor, constant: 5),
            runningTimeLabel.topAnchor.constraint(equalTo: runningTimeView.topAnchor, constant: 3),
            runningTimeLabel.trailingAnchor.constraint(equalTo: runningTimeView.trailingAnchor, constant: -5),
            runningTimeLabel.bottomAnchor.constraint(equalTo: runningTimeView.bottomAnchor, constant: -3),
            
            labelStackView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            labelStackView.leadingAnchor.constraint(equalTo: thumbnailImageView.trailingAnchor, constant: 20),
            labelStackView.trailingAnchor.constraint(equalTo: nextImageView.leadingAnchor, constant: -10),
            
            nextImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            nextImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -30),
            nextImageView.widthAnchor.constraint(equalToConstant: 15),
            nextImageView.heightAnchor.constraint(equalToConstant: 20)
        ])
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
