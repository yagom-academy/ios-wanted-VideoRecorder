//
//  RecordingVideoViewController.swift
//  ios-wanted-VideoRecorder
//
//  Created by brody on 2023/06/08.
//

import UIKit

final class RecordingVideoViewController: UIViewController {
    private enum Constant {
        static let ButtonWidth: CGFloat = 35
        static let buttonRadius: CGFloat = 17.5
        static let RecordingButtonWidth: CGFloat = 20
        static let recordingButtonRadius: CGFloat = 0
        static let borderViewWidth: CGFloat = 60
    }
    
    private let historyImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "mockImage")
        imageView.layer.cornerRadius = 10
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    
    private let borderView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.layer.borderWidth = 5
        view.layer.borderColor = UIColor.white.cgColor
        view.layer.cornerRadius = 30
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private let recordingButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = .red
        button.layer.cornerRadius = Constant.buttonRadius
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    private let recordingPlayerView: UIView = {
        let view = UIView()
        view.backgroundColor = .black.withAlphaComponent(0.5)
        view.layer.cornerRadius = 10
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private let timerLabel: UILabel = {
        let label = UILabel()
        label.text = "00:00"
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private let switchCameraButton: UIButton = {
        let button = UIButton()
        let config = UIImage.SymbolConfiguration(pointSize: 30, weight: .light, scale: .default)
        button.setImage(
            UIImage(systemName: "arrow.triangle.2.circlepath.camera", withConfiguration: config),
            for: .normal
        )
        button.tintColor = .white
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    private var buttonWidthConstraint: NSLayoutConstraint!
    private var buttonHeightConstraint: NSLayoutConstraint!
    
    var timer: Timer?
    var secondsOfTimer = 0
    
    override func viewDidLoad() {
        configureLayout()
        connectTarget()
    }
    
    private func configureLayout() {
        view.backgroundColor = .white
        
        configureRecordingPlayerViewLayout()
    }
    
    private func configureRecordingPlayerViewLayout() {
        view.addSubview(recordingPlayerView)
        
        NSLayoutConstraint.activate([
            recordingPlayerView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.9),
            recordingPlayerView.heightAnchor.constraint(
                equalTo: recordingPlayerView.widthAnchor,
                multiplier: 0.35
            ),
            recordingPlayerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            recordingPlayerView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -100)
        ])
        
        // 히스토리 이미지 레이아웃
        view.addSubview(historyImageView)
        
        NSLayoutConstraint.activate([
            historyImageView.widthAnchor.constraint(equalToConstant: 50),
            historyImageView.heightAnchor.constraint(equalToConstant: 50),
            historyImageView.leadingAnchor.constraint(
                equalTo: recordingPlayerView.leadingAnchor,
                constant: 30
            ),
            historyImageView.centerYAnchor.constraint(equalTo: recordingPlayerView.centerYAnchor)
        ])
        
        // 녹화버튼 레이아웃
        view.addSubview(borderView)
        
        NSLayoutConstraint.activate([
            borderView.widthAnchor.constraint(equalToConstant: Constant.borderViewWidth),
            borderView.heightAnchor.constraint(equalToConstant: Constant.borderViewWidth),
            borderView.centerXAnchor.constraint(equalTo: recordingPlayerView.centerXAnchor),
            borderView.centerYAnchor.constraint(equalTo: recordingPlayerView.centerYAnchor, constant: -10),
        ])
        
        view.addSubview(recordingButton)
        buttonWidthConstraint = recordingButton.widthAnchor.constraint(equalToConstant: Constant.ButtonWidth)
        buttonHeightConstraint = recordingButton.heightAnchor.constraint(equalToConstant: Constant.ButtonWidth)
        
        NSLayoutConstraint.activate([
            buttonWidthConstraint,
            buttonHeightConstraint,
            recordingButton.centerXAnchor.constraint(equalTo: borderView.centerXAnchor),
            recordingButton.centerYAnchor.constraint(equalTo: borderView.centerYAnchor),
        ])
        
        // 타이머 레이아웃
        view.addSubview(timerLabel)
        
        NSLayoutConstraint.activate([
            timerLabel.centerXAnchor.constraint(equalTo: borderView.centerXAnchor),
            timerLabel.topAnchor.constraint(equalTo: borderView.bottomAnchor, constant: 5)
        ])
        
        // 카메라 변경버튼 레이아웃
        view.addSubview(switchCameraButton)
        
        NSLayoutConstraint.activate([
            switchCameraButton.widthAnchor.constraint(equalToConstant: 50),
            switchCameraButton.heightAnchor.constraint(equalToConstant: 50),
            switchCameraButton.trailingAnchor.constraint(
                equalTo: recordingPlayerView.trailingAnchor,
                constant: -30
            ),
            switchCameraButton.centerYAnchor.constraint(equalTo: recordingPlayerView.centerYAnchor)
        ])
    }
    
    private func connectTarget() {
        recordingButton.addTarget(self, action: #selector(recordingButtonTapped), for: .touchUpInside)
    }
    
    // MARK: - Timer methods
    
    private func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] timer in
            guard let self else { return }
            
            self.secondsOfTimer += 1
            self.timerLabel.text = Double(self.secondsOfTimer).format(units: [.minute, .second])
        }
    }
    
    private func stopTimer() {
        timer?.invalidate()
        secondsOfTimer = 0
        self.timerLabel.text = "00:00"
    }
    
    @objc
    func recordingButtonTapped() {
        recordingButton.isSelected.toggle()
        
        recordingButton.isSelected ? self.startTimer() : self.stopTimer()
        
        UIView.animate(withDuration: 0.4, delay: 0, options: [.curveEaseInOut], animations: {
            if self.recordingButton.isSelected {
                self.buttonWidthConstraint.constant = Constant.RecordingButtonWidth
                self.buttonHeightConstraint.constant = Constant.RecordingButtonWidth
                self.recordingButton.layer.cornerRadius = Constant.recordingButtonRadius
            } else {
                self.buttonWidthConstraint.constant = Constant.ButtonWidth
                self.buttonHeightConstraint.constant = Constant.ButtonWidth
                self.recordingButton.layer.cornerRadius = Constant.buttonRadius
            }
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
}

fileprivate extension Double {
    func format(units: NSCalendar.Unit) -> String? {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = units
        formatter.zeroFormattingBehavior = [.pad]
        
        return formatter.string(from: self)
    }
}

