//
//  RecordControlView.swift
//  VideoRecorder
//
//  Created by kokkilE on 2023/06/07.
//

import UIKit

class RecordControlView: UIView {
    private let viewModel: RecordVideoViewModel
    
    private let imageButton = {
        let button = UIButton()
                
        let imageConfiguration = UIImage.SymbolConfiguration(pointSize: 40)
        let recordImage = UIImage(systemName: "rectangle", withConfiguration: imageConfiguration)
        button.setImage(recordImage, for: .normal)
        button.tintColor = .black.withAlphaComponent(0)
        
        return button
    }()
    
    private let recordButton = {
        let button = UIButton()
                
        let imageConfiguration = UIImage.SymbolConfiguration(pointSize: 50)
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
    
    private lazy var stackView = {
        let stackView = UIStackView(arrangedSubviews: [imageButton, recordButton, rotateButton])
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.spacing = 12
        stackView.distribution = .fillEqually
        stackView.backgroundColor = .black.withAlphaComponent(0.4)
        stackView.layer.cornerRadius = 20
        
        addSubview(stackView)
        
        return stackView
    }()
    
    init(recordVideoViewModel: RecordVideoViewModel) {
        viewModel = recordVideoViewModel
        
        super.init(frame: .zero)
        
        translatesAutoresizingMaskIntoConstraints = false
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func layout() {
        let safe = safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: safe.leadingAnchor, constant: 10),
            stackView.trailingAnchor.constraint(equalTo: safe.trailingAnchor, constant: -10),
            stackView.bottomAnchor.constraint(equalTo: safe.bottomAnchor, constant: -10),
            stackView.heightAnchor.constraint(equalToConstant: 100)
        ])
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
    }
    
    @objc private func touchUpRotateButton() {
        viewModel.isRotateButtonTapped.toggle()
    }
}
