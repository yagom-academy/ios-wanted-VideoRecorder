//
//  PlayVideoViewController.swift
//  VideoRecorder
//
//  Created by kokkilE on 2023/06/09.
//

import UIKit
import AVFoundation
import Combine

final class PlayVideoViewController: UIViewController {
    private let video: Video
    private let viewModel: PlayVideoViewModel
    private var subscriptions = Set<AnyCancellable>()
    private let playControlView: PlayControlView
    private var player = AVPlayer()
    private lazy var playerLayer = {
        let layer = AVPlayerLayer(player: self.player)

        layer.frame = CGRect(x: 0, y: 0,
                             width: view.bounds.width,
                             height: view.bounds.height)
        layer.position = CGPoint(x: view.bounds.midX, y: view.bounds.midY)
        layer.videoGravity = .resizeAspectFill
                
        return layer
    }()
    private lazy var layerStackView = {
        let stackView = UIStackView()
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
                
        return stackView
    }()
    
    init(video: Video) {
        self.video = video
        self.viewModel = PlayVideoViewModel()
        self.playControlView = PlayControlView(viewModel: viewModel)
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        addSubviews()
        layout()
        playVideo()
        setupNavigationItems()
        bind()
    }
    
    private func setupView() {
        view.backgroundColor = .white.withAlphaComponent(0.9)
    }
    
    private func addSubviews() {
        layerStackView.layer.addSublayer(playerLayer)
        
        view.addSubview(layerStackView)
        view.addSubview(playControlView)
    }
    
    private func layout() {
        let safe = view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([

        ])
        
        NSLayoutConstraint.activate([
            layerStackView.topAnchor.constraint(equalTo: safe.topAnchor),
            layerStackView.leadingAnchor.constraint(equalTo: safe.leadingAnchor),
            layerStackView.trailingAnchor.constraint(equalTo: safe.trailingAnchor),
            layerStackView.bottomAnchor.constraint(equalTo: safe.bottomAnchor),
            
            playControlView.leadingAnchor.constraint(equalTo: safe.leadingAnchor, constant: 40),
            playControlView.trailingAnchor.constraint(equalTo: safe.trailingAnchor, constant: -40),
            playControlView.bottomAnchor.constraint(equalTo: safe.bottomAnchor, constant: -20),
            playControlView.heightAnchor.constraint(equalToConstant: 140)
        ])
    }
    
    private func playVideo() {
        guard let data = video.data,
              let videoURL = createVideoURL(with: data) else { return }
        
        let item = AVPlayerItem(url: videoURL)
        player.replaceCurrentItem(with: item)
        player.play()
    }

    private func createVideoURL(with data: Data) -> URL? {
        let temporaryURL = FileManager.default.temporaryDirectory
        let fileName = "\(video.title)-\(UUID().uuidString).mp4"
        let videoURL = temporaryURL.appendingPathComponent(fileName)
        
        do {
            try data.write(to: videoURL)
            return videoURL
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }
    
    private func setupNavigationItems() {
        setupLeftBarButton()
        setupRightBarButton()
    }
    
    private func setupLeftBarButton() {
        let systemImageName = "chevron.backward"
        
        let imageConfiguration = UIImage.SymbolConfiguration(pointSize: 24, weight: .bold)
        let backImage = UIImage(systemName: systemImageName, withConfiguration: imageConfiguration)
        
        let backButton = UIButton()
        backButton.addTarget(self, action: #selector(dismissRecordView), for: .touchUpInside)
        backButton.setImage(backImage, for: .normal)
        backButton.setTitle(video.title, for: .normal)
        backButton.titleLabel?.font = .boldSystemFont(ofSize: 24)
        backButton.setTitleColor(.black, for: .normal)
        backButton.tintColor = .black
        
        backButton.contentEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 8, right: 40)
        backButton.titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: -40)
                
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
    }
    
    private func setupRightBarButton() {
        let systemImageName = "info.circle"
        
        let imageConfiguration = UIImage.SymbolConfiguration(pointSize: 24)
        let backImage = UIImage(systemName: systemImageName, withConfiguration: imageConfiguration)
        
        let backButton = UIButton()
        backButton.addTarget(self, action: #selector(presentInformation), for: .touchUpInside)
        backButton.setImage(backImage, for: .normal)
        backButton.setTitleColor(.black, for: .normal)
        backButton.tintColor = .black
        
        backButton.contentEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 8, right: 8)
                
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: backButton)
    }
    
    @objc private func dismissRecordView() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func presentInformation() {
        // TODO
    }
    
    private func bind() {
        viewModel.$isTouchUpBackwardButton
            .dropFirst()
            .sink { [weak self] _ in
                self?.player.seek(to: .zero)
            }
            .store(in: &subscriptions)
        
        viewModel.$isPlaying
            .dropFirst()
            .sink { [weak self] isPlaying in
                if isPlaying {
                    self?.player.play()
                } else {
                    self?.player.pause()
                }
            }
            .store(in: &subscriptions)
        
        viewModel.$isTouchUpShareButton
            .dropFirst()
            .sink { [weak self] _ in
                self?.shareVideo()
            }
            .store(in: &subscriptions)
    }
    
    private func shareVideo() {
        let activityViewController = UIActivityViewController(
            activityItems: [video],
            applicationActivities: nil
        )
        
        present(activityViewController, animated: true)
    }
}
