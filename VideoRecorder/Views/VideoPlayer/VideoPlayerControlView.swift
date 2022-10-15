//
//  VideoPlayerControlView.swift
//  VideoRecorder
//
//  Created by 한경수 on 2022/10/13.
//

import Foundation
import UIKit
import Combine
import SwiftUI

// MARK: - View
class VideoPlayerControlView: UIView {
    // MARK: View Components
    lazy var sliderView: SliderView = {
        let view = SliderView(viewModel: self.viewModel)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var currentTimeLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 10)
        label.textColor = UIColor(hex: "#FEFEFE")
        label.text = "00:00"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var durationLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 10)
        label.textColor = UIColor(hex: "#FEFEFE")
        label.text = "00:00"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var playButton: UIButton = {
        let button = UIButton()
        button.tintColor = .white
        button.setImage(UIImage(systemName: "play.fill"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var rewindButton: UIButton = {
        let button = UIButton()
        button.tintColor = .white
        button.setImage(UIImage(systemName: "backward.end.fill"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var shareButton: UIButton = {
        let button = UIButton()
        button.tintColor = .white
        button.setImage(UIImage(systemName: "square.and.arrow.up"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: Associated Types
    typealias ViewModel = VideoPlayerViewModel
    
    // MARK: Properties
    var didSetupConstraints = false
    var viewModel: ViewModel { didSet { bind() } }
    var subscriptions = [AnyCancellable]()
    
    // MARK: Life Cycle
    init(viewModel: ViewModel) {
        self.viewModel = viewModel
        super.init(frame: .zero)
        setupViews()
        buildViewHierarchy()
        self.setNeedsUpdateConstraints()
        bind()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func updateConstraints() {
        if !didSetupConstraints {
            self.setupConstraints()
            didSetupConstraints = true
        }
        super.updateConstraints()
    }
    
    // MARK: Setup Views
    func setupViews() {
        self.backgroundColor = .black.withAlphaComponent(0.5)
        self.layer.cornerRadius = 20
    }
    
    
    // MARK: Build View Hierarchy
    func buildViewHierarchy() {
        self.addSubview(sliderView)
        self.addSubview(currentTimeLabel)
        self.addSubview(durationLabel)
        self.addSubview(playButton)
        self.addSubview(rewindButton)
        self.addSubview(shareButton)
    }
    
    
    // MARK: Layout Views
    func setupConstraints() {
        var constraints = [NSLayoutConstraint]()
        
        defer { NSLayoutConstraint.activate(constraints) }
        
        constraints += [
            sliderView.topAnchor.constraint(equalTo: topAnchor, constant: 26),
            sliderView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 28),
            sliderView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -28),
            sliderView.heightAnchor.constraint(equalToConstant: 10),
        ]
        
        constraints += [
            currentTimeLabel.topAnchor.constraint(equalTo: sliderView.bottomAnchor, constant: 11),
            currentTimeLabel.leadingAnchor.constraint(equalTo: sliderView.leadingAnchor),
        ]
        
        constraints += [
            durationLabel.topAnchor.constraint(equalTo: sliderView.bottomAnchor, constant: 11),
            durationLabel.trailingAnchor.constraint(equalTo: sliderView.trailingAnchor),
        ]
        
        constraints += [
            playButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -35),
            playButton.widthAnchor.constraint(equalToConstant: 38),
            playButton.heightAnchor.constraint(equalToConstant: 42),
            playButton.centerXAnchor.constraint(equalTo: centerXAnchor),
        ]
        
        constraints += [
            rewindButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 28),
            rewindButton.widthAnchor.constraint(equalToConstant: 24),
            rewindButton.heightAnchor.constraint(equalToConstant: 21),
            rewindButton.centerYAnchor.constraint(equalTo: playButton.centerYAnchor),
        ]
        
        constraints += [
            shareButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -28),
            shareButton.widthAnchor.constraint(equalToConstant: 23),
            shareButton.heightAnchor.constraint(equalToConstant: 29),
            shareButton.centerYAnchor.constraint(equalTo: playButton.centerYAnchor),
        ]
    }
    
    
    // MARK: Binding
    func bind() {
        // Action
        playButton.gesture(.tap)
            .map { _ in ViewModel.Action.toggleIsPlaying }
            .subscribe(viewModel.action)
            .store(in: &subscriptions)
        
        rewindButton.gesture(.tap)
            .map { _ in ViewModel.Action.rewind }
            .subscribe(viewModel.action)
            .store(in: &subscriptions)
        
        // State
        viewModel.player.publisher(for: \.timeControlStatus)
            .map { $0 == .playing }
            .map { $0 ? UIImage(systemName: "pause.fill") : UIImage(systemName: "play.fill") }
            .sink { [weak self] image in
                guard let self else { return }
                self.playButton.setImage(image, for: .normal)
            }.store(in: &subscriptions)
        
        viewModel.$currentTime
            .map { $0.convertToTimeFormat() }
            .assign(to: \.text, on: currentTimeLabel)
            .store(in: &subscriptions)
        
        viewModel.$metaData
            .map { $0.videoLength }
            .map { $0.convertToTimeFormat() }
            .assign(to: \.text, on: durationLabel)
            .store(in: &subscriptions)
    }
}
