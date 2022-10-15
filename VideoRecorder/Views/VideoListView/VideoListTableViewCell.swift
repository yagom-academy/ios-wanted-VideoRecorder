//
//  VideoListTableViewCell.swift
//  VideoRecorder
//
//  Created by KangMingyo on 2022/10/11.
//

import UIKit

class VideoListTableViewCell: UITableViewCell {
    
    let thumbnailView: UIView = {
        let view = UIView()
        view.layer.shadowOffset = CGSize(width: 5, height: 5)
        view.layer.shadowOpacity = 0.7
        view.layer.shadowRadius = 5
        view.layer.shadowColor = UIColor.gray.cgColor
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let thumbnailImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 15
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let timelabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .systemFont(ofSize: 12)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    let videoNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .bold)
        return label
    }()
    
    let dateLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13)
        label.textColor = .gray
        return label
    }()
    
    let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 15
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        [videoNameLabel, dateLabel].forEach {
            self.stackView.addArrangedSubview($0)
        }
        addView()
        configure()
    }
    
     required init?(coder: NSCoder) {
         fatalError("init(coder:) has not been implemented")
     }
    
    func addView() {
        addSubview(thumbnailView)
        thumbnailView.addSubview(thumbnailImageView)
        thumbnailView.addSubview(timelabel)
        addSubview(stackView)
    }
    
    func configure() {
        
        NSLayoutConstraint.activate([
            
            thumbnailView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            thumbnailImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            thumbnailImageView.widthAnchor.constraint(equalToConstant: 80),
            thumbnailImageView.heightAnchor.constraint(equalToConstant: 60),
            
            thumbnailImageView.leadingAnchor.constraint(equalTo: thumbnailView.leadingAnchor, constant: 20),
            thumbnailImageView.centerYAnchor.constraint(equalTo: thumbnailView.centerYAnchor),
            thumbnailImageView.widthAnchor.constraint(equalToConstant: 80),
            thumbnailImageView.heightAnchor.constraint(equalToConstant: 60),
            
            timelabel.leadingAnchor.constraint(equalTo: thumbnailView.leadingAnchor, constant: 30),
            timelabel.topAnchor.constraint(equalTo: thumbnailView.topAnchor, constant: 10),
            
            stackView.centerYAnchor.constraint(equalTo: centerYAnchor),
            stackView.leadingAnchor.constraint(equalTo: thumbnailImageView.trailingAnchor, constant: 20)
        ])
    }
}
