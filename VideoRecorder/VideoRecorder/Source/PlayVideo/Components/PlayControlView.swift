//
//  PlayControlView.swift
//  VideoRecorder
//
//  Created by kokkilE on 2023/06/09.
//

import UIKit
import Combine

class PlayControlView: UIStackView {
    private let slider: UISlider
    
    private let timeLabelStackView = {
        let stackView = UIStackView()
        
        stackView.axis = .horizontal
        stackView.distribution = .equalCentering
        
        return stackView
    }()
    
    private let currentTimeLabel = {
        let label = UILabel()
        
        label.font = .preferredFont(forTextStyle: .body)
        label.textColor = .white
        
        return label
    }()
    
    private let durationLabel = {
        let label = UILabel()
        
        label.font = .preferredFont(forTextStyle: .body)
        label.textColor = .white
        
        return label
    }()
    
    private let buttonStackView = {
        let stackView = UIStackView()
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.distribution = .fillEqually
        stackView.axis = .horizontal
        stackView.spacing = 12
        stackView.isLayoutMarginsRelativeArrangement = true
        
        stackView.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        return stackView
    }()
    
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
                
        let imageConfiguration = UIImage.SymbolConfiguration(pointSize: 50)
        let pauseImage = UIImage(systemName: "pause.fill", withConfiguration: imageConfiguration)
        button.setImage(pauseImage, for: .normal)
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
    
    private var isPlaying: Bool = true
    private let viewModel: PlayVideoViewModel
    private var subscriptions = Set<AnyCancellable>()
    
    init(viewModel: PlayVideoViewModel, slider: UISlider) {
        self.viewModel = viewModel
        self.slider = slider
        
        super.init(frame: .zero)
        
        addSubviews()
        setupView()
        addButtonActions()
        bind()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func bind() {
        viewModel.$currentTime
            .sink { [weak self] in
                self?.updateCurrentTimeLabel(currentTime: $0)
            }
            .store(in: &subscriptions)
        
        viewModel.$duration
            .sink { [weak self] in
                self?.updateDurationLabel(duration: $0)
            }
            .store(in: &subscriptions)
        
        viewModel.$isPlaying
            .sink { [weak self] isPlaying in
                self?.configurePlayOrStopButtonImage(isPlaying)
            }
            .store(in: &subscriptions)
    }
    
    private func updateCurrentTimeLabel(currentTime: String) {
        currentTimeLabel.text = currentTime
    }
    
    private func updateDurationLabel(duration: String) {
        durationLabel.text = duration
    }
    
    private func addSubviews() {
        timeLabelStackView.addArrangedSubview(currentTimeLabel)
        timeLabelStackView.addArrangedSubview(durationLabel)
        
        buttonStackView.addArrangedSubview(backwardButton)
        buttonStackView.addArrangedSubview(playOrStopButton)
        buttonStackView.addArrangedSubview(shareButton)
        
        addArrangedSubview(slider)
        addArrangedSubview(timeLabelStackView)
        addArrangedSubview(buttonStackView)
    }
    
    private func setupView() {
        translatesAutoresizingMaskIntoConstraints = false
        
        distribution = .fill
        axis = .vertical
        spacing = 12
        layoutMargins = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
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
        viewModel.isTouchUpBackwardButton.toggle()
    }
    
    @objc func touchUpPlayOrStopButton() {
        viewModel.isPlaying.toggle()
    }
    
    @objc private func touchUpShareButton() {
        viewModel.isTouchUpShareButton.toggle()
        
        viewModel.isPlaying = false
    }
    
    private func configurePlayOrStopButtonImage(_ isPlaying: Bool) {
        let imageConfiguration = UIImage.SymbolConfiguration(pointSize: 60)
        
        if isPlaying {
            let playImage = UIImage(systemName: "pause.fill", withConfiguration: imageConfiguration)
            playOrStopButton.setImage(playImage, for: .normal)
        } else {
            let pauseImage = UIImage(systemName: "play.fill", withConfiguration: imageConfiguration)
            playOrStopButton.setImage(pauseImage, for: .normal)
        }
        
        playOrStopButton.tintColor = .white
    }
}
