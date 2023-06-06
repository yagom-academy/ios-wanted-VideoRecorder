//
//  VideoCell.swift
//  VideoRecorder
//
//  Created by kokkilE on 2023/06/06.
//

import UIKit

final class VideoCell: UICollectionViewCell {
    private let videoImageView = {
        let imageView = UIImageView()
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    
    init() {
        super.init(frame: .zero)
        
        addSubviews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(image: UIImage) {
        videoImageView.image = image
    }
    
    private func addSubviews() {
        addSubview(videoImageView)
    }
    
    private func setupConstraints() {
        let safe = safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            videoImageView.topAnchor.constraint(equalTo: safe.topAnchor, constant: 4),
            videoImageView.leadingAnchor.constraint(equalTo: safe.leadingAnchor, constant: 4),
            videoImageView.trailingAnchor.constraint(equalTo: safe.trailingAnchor, constant: 4),
            videoImageView.bottomAnchor.constraint(equalTo: safe.bottomAnchor, constant: 4)
        ])
    }
}
