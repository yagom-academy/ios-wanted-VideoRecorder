//
//  VideoRecodeViewController.swift
//  VideoRecorder
//
//  Created by 김지인 on 2022/10/11.
//

import UIKit

class VideoRecordViewController: UIViewController {
    override var prefersStatusBarHidden: Bool {
        return true
    }

    @IBOutlet weak var previewView: PreviewView!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var changeCameraButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    @IBAction func closeButtonPressed(_ sender: UIButton) {
        navigationController?.isNavigationBarHidden = false
        self.dismiss(animated: true)
    }

    @IBAction func recordButtonPressed(_ sender: UIButton) {
    }

    @IBAction func changeButtonPressed(_ sender: UIButton) {
    }

}
