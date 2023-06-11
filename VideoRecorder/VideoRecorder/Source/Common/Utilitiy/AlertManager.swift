//
//  AlertManager.swift
//  VideoRecorder
//
//  Created by 조향래 on 2023/06/09.
//

import UIKit

struct AlertManager {
    func createSaveVideoAlert(okCompletion: @escaping (String) -> (), cancelCompletion: @escaping () -> ()) -> UIAlertController {
        let alertController = UIAlertController(title: "다음 이름으로 저장", message: nil, preferredStyle: .alert)
        
        alertController.addTextField { textField in
            textField.placeholder = "파일명을 입력하세요."
        }
        
        let confirmAction = UIAlertAction(title: "저장", style: .default) { _ in
            if let textFields = alertController.textFields,
               let textField = textFields.first,
               let text = textField.text {
                okCompletion(text)
            }
        }
        
        let cancelAction = UIAlertAction(title: "취소", style: .destructive) { _ in
            cancelCompletion()
        }
                
        alertController.addAction(confirmAction)
        alertController.addAction(cancelAction)
        
        return alertController
    }
    
    func createInformationAlert(video: Video) -> UIAlertController {
        let title = video.title
        let message = """
        식별자: \(video.identifier)
        촬영일자: \(DateFormatter.dateToText(video.date))
        """
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let confirmAction = UIAlertAction(title: "확인", style: .default)
        
        alertController.addAction(confirmAction)
        
        return alertController
    }
}
