//
//  VideoListCell.swift
//  VideoRecorder
//
//  Created by kokkilE on 2023/06/06.
//

import UIKit
import Combine

final class VideoListCell: UICollectionViewCell {
    private let videoImageView = {
        let imageView = UIImageView()
                
        return imageView
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
        
        return stackView
    }()
    
    private let mainStackView = {
        let stackView = UIStackView()
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        
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
    
    private func setupCell() {
        backgroundColor = .systemBackground
    }
    
    private func addSubviews() {
        labelStackView.addArrangedSubview(UIView())
        labelStackView.addArrangedSubview(titleLabel)
        labelStackView.addArrangedSubview(UIView())
        labelStackView.addArrangedSubview(dateLabel)
        labelStackView.addArrangedSubview(UIView())
        
        mainStackView.addArrangedSubview(videoImageView)
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
            
            labelStackView.widthAnchor.constraint(equalTo: mainStackView.widthAnchor, multiplier: 0.70)
        ])
    }
}
