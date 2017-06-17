//
//  ViewController.swift
//  ORCode
//
//  Created by lixiangzhou on 2017/6/17.
//  Copyright © 2017年 lixiangzhou. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBAction func qrcodeGenerate(_ sender: Any) {
        navigationController?.pushViewController(QRCodeGenerateController(), animated: true)
    }



    @IBAction func qrcodeScan(_ sender: Any) {
        
        
    }

}

