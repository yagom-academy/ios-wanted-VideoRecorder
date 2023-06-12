//
//  VideoListCellAccessoryView.swift
//  VideoRecorder
//
//  Created by Rowan on 2023/06/09.
//

import UIKit

final class VideoListCellAccessoryView: UIStackView {
    private let leftImageView = {
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        let imageConfiguration = UIImage.SymbolConfiguration(weight: .bold)
        imageView.image = UIImage(systemName: "ellipsis", withConfiguration: imageConfiguration)
        imageView.tintColor = .systemGray
        imageView.contentMode = .scaleAspectFit
        imageView.layer.shadowOffset = CGSize(width: 2, height: 2.5)
        imageView.layer.shadowColor = UIColor.black.cgColor
        imageView.layer.shadowOpacity = 0.2
        imageView.layer.shadowRadius = 0.1
        
        return imageView
    }()
    
    private let rightImageView = {
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        let imageConfiguration = UIImage.SymbolConfiguration(weight: .bold)
        imageView.image = UIImage(systemName: "chevron.right", withConfiguration: imageConfiguration)
        imageView.tintColor = .systemGray
        imageView.contentMode = .scaleAspectFit
        imageView.layer.shadowOffset = CGSize(width: 1.5, height: 2)
        imageView.layer.shadowColor = UIColor.black.cgColor
        imageView.layer.shadowOpacity = 0.2
        imageView.layer.shadowRadius = 0.1
        
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureSubviews()
        configureProperties()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureSubviews() {
        self.addArrangedSubview(leftImageView)
        self.addArrangedSubview(rightImageView)
    }
    
    private func configureProperties() {
        self.axis = .horizontal
        self.alignment = .center
        self.distribution = .fillProportionally
        self.spacing = 10
    }
}
