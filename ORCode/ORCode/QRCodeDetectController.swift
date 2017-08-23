//
//  QRCodeDetectController.swift
//  ORCode
//
//  Created by lixiangzhou on 2017/8/23.
//  Copyright © 2017年 lixiangzhou. All rights reserved.
//

import UIKit
import Photos

class QRCodeDetectController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    var textLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        
        textLabel = UILabel(frame: view.bounds)
        textLabel.numberOfLines = 0
        view.addSubview(textLabel)
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        let status = PHPhotoLibrary.authorizationStatus()
        
        switch status {
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization({ (status) in
                if status == .authorized {
                    self.getPhoto()
                }
            })
        case .authorized:
            getPhoto()
        default:
            let alertVC = UIAlertController(title: "", message: "请到设置界面开启摄像功能", preferredStyle: .alert)
            alertVC.addAction(UIAlertAction(title: "知道了", style: .default, handler: nil))
            present(alertVC, animated: true, completion: nil)
        }
        
        
    }

    func getPhoto() {
        let picker = UIImagePickerController()
        picker.delegate = self
        present(picker, animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        print(info)
        
        picker.dismiss(animated: true, completion: nil)
        
        guard let img = info[UIImagePickerControllerOriginalImage] as? UIImage,
            let ciimg = CIImage(image: img) else { return }
        
        let detector = CIDetector(ofType: CIDetectorTypeQRCode, context: nil, options: [CIDetectorAccuracy: CIDetectorAccuracyHigh])
        guard let feature = detector?.features(in: ciimg).first as? CIQRCodeFeature else { return }
        textLabel.text = feature.messageString
    }
    
}
