//
//  VideoCellContentView.swift
//  VideoRecorder
//
//  Created by pablo.jee on 2022/10/11.
//

import UIKit
import SwiftUI

class VideoCellContentView: UIView, VideoCellContentViewStyle {

    var thumbNailImageView: UIImageView = UIImageView()
    var videoDurationLabel: UILabel = UILabel()
    
    var nameLabel: UILabel = UILabel()
    var dateLabel: UILabel = UILabel()
    
    var detailButton = UIButton()
    var disclosureButton = UIButton()
    
    var bigHeight: NSLayoutConstraint?
    var smallHeight: NSLayoutConstraint?
    
    
    //input
    var didReceiveViewModel: (VideoCellContentViewModel) -> () = { viewModel in  }
    
    init() {
        super.init(frame: .zero)
        initViewHierarchy()
        configureView()
        bind()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // TODO: remove
    func randomTest() {
        let random: Bool = Bool.random()
        if random == true {
            bigHeight?.priority = UILayoutPriority.init(900)
            smallHeight?.priority = UILayoutPriority.init(800)
        } else if random == false {
            bigHeight?.priority = UILayoutPriority.init(800)
            smallHeight?.priority = UILayoutPriority.init(900)
        }
        
    }

}

extension VideoCellContentView: Presentable {
    func initViewHierarchy() {
        self.addSubview(thumbNailImageView)
        self.addSubview(videoDurationLabel)
        self.addSubview(nameLabel)
        self.addSubview(dateLabel)
        self.addSubview(detailButton)
        self.addSubview(disclosureButton)
        
        self.subviews.forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }

        var constraints: [NSLayoutConstraint] = []
        defer { NSLayoutConstraint.activate(constraints) }

        constraints += [
            disclosureButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),
            disclosureButton.centerYAnchor.constraint(equalTo: thumbNailImageView.centerYAnchor)
        ]


        constraints += [
            detailButton.trailingAnchor.constraint(equalTo: disclosureButton.leadingAnchor, constant: -8),
            detailButton.centerYAnchor.constraint(equalTo: thumbNailImageView.centerYAnchor)
        ]

        constraints += [
            nameLabel.bottomAnchor.constraint(equalTo: self.thumbNailImageView.centerYAnchor, constant: -4),
            nameLabel.trailingAnchor.constraint(lessThanOrEqualTo: detailButton.leadingAnchor, constant: -8),
            nameLabel.leadingAnchor.constraint(equalTo: thumbNailImageView.trailingAnchor, constant: 16)
        ]

        constraints += [
            dateLabel.topAnchor.constraint(equalTo: self.thumbNailImageView.centerYAnchor, constant: 4),
            dateLabel.trailingAnchor.constraint(lessThanOrEqualTo: detailButton.leadingAnchor, constant: -8),
            dateLabel.leadingAnchor.constraint(equalTo: thumbNailImageView.trailingAnchor, constant: 16)
        ]
        
        bigHeight = thumbNailImageView.heightAnchor.constraint(equalToConstant: 120)
        bigHeight?.priority = UILayoutPriority.init(900)
        smallHeight = thumbNailImageView.heightAnchor.constraint(equalToConstant: 80)
        smallHeight?.priority = UILayoutPriority.init(800)

        guard let bigHeight = bigHeight else { return }
        guard let smallHeight = smallHeight else { return }
        
        constraints += [
            thumbNailImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            thumbNailImageView.topAnchor.constraint(equalTo: self.topAnchor, constant: 16),
            thumbNailImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -16),
            bigHeight,
            smallHeight,
            thumbNailImageView.widthAnchor.constraint(equalTo: thumbNailImageView.heightAnchor, multiplier: 1.2)
        ]

        constraints += [
            videoDurationLabel.leadingAnchor.constraint(equalTo: thumbNailImageView.leadingAnchor, constant: 16),
            videoDurationLabel.trailingAnchor.constraint(lessThanOrEqualTo: thumbNailImageView.trailingAnchor),
            videoDurationLabel.bottomAnchor.constraint(equalTo: thumbNailImageView.bottomAnchor, constant: -8)
        ]
    }

    func configureView() {
        thumbNailImageView.addStyles(style: thumbNailImageViewStyle)
        videoDurationLabel.addStyles(style: videoDurationLabelStyle)
        nameLabel.addStyles(style: nameLabelStyle)
        dateLabel.addStyles(style: dateLabelStyle)
        detailButton.addStyles(style: detailButtonStyle)
        disclosureButton.addStyles(style: disclosureButtonStyle)
    }
    
    func bind() {
        didReceiveViewModel = { [weak self] viewModel in
            guard let self = self else { return }
            // TODO: 진짜 섬네일 이미지 어떻게든 넣기
            self.thumbNailImageView.image = UIImage()
            self.nameLabel.text = viewModel.name
            self.dateLabel.text = viewModel.date
            self.videoDurationLabel.text = viewModel.duration
        }
    }
    
    
}


#if canImport(SwiftUI) && DEBUG
struct VideoCellContentViewPreview<View: UIView>: UIViewRepresentable {
    let view: View
    
    init(_ builder: @escaping () -> View) {
       view = builder()
    }
    
    func makeUIView(context: Context) -> some UIView {
        view
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        
    }
}

#endif


#if canImport(SwiftUI) && DEBUG

struct VideoCellContentViewPreviewProvider: PreviewProvider {
    static var previews: some View {
        VideoCellContentViewPreview {
            let view = VideoCellContentView()
            return view
        }.previewLayout(.fixed(width: 360, height: 100))
    }
}

#endif
