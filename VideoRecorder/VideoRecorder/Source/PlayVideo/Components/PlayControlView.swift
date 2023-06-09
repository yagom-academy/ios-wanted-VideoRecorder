//
//  PlayControlView.swift
//  VideoRecorder
//
//  Created by kokkilE on 2023/06/09.
//

import UIKit

class PlayControlView: UIStackView {
    private var isPlaying: Bool = true
    
    private let backwardButton = {
        let button = UIButton()
                
        let imageConfiguration = UIImage.SymbolConfiguration(pointSize: 40)
        let recordImage = UIImage(systemName: "backward.end.fill", withConfiguration: imageConfiguration)
        button.setImage(recordImage, for: .normal)
        button.tintColor = .white
        
        return button
    }()
    
    private lazy var playOrStopButton = {
        let button = UIButton()
                
        let imageConfiguration = UIImage.SymbolConfiguration(pointSize: 60)
        let recordImage = UIImage(systemName: "pause.fill", withConfiguration: imageConfiguration)
        button.setImage(recordImage, for: .normal)
        button.tintColor = .white
        
        return button
    }()
    
    private let shareButton = {
        let button = UIButton()
                
        let imageConfiguration = UIImage.SymbolConfiguration(pointSize: 40)
        let rotateImage = UIImage(systemName: "square.and.arrow.up", withConfiguration: imageConfiguration)
        button.setImage(rotateImage, for: .normal)
        button.tintColor = .white
        
        return button
    }()
        
    init() {
        super.init(frame: .zero)
        
        addSubviews()
        setupView()
        addButtonActions()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addSubviews() {
        addArrangedSubview(backwardButton)
        addArrangedSubview(playOrStopButton)
        addArrangedSubview(shareButton)
    }
    
    private func setupView() {
        translatesAutoresizingMaskIntoConstraints = false
        
        distribution = .fillEqually
        axis = .horizontal
        spacing = 12
        layoutMargins = UIEdgeInsets(top: 20, left: 10, bottom: 20, right: 10)
        isLayoutMarginsRelativeArrangement = true
        layer.cornerRadius = 20
        backgroundColor = .black.withAlphaComponent(0.4)
    }
    
    private func addButtonActions() {
        backwardButton.addTarget(self, action: #selector(touchUpBackwardButton), for: .touchUpInside)
        playOrStopButton.addTarget(self, action: #selector(touchUpPlayOrStopButton), for: .touchUpInside)
        shareButton.addTarget(self, action: #selector(touchUpShareButton), for: .touchUpInside)
    }
    
    @objc private func touchUpBackwardButton() {

    }
    
    @objc private func touchUpPlayOrStopButton() {
        isPlaying.toggle()
        configurePlayOrStopButtonImage()
    }
    
    @objc private func touchUpShareButton() {

    }
    
    private func configurePlayOrStopButtonImage() {
        let imageConfiguration = UIImage.SymbolConfiguration(pointSize: 60)
        
        if isPlaying {
            let recordImage = UIImage(systemName: "play.fill", withConfiguration: imageConfiguration)
            playOrStopButton.setImage(recordImage, for: .normal)
        } else {
            let recordImage = UIImage(systemName: "pause.fill", withConfiguration: imageConfiguration)
            playOrStopButton.setImage(recordImage, for: .normal)
        }
        
        playOrStopButton.tintColor = .white
    }
}
