//
//  VideoDescriptionCell.swift
//  VideoRecorder
//
//  Created by kokkilE on 2023/06/06.
//

import UIKit

final class VideoDescriptionCell: UICollectionViewCell {
    private let titleLabel = {
        let label = UILabel()
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .preferredFont(forTextStyle: .largeTitle)
        label.setContentHuggingPriority(.defaultLow, for: .vertical)
        
        return label
    }()
    
    private let dateLabel = {
        let label = UILabel()
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .preferredFont(forTextStyle: .title1)
        label.textColor = .systemGray
        label.setContentHuggingPriority(.defaultHigh, for: .vertical)
        
        return label
    }()
    
    private let labelStackView = {
        let stackView = UIStackView()
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.distribution = .equalSpacing
        
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
    
    func configure(title: String, date: String) {
        titleLabel.text = title
        dateLabel.text = date
    }
    
    private func setupCell() {
        backgroundColor = .systemBackground
    }
    
    private func addSubviews() {
        labelStackView.addArrangedSubview(UIView())
        labelStackView.addArrangedSubview(titleLabel)
        labelStackView.addArrangedSubview(dateLabel)
        labelStackView.addArrangedSubview(UIView())
        
        mainStackView.addArrangedSubview(labelStackView)
        
        addSubview(mainStackView)
    }
    
    private func layout() {
        let safe = safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            mainStackView.topAnchor.constraint(equalTo: safe.topAnchor, constant: 4),
            mainStackView.leadingAnchor.constraint(equalTo: safe.leadingAnchor, constant: 4),
            mainStackView.trailingAnchor.constraint(equalTo: safe.trailingAnchor, constant: -4),
            mainStackView.bottomAnchor.constraint(equalTo: safe.bottomAnchor, constant: -4)
        ])
    }
}
