//
//  PlayVideoViewController.swift
//  VideoRecorder
//
//  Created by kokkilE on 2023/06/09.
//

import UIKit
import AVFoundation

final class PlayVideoViewController: UIViewController {
    private let video: Video
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
        
        stackView.layer.addSublayer(playerLayer)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(stackView)
        
        return stackView
    }()
    
    init(video: Video) {
        self.video = video
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        layout()
        playVideo()
        setupNavigationItems()
    }
    
    private func setupView() {
        view.backgroundColor = .white.withAlphaComponent(0.9)
    }
    
    private func layout() {
        let safe = view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            layerStackView.topAnchor.constraint(equalTo: safe.topAnchor),
            layerStackView.leadingAnchor.constraint(equalTo: safe.leadingAnchor),
            layerStackView.trailingAnchor.constraint(equalTo: safe.trailingAnchor),
            layerStackView.bottomAnchor.constraint(equalTo: safe.bottomAnchor)
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
        // Todo
    }
}
