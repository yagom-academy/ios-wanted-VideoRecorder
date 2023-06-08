//
//  RecordControlView.swift
//  VideoRecorder
//
//  Created by kokkilE on 2023/06/07.
//

import UIKit

class RecordControlView: UIStackView {
    private let imageButton = {
        let button = UIButton()
                
        let imageConfiguration = UIImage.SymbolConfiguration(pointSize: 40)
        let recordImage = UIImage(systemName: "rectangle", withConfiguration: imageConfiguration)
        button.setImage(recordImage, for: .normal)
        button.tintColor = .black.withAlphaComponent(0)
        
        return button
    }()
    
    let recordButton = {
        let button = UIButton()
                
        let imageConfiguration = UIImage.SymbolConfiguration(pointSize: 60)
        let recordImage = UIImage(systemName: "record.circle", withConfiguration: imageConfiguration)
        button.setImage(recordImage, for: .normal)
        button.tintColor = .red
        
        return button
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
    
    init(recordVideoViewModel: RecordVideoViewModel) {
        viewModel = recordVideoViewModel
        
        super.init(frame: .zero)
        
        addSubviews()
        setupView()
        addButtonActions()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addSubviews() {
        addArrangedSubview(imageButton)
        addArrangedSubview(recordButton)
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
        imageButton.addTarget(self, action: #selector(touchUpImageButton), for: .touchUpInside)
        recordButton.addTarget(self, action: #selector(touchUpRecordButton), for: .touchUpInside)
        rotateButton.addTarget(self, action: #selector(touchUpRotateButton), for: .touchUpInside)
    }
    
    @objc private func touchUpImageButton() {
        viewModel.isImageButtonTapped.toggle()
    }
    
    @objc private func touchUpRecordButton() {
        viewModel.isRecordButtonTapped.toggle()
        
        toggleButtonsActivation()
    }
    
    @objc private func touchUpRotateButton() {
        viewModel.isRotateButtonTapped.toggle()
    }
    
    private func toggleButtonsActivation() {
        imageButton.isEnabled.toggle()
        rotateButton.isEnabled.toggle()
    }
}
