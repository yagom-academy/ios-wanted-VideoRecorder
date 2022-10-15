//
//  SliderView.swift
//  VideoRecorder
//
//  Created by CodeCamper on 2022/10/12.
//

import Foundation
import UIKit
import Combine
import SwiftUI

// MARK: - View
class SliderView: UIView {
    // MARK: View Components
    lazy var backgroundView: ObservableView = {
        let view = ObservableView()
        view.backgroundColor = UIColor(hex: "#7E8080")
        view.layer.cornerRadius = 1.5
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var foregroundView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(hex: "#D9D9D9")
        view.layer.cornerRadius = 1.5
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var foregroundViewWidthAnchor: NSLayoutConstraint!
    
    lazy var circleView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 3.5
        view.layer.shadowOffset = CGSize(width: 0, height: 1)
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.45
        view.layer.shadowRadius = 2
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
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
        
    }
    
    
    // MARK: Build View Hierarchy
    func buildViewHierarchy() {
        addSubview(backgroundView)
        addSubview(foregroundView)
        addSubview(circleView)
    }
    
    
    // MARK: Layout Views
    func setupConstraints() {
        var constraints = [NSLayoutConstraint]()
        
        defer {
            NSLayoutConstraint.activate(constraints)
        }
        
        constraints += [
            backgroundView.leadingAnchor.constraint(equalTo: leadingAnchor),
            backgroundView.trailingAnchor.constraint(equalTo: trailingAnchor),
            backgroundView.centerYAnchor.constraint(equalTo: centerYAnchor),
            backgroundView.heightAnchor.constraint(equalToConstant: 3),
        ]
        
        foregroundViewWidthAnchor = foregroundView.widthAnchor.constraint(equalToConstant: 200)
        constraints += [
            foregroundView.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor),
            foregroundView.centerYAnchor.constraint(equalTo: backgroundView.centerYAnchor),
            foregroundViewWidthAnchor,
            foregroundView.heightAnchor.constraint(equalToConstant: 3),
        ]
        
        constraints += [
            circleView.centerYAnchor.constraint(equalTo: foregroundView.centerYAnchor),
            circleView.trailingAnchor.constraint(equalTo: foregroundView.trailingAnchor, constant: 3.5),
            circleView.widthAnchor.constraint(equalToConstant: 7),
            circleView.heightAnchor.constraint(equalToConstant: 7),
        ]
    }
    
    
    // MARK: Binding
    func bind() {
        // Action
        let gestureStream = self.gesture(.pan).merge(with: self.gesture(.tap)).share()
        
        gestureStream
            .map { $0.location(in: self).x }
            .map { $0 / self.frame.width }
            .map { min(max(0, $0), 1) }
            .map { ViewModel.Action.updateCurrentTimeWithProgress($0) }
            .subscribe(viewModel.action)
            .store(in: &subscriptions)
        
        gestureStream
            .filter { $0.state == .began || $0.state == .ended }
            .map { $0.state == .began }
            .map { ViewModel.Action.setIsEditingCurrentTime($0) }
            .subscribe(viewModel.action)
            .store(in: &subscriptions)
        
        // State
        viewModel.$currentTime
            .combineLatest(viewModel.$metaData)
            .map { ($0, $1.videoLength) }
            .filter { $1 > 0 }
            .map { CGFloat($0 / $1) }
            .combineLatest(backgroundView.$framePublisher)
            .sink { [weak self] multiplier, frame in
                guard
                    let self,
                    frame.width * multiplier >= 0
                else { return }
                self.foregroundViewWidthAnchor?.constant = frame.width * multiplier
            }
            .store(in: &subscriptions)
    }
}
