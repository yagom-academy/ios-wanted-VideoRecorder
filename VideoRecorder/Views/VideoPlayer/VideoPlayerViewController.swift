//
//  VideoPlayerViewControllerViewController.swift
//  VideoRecorder
//
//  Created by CodeCamper on 2022/10/12.
//

import Foundation
import UIKit
import Combine
import SwiftUI
import AVKit

// MARK: - View Controller
class VideoPlayerViewController: UIViewController {
    // MARK: View Components
    lazy var videoPlayerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var videoPlayerLayer = AVPlayerLayer()
    
    lazy var navigationView: UIView = {
        let view = UIView()
        view.backgroundColor = .white.withAlphaComponent(0.35)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var controlView: VideoPlayerControlView = {
        let view = VideoPlayerControlView(viewModel: self.viewModel)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var backButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        button.tintColor = .black
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20, weight: .heavy)
        label.textColor = .black
        label.text = "Nature.mp4"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var infoButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "info.circle"), for: .normal)
        button.tintColor = .black
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var activityIndicatorView: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView()
        view.backgroundColor = .white.withAlphaComponent(0.5)
        view.startAnimating()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // MARK: Associated Types
    typealias ViewModel = VideoPlayerViewModel
    
    
    // MARK: Properties
    var didSetupConstraints = false
    var viewModel: ViewModel
    var subscriptions = [AnyCancellable]()
    
    
    
    // MARK: View Life Cycle
    init(viewModel: ViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        buildViewHierarchy()
        self.view.setNeedsUpdateConstraints()
        bind()
    }
    
    override func updateViewConstraints() {
        if !didSetupConstraints {
            self.setupConstraints()
            didSetupConstraints = true
        }
        super.updateViewConstraints()
    }
    
    // MARK: Setup Views
    func setupViews() {
        self.videoPlayerView.backgroundColor = .gray
    }
    
    // MARK: Build View Hierarchy
    func buildViewHierarchy() {
        self.view.addSubview(videoPlayerView)
        self.view.addSubview(controlView)
        self.view.addSubview(activityIndicatorView)
        self.view.addSubview(navigationView)
        videoPlayerView.layer.addSublayer(videoPlayerLayer)
        navigationView.addSubview(backButton)
        navigationView.addSubview(titleLabel)
        navigationView.addSubview(infoButton)
    }
    
    // MARK: Layout Views
    func setupConstraints() {
        var constraints = [NSLayoutConstraint]()
        
        defer { NSLayoutConstraint.activate(constraints) }
        
        constraints += [
            navigationView.topAnchor.constraint(equalTo: view.topAnchor),
            navigationView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            navigationView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            navigationView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 44),
        ]
        
        constraints += [
            backButton.leadingAnchor.constraint(equalTo: navigationView.leadingAnchor, constant: 16),
            backButton.bottomAnchor.constraint(equalTo: navigationView.bottomAnchor, constant: -12),
            backButton.widthAnchor.constraint(equalToConstant: 12),
            backButton.heightAnchor.constraint(equalToConstant: 19),
        ]
        
        constraints += [
            titleLabel.leadingAnchor.constraint(equalTo: navigationView.leadingAnchor, constant: 53),
            titleLabel.bottomAnchor.constraint(equalTo: navigationView.bottomAnchor, constant: -9),
        ]
        
        constraints += [
            infoButton.trailingAnchor.constraint(equalTo: navigationView.trailingAnchor, constant: -26),
            infoButton.bottomAnchor.constraint(equalTo: navigationView.bottomAnchor, constant: -12),
            infoButton.widthAnchor.constraint(equalToConstant: 19),
            infoButton.heightAnchor.constraint(equalToConstant: 19),
        ]
        
        constraints += [
            controlView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 21),
            controlView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -21),
            controlView.heightAnchor.constraint(equalToConstant: 148),
            controlView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -64),
        ]
        
        constraints += [
            videoPlayerView.topAnchor.constraint(equalTo: view.topAnchor),
            videoPlayerView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            videoPlayerView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            videoPlayerView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ]
        
        constraints += [
            activityIndicatorView.topAnchor.constraint(equalTo: view.topAnchor),
            activityIndicatorView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            activityIndicatorView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            activityIndicatorView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ]
    }
    
    
    // MARK: Binding
    func bind() {
        // State
        viewModel.$player
            .assign(to: \.player, on: videoPlayerLayer)
            .store(in: &subscriptions)
        
        viewModel.player.publisher(for: \.status)
            .filter { $0 == .readyToPlay }
            .prefix(1)
            .sink { [weak self] _ in
                guard let self else { return }
                self.activityIndicatorView.isHidden = true
                self.activityIndicatorView.stopAnimating()
            }.store(in: &subscriptions)
        
        viewModel.$metaData
            .compactMap { $0.name }
            .removeDuplicates()
            .assign(to: \.text, on: titleLabel)
            .store(in: &subscriptions)
        
        // View
        videoPlayerView.bounds()
            .assign(to: \.frame, on: videoPlayerLayer)
            .store(in: &subscriptions)
        
        self.view.gesture(.tap)
            .sink { [weak self] _ in
                guard let self else { return }
                UIView.animate(withDuration: 0.2) {
                    self.controlView.alpha = self.controlView.alpha == 1 ? 0 : 1
                    self.navigationView.alpha = self.navigationView.alpha == 1 ? 0 : 1
                }
            }.store(in: &subscriptions)
        
        backButton.gesture(.tap)
            .sink { [weak self] _ in
                guard let self else { return }
                self.navigationController?.popViewController(animated: true)
            }.store(in: &subscriptions)
    }
}

#if canImport(SwiftUI) && DEBUG
struct ContentViewControllerPreview<View: UIViewController> : UIViewControllerRepresentable {
    
    let view: View
    
    init(_ builder: @escaping () -> View) {
        view = builder()
    }
    
    func makeUIViewController(context: Context) -> some UIViewController {
        view
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        
    }
}
#endif

#if canImport(SwiftUI) && DEBUG
struct VideoPlayerViewControllerPreviewProvider: PreviewProvider {
    static var previews: some View {
        ContentViewControllerPreview {
            let metaData = DummyGenerator.dummyVideoMetaData()!
            let viewModel = VideoPlayerViewModel(metaData: metaData)
            let viewController = VideoPlayerViewController(viewModel: viewModel)
            let navigationController = UINavigationController(rootViewController: viewController)
            return navigationController
        }
    }
}
#endif
