//
//  RecordingVideoViewController.swift
//  ios-wanted-VideoRecorder
//
//  Created by brody on 2023/06/08.
//

import UIKit

final class RecordingVideoViewController: UIViewController {
    private enum Constant {
        static let ButtonWidth: CGFloat = 50
        static let RecordingButtonWidth: CGFloat = 25
        static let borderViewWidth: CGFloat = 70
        static let recordingButtonRadius: CGFloat = 0
        static let buttonRadius: CGFloat = 25
    }
    
    private let borderView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.layer.borderWidth = 5
        view.layer.borderColor = UIColor.white.cgColor
        view.layer.cornerRadius = 35
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private let recodingButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = .red
        button.layer.cornerRadius = Constant.RecordingButtonWidth
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    private var buttonWidthConstraint: NSLayoutConstraint!
    private var buttonHeightConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        view.backgroundColor = .white
        
        view.addSubview(borderView)
        
        NSLayoutConstraint.activate([
            borderView.widthAnchor.constraint(equalToConstant: Constant.borderViewWidth),
            borderView.heightAnchor.constraint(equalToConstant: Constant.borderViewWidth),
            borderView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            borderView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
        
        view.addSubview(recodingButton)
        buttonWidthConstraint = recodingButton.widthAnchor.constraint(equalToConstant: Constant.ButtonWidth)
        buttonHeightConstraint = recodingButton.heightAnchor.constraint(equalToConstant: Constant.ButtonWidth)
        
        NSLayoutConstraint.activate([
            buttonWidthConstraint,
            buttonHeightConstraint,
            recodingButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            recodingButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
        
        recodingButton.addTarget(self, action: #selector(recordingButtonTapped), for: .touchUpInside)
    }
    
    @objc
    func recordingButtonTapped() {
        recodingButton.isSelected.toggle()
        UIView.animate(withDuration: 1, delay: 0, options: [.curveEaseInOut], animations: {
            if self.recodingButton.isSelected {
                self.buttonWidthConstraint.constant = Constant.RecordingButtonWidth
                self.buttonHeightConstraint.constant = Constant.RecordingButtonWidth
                self.recodingButton.layer.cornerRadius = Constant.recordingButtonRadius
            } else {
                self.buttonWidthConstraint.constant = Constant.ButtonWidth
                self.buttonHeightConstraint.constant = Constant.ButtonWidth
                self.recodingButton.layer.cornerRadius = Constant.buttonRadius
            }
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
}
