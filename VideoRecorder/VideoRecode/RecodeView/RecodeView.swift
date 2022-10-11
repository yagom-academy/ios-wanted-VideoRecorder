//
//  RecodeView.swift
//  VideoRecorder
//
//  Created by 김지인 on 2022/10/11.
//

import UIKit

final class RecodeView: UIView {
    
    @IBOutlet private weak var thumbnailView: UIView!
    @IBOutlet private weak var recodeButton: UIButton!
    @IBOutlet private weak var recodeTimeLabel: UILabel!
    @IBOutlet private weak var cameraChangeButton: UIButton!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        loadView()
    }
   
}
