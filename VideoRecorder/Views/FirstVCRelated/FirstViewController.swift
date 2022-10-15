//
//  ViewController.swift
//  VideoRecorder
//
//  Created by kjs on 2022/10/07.
//

import UIKit

class FirstViewController: UIViewController, BasicNavigationBarStyling, FirstViewControllerRoutable {

    var model: FirstModel
    
    lazy var contentView: FirstContentView = FirstContentView(viewModel: self.model.firstContentViewModel)
    
    init(viewModel: FirstModel) {
        self.model = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        initViewHierarchy()
        configureView()
        bind()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        model.populateData()
        // Do any additional setup after loading the view.
    }
}

extension FirstViewController: Presentable {
    func initViewHierarchy() {
        self.view = UIView()
        self.view.backgroundColor = .white
        
        self.view.addSubview(contentView)
        
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        var constraint: [NSLayoutConstraint] = []
        defer { NSLayoutConstraint.activate(constraint) }
        
        constraint += [
            contentView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        ]
    }
    
    func configureView() {
        navigationItem.title = "목록"
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: nil, style: .plain, target: self, action: #selector(recordAction))
        navigationItem.rightBarButtonItem?.addStyles(style: recordButtonStyle)
    }
    
    func bind() {
        model.routeSubject = { [weak self] sceneCategory in
            guard let self = self else { return }
            self.route(to: sceneCategory)
        }
    }
    
    @objc func recordAction() {
        model.didTapRecordButton()
    }
    
    
}
