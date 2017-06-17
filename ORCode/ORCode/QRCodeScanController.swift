//
//  QRCodeScanController.swift
//  ORCode
//
//  Created by lixiangzhou on 2017/6/17.
//  Copyright © 2017年 lixiangzhou. All rights reserved.
//

import UIKit
import AVFoundation

class QRCodeScanController: UIViewController {

    var imgView: UIImageView!
    
    var session = AVCaptureSession()
    
    weak var previewLayer: AVCaptureVideoPreviewLayer?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.white
        
        let wh = view.bounds.width - 60
        
        imgView = UIImageView(frame: CGRect(x: 30, y: 80, width: wh, height: wh))
        imgView.layer.borderColor = UIColor.red.cgColor
        imgView.layer.borderWidth = 1
        
        view.addSubview(imgView)
        
        scan()
    }
    
    func scan() {
        // 获取摄像头
        let device = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo)
        // 把摄像头作为输入设备
        guard let input = try? AVCaptureDeviceInput(device: device) else { return }
        
        // 输出设置
        let output = AVCaptureMetadataOutput()
        output.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
        
        if session.canAddInput(input) == false && session.canAddOutput(output) == false { return }
        
        session.addInput(input)
        session.addOutput(output)
        
        output.metadataObjectTypes = [AVMetadataObjectTypeQRCode]
        
        let width = view.bounds.width
        let height = view.bounds.height
        
        let x = imgView.frame.origin.x / width
        let y = imgView.frame.origin.y / height
        let w = imgView.frame.size.width / width
        let h = imgView.frame.size.height / height
        
        output.rectOfInterest = CGRect(x: y, y: x, width: h, height: w)
        
        let layer = AVCaptureVideoPreviewLayer(session: session)
        layer?.frame = view.layer.bounds
        view.layer.insertSublayer(layer!, at: 0)
        previewLayer = layer
        
        session.startRunning()
    }

    deinit {
        print("QRCodeScanController deinit")
    }
}

extension QRCodeScanController: AVCaptureMetadataOutputObjectsDelegate {
    func captureOutput(_ captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [Any]!, from connection: AVCaptureConnection!) {
        for item in metadataObjects {
            print((item as! AVMetadataMachineReadableCodeObject).stringValue)
        }
    }
}
