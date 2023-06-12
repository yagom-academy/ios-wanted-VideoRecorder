//
//  LoadingView.swift
//  VideoRecorder
//
//  Created by kokkilE on 2023/06/06.
//

import UIKit

final class LoadingView: UIView {
    private let activityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        
        indicator.translatesAutoresizingMaskIntoConstraints = false
        
        return indicator
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        translatesAutoresizingMaskIntoConstraints = false
        
        addSubviews()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func start() {
        DispatchQueue.main.async { [weak self] in
            self?.activityIndicatorView.startAnimating()
            self?.isHidden = false
        }
    }
    
    func stop() {
        DispatchQueue.main.async { [weak self] in
            self?.activityIndicatorView.stopAnimating()
            self?.isHidden = true
        }
    }
    
    private func addSubviews() {
        addSubview(activityIndicatorView)
    }
    
    private func layout() {
        let safe = safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            activityIndicatorView.topAnchor.constraint(equalTo: safe.topAnchor),
            activityIndicatorView.leadingAnchor.constraint(equalTo: safe.leadingAnchor),
            activityIndicatorView.trailingAnchor.constraint(equalTo: safe.trailingAnchor),
            activityIndicatorView.bottomAnchor.constraint(equalTo: safe.bottomAnchor)
        ])
    }
}
