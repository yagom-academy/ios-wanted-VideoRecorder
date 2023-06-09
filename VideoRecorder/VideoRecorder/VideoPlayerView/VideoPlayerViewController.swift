//
//  VideoPlayerViewController.swift
//  VideoRecorder
//
//  Created by Rowan on 2023/06/09.
//

import UIKit
import Combine

final class VideoPlayerViewController: UIViewController {
    private let videoView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    private let videoControllerView: VideoControllerView = {
        let controllerView = VideoControllerView(frame: .zero)
        controllerView.backgroundColor = .clear.withAlphaComponent(0.8)
        controllerView.layer.cornerRadius = 20
        controllerView.translatesAutoresizingMaskIntoConstraints = false
        
        return controllerView
    }()
    
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
        bindAction()
        bindState()
    }

    private func configureNavigationBar() {
        let rightImage = UIImage(systemName: "info.circle")
        let rightButton = UIBarButtonItem(image: rightImage,
                                          style: .plain,
                                          target: nil,
                                          action: nil)
        rightButton.tintColor = .systemGray
        navigationItem.rightBarButtonItem = rightButton
        
        let barAppearance = UINavigationBarAppearance()
        barAppearance.backgroundColor = .white
        
        navigationController?.navigationBar.scrollEdgeAppearance = barAppearance
        
    }
    
    private func configureRootView() {
        self.view.addSubview(videoView)
        self.view.addSubview(videoControllerView)
        
        let playerLayer = viewModel.playerLayer
        let frameHeight = view.frame.height - view.safeAreaInsets.top
        playerLayer.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: frameHeight)
        playerLayer.videoGravity = .resizeAspectFill
        
        videoView.layer.addSublayer(playerLayer)
    }
    
    private func setupLayoutConstraints() {
        NSLayoutConstraint.activate([
            videoView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            videoView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
            videoView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
            videoView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor),
            
            videoControllerView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 18),
            videoControllerView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -18),
            videoControllerView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -18),
            videoControllerView.heightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.heightAnchor, multiplier: 0.2)
        ])
    }
    
    // MARK: - Bind Action
    private func bindAction() {
        let playButtonTapped = videoControllerView.playButton.publisher(for: .touchUpInside)
            .eraseToAnyPublisher()
        
        let sliderValue = videoControllerView.slider.publisher(for: .valueChanged)
            .compactMap { [weak self] in
                self?.videoControllerView.slider.value
            }
            .map { Double($0) }
            .eraseToAnyPublisher()
        
        let input = VideoPlayerViewModel.Input(
            playButtonTapped: playButtonTapped,
            sliderValue: sliderValue
        )
        
        let output = viewModel.transform(input: input)
        output.isPlayingVideo
            .sink { [weak self] isPlayingVideo in
                self?.setPlayButtonImage(for: isPlayingVideo)
            }
            .store(in: &cancellables)
        
        output.timeSearched
            .sink { _ in
                print("searching successed")
            }
            .store(in: &cancellables)
        
    }
    
    private func setPlayButtonImage(for isPlayingVideo: Bool) {
        if isPlayingVideo {
            let imageConfiguration = UIImage.SymbolConfiguration(pointSize: 40)
            let image = UIImage(systemName: "pause.fill", withConfiguration: imageConfiguration)
            videoControllerView.playButton.setImage(image, for: .normal)
        } else {
            let imageConfiguration = UIImage.SymbolConfiguration(pointSize: 40)
            let image = UIImage(systemName: "play.fill", withConfiguration: imageConfiguration)
            videoControllerView.playButton.setImage(image, for: .normal)
        }
    }
    
    // MARK: - Bind State
    private func bindState() {
        viewModel.itemStatusPublisher()
            .sink { [weak self] duration in
                self?.setupSliderValue(maximumValue: duration)
            }
            .store(in: &cancellables)
            
        
        viewModel.currentPlayTimeSubject
            .sink { [weak self] timeValue in
                self?.videoControllerView.slider.value = timeValue
            }
            .store(in: &cancellables)
    }
    
    private func setupSliderValue(maximumValue: Float) {
        videoControllerView.slider.minimumValue = .zero
        videoControllerView.slider.maximumValue = maximumValue
    }
}
