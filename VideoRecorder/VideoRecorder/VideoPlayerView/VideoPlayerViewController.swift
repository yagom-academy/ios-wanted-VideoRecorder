//
//  VideoPlayerViewController.swift
//  VideoRecorder
//
//  Created by Rowan on 2023/06/09.
//

import UIKit
import Combine

final class VideoPlayerViewController: UIViewController {
    private let videoControllerView: VideoControllerView = VideoControllerView()
    
    private var cancellables: Set<AnyCancellable> = []
    
    private let viewModel: VideoPlayerViewModel
    
    init(viewModel: VideoPlayerViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationBar()
        configureRootView()
        setupLayoutConstraints()
    }
    
    private func configureNavigationBar() {
        let rightImage = UIImage(systemName: "info.circle")
        rightImage?.withTintColor(.systemGray)
        let rightButton = UIBarButtonItem(image: rightImage,
                                          style: .plain,
                                          target: nil,
                                          action: nil)
        navigationItem.rightBarButtonItem = rightButton
    }
    
    private func configureRootView() {
        self.view.addSubview(videoControllerView)
        
        let playerLayer = viewModel.playerLayer
        playerLayer.frame = self.view.bounds
        playerLayer.videoGravity = .resizeAspectFill
        
        self.view.layer.addSublayer(playerLayer)
    }
    
    private func setupLayoutConstraints() {
        NSLayoutConstraint.activate([
            videoControllerView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 18),
            videoControllerView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -18),
            videoControllerView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -18),
            videoControllerView.heightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.heightAnchor, multiplier: 0.2)
        ])
    }
    
    private func setupSliderValue() {
        videoControllerView.slider.minimumValue = .zero
        videoControllerView.slider.maximumValue = viewModel.videoDuration
    }
    
    private func bindAction() {
        let sliderValue = videoControllerView.slider.publisher(for: .valueChanged)
            .compactMap { [weak self] in
                self?.videoControllerView.slider.value
            }
            .map { Double($0) }
            .eraseToAnyPublisher()
        
        let input = VideoPlayerViewModel.Input(sliderValue: sliderValue)
        
        let output = viewModel.transform(input: input)
        output.timeSearched
            .sink { _ in
                print("searching successed")
            }
            .store(in: &cancellables)
    }
}
