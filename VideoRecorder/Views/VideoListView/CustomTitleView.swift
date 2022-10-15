//
//  CustomTitleView.swift
//  VideoRecorder
//
//  Created by KangMingyo on 2022/10/11.
//

import UIKit

class CustomTitleView: UIView {
    
    let indexImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "list.bullet")
        imageView.tintColor = .black
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let VideoListLabel: UILabel = {
        let label = UILabel()
        label.text = "Video List"
        label.font = .systemFont(ofSize: 18, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let recodeButton: UIButton = {
        let button = UIButton(type: UIButton.ButtonType.system)
        button.setImage(UIImage(systemName: "video.fill.badge.plus"), for: .normal)
        button.tintColor = .systemIndigo
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = .clear
        
        addView()
        configure()
    }
    
    required init?(coder NSCoder : NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addView() {
        addSubview(indexImageView)
        addSubview(VideoListLabel)
        addSubview(recodeButton)
    }
    
    func configure() {
        NSLayoutConstraint.activate([
            indexImageView.topAnchor.constraint(equalTo: topAnchor, constant: 70),
            indexImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            
            VideoListLabel.topAnchor.constraint(equalTo: topAnchor, constant: 70),
            VideoListLabel.leadingAnchor.constraint(equalTo: indexImageView.trailingAnchor, constant: 10),
            
            recodeButton.topAnchor.constraint(equalTo: topAnchor, constant: 70),
            recodeButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20)
        ])
    }
}
