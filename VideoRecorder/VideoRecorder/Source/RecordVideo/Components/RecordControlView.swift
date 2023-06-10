//
//  RecordControlView.swift
//  VideoRecorder
//
//  Created by kokkilE on 2023/06/07.
//

import UIKit
import Combine
import AVFoundation

class RecordControlView: UIStackView {
    private let previousImageView = {
        let imageView = UIImageView()
                        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    
    private let recordStackView = {
        let stackView = UIStackView()
        
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.alignment = .center
        
        return stackView
    }()
    
    private let recordButton = {
        let button = UIButton()
                
        let imageConfiguration = UIImage.SymbolConfiguration(pointSize: 60)
        let recordImage = UIImage(systemName: "record.circle", withConfiguration: imageConfiguration)
        button.setImage(recordImage, for: .normal)
        button.tintColor = .red
        
        return button
    }()
    
    private let timerLabel = {
        let label = UILabel()
        
        label.font = .preferredFont(forTextStyle: .body)
        label.textColor = .white
        label.isHidden = true
        
        return label
    }()
    
    private let rotateButton = {
        let button = UIButton()
                
        let imageConfiguration = UIImage.SymbolConfiguration(pointSize: 40)
        let rotateImage = UIImage(systemName: "camera.rotate", withConfiguration: imageConfiguration)
        button.setImage(rotateImage, for: .normal)
        button.tintColor = .white
        
        return button
    }()
    
    private let viewModel: RecordVideoViewModel
    private var subscriptions = Set<AnyCancellable>()
    
    init(viewModel: RecordVideoViewModel) {
        self.viewModel = viewModel
        
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
        viewModel.runCountPublisher()
            .sink { [weak self] runCount in
                let time = CMTime(seconds: runCount, preferredTimescale: 1)
                
                self?.timerLabel.text = time.formattedTime
            }
            .store(in: &subscriptions)
        
        viewModel.firstImagePublisher()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] image in
                let renderer = UIGraphicsImageRenderer(size: CGSize(width: 40, height: 32))
                let resizedImage = renderer.image(actions: { _ in image?.draw(in: CGRect(x: 0, y: 0, width: 40, height: 32))})
                self?.previousImageView.image = resizedImage
            }
            .store(in: &subscriptions)
    }
    
    private func addSubviews() {
        recordStackView.addArrangedSubview(recordButton)
        recordStackView.addArrangedSubview(timerLabel)
        
        addArrangedSubview(previousImageView)
        addArrangedSubview(recordStackView)
        addArrangedSubview(rotateButton)
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
        recordButton.addTarget(self, action: #selector(touchUpRecordButton), for: .touchUpInside)
        rotateButton.addTarget(self, action: #selector(touchUpRotateButton), for: .touchUpInside)
    }
    
    @objc private func touchUpRecordButton() {
        viewModel.isRecordButtonTapped.toggle()
        
        toggleUIActivation()
    }
    
    @objc private func touchUpRotateButton() {
        viewModel.isRotateButtonTapped.toggle()
    }
    
    private func toggleUIActivation() {
        timerLabel.isHidden.toggle()
        rotateButton.isEnabled.toggle()
    }
}
