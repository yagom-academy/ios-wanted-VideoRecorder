//
//  VideoControllerView.swift
//  VideoRecorder
//
//  Created by Rowan on 2023/06/09.
//

import UIKit

final class VideoControllerView: UIView {
    let slider: UISlider = {
        let slider = UISlider()
        
        return slider
    }()
    let backwardButton: UIButton = {
        let button = UIButton()
        let image = UIImage(systemName: "backward.end.fill")
        button.setImage(image, for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.setContentHuggingPriority(.required, for: .horizontal)
        button.tintColor = .white
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    let playButton: UIButton = {
        let button = UIButton()
        let image = UIImage(systemName: "play.fill")
        button.setImage(image, for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.setContentHuggingPriority(.required, for: .horizontal)
        button.tintColor = .white
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    let shareButton: UIButton = {
        let button = UIButton()
        let image = UIImage(systemName: "square.and.arrow.up")
        button.setImage(image, for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.setContentHuggingPriority(.required, for: .horizontal)
        button.tintColor = .white
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    private let buttonStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .equalSpacing
        stackView.alignment = .center
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        return stackView
    }()
    let currentTimeLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .callout)
        label.textColor = .white
        
        return label
    }()
    let runtimeLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .callout)
        label.textColor = .white
        
        return label
    }()
    private let timeLabelStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
        stackView.alignment = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        return stackView
    }()
    private let controllerStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fillProportionally
        stackView.alignment = .fill
        stackView.spacing = 5
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        return stackView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViewHierarchy()
        setupLayoutConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViewHierarchy() {
        buttonStackView.addArrangedSubview(backwardButton)
        buttonStackView.addArrangedSubview(playButton)
        buttonStackView.addArrangedSubview(shareButton)

        timeLabelStackView.addArrangedSubview(currentTimeLabel)
        timeLabelStackView.addArrangedSubview(runtimeLabel)
        
        controllerStackView.addArrangedSubview(slider)
        controllerStackView.addArrangedSubview(timeLabelStackView)
        controllerStackView.addArrangedSubview(buttonStackView)
        
        self.addSubview(controllerStackView)
    }
    
    private func setupLayoutConstraints() {
        NSLayoutConstraint.activate([
            backwardButton.widthAnchor.constraint(equalTo: buttonStackView.widthAnchor, multiplier: 0.1),
            backwardButton.heightAnchor.constraint(equalTo: backwardButton.widthAnchor),
            
            playButton.widthAnchor.constraint(equalTo: buttonStackView.widthAnchor, multiplier: 0.2),
            playButton.heightAnchor.constraint(equalTo: playButton.widthAnchor),
            
            shareButton.widthAnchor.constraint(equalTo: buttonStackView.widthAnchor, multiplier: 0.1),
            shareButton.heightAnchor.constraint(equalTo: shareButton.widthAnchor),
            
            buttonStackView.widthAnchor.constraint(equalTo: slider.widthAnchor),
            timeLabelStackView.widthAnchor.constraint(equalTo: slider.widthAnchor),
            
            controllerStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 18),
            controllerStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -18),
            controllerStackView.topAnchor.constraint(equalTo: self.topAnchor, constant: 18),
            controllerStackView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -18)
        ])
    }
}
