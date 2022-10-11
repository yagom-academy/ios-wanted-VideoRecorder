//
//  VideoCell.swift
//  VideoRecorder
//
//  Created by 권준상 on 2022/10/11.
//

import UIKit

class VideoListCell: UICollectionViewCell {
    
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
        view.backgroundColor = .black
        view.layer.opacity = 0.6
        view.layer.zPosition = 1
        return view
    }()
    
    let runningTimeLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .systemFont(ofSize: 11)
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
        label.textColor = .black
        label.font = .systemFont(ofSize: 15, weight: .bold)
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let dateLabel: UILabel = {
        let label = UILabel()
        label.textColor = .darkGray
        label.font = .systemFont(ofSize: 13)
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let nextImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "chevron.right")
        imageView.tintColor = .gray
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
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
            thumbnailImageView.widthAnchor.constraint(equalToConstant: 80),
            thumbnailImageView.heightAnchor.constraint(equalTo: thumbnailImageView.widthAnchor, multiplier: 0.66),
            thumbnailImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            thumbnailImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            runningTimeView.leadingAnchor.constraint(equalTo: thumbnailImageView.leadingAnchor, constant: 5),
            runningTimeView.bottomAnchor.constraint(equalTo: thumbnailImageView.bottomAnchor, constant: -5),
            runningTimeLabel.leadingAnchor.constraint(equalTo: runningTimeView.leadingAnchor, constant: 5),
            runningTimeLabel.topAnchor.constraint(equalTo: runningTimeView.topAnchor, constant: 3),
            runningTimeLabel.trailingAnchor.constraint(equalTo: runningTimeView.trailingAnchor, constant: -5),
            runningTimeLabel.bottomAnchor.constraint(equalTo: runningTimeView.bottomAnchor, constant: -3),
            labelStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 15),
            labelStackView.leadingAnchor.constraint(equalTo: thumbnailImageView.trailingAnchor, constant: 20),
            labelStackView.trailingAnchor.constraint(equalTo: nextImageView.leadingAnchor, constant: -10),
            labelStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -15),
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

extension UIView {
    func addSubviews(_ views: UIView...) {
        views.forEach { addSubview($0) }
    }
}
