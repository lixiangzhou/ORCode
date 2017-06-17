//
//  QRCodeGenerateController.swift
//  ORCode
//
//  Created by lixiangzhou on 2017/6/17.
//  Copyright © 2017年 lixiangzhou. All rights reserved.
//

import UIKit
import CoreImage

class QRCodeGenerateController: UIViewController {

    var imgView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.white
        
        
        imgView = UIImageView(frame: CGRect(x: 0, y: 64, width: view.bounds.width, height: view.bounds.width))
        
        view.addSubview(imgView)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // "CIQRCodeGenerator" 有两个字段可以设置 inputMessage inputCorrectionLevel
        guard let filter = CIFilter(name: "CIQRCodeGenerator") else { return }
        
        filter.setDefaults()
        
        // 设置输入数据
        guard let data = "http://www.baidu.com".data(using: String.Encoding.utf8) else { return }
        filter.setValue(data, forKey: "inputMessage")
        
        /*
         错误修正容量
         L水平 7%的字码可被修正
         M水平 15%的字码可被修正
         Q水平 25%的字码可被修正
         H水平 30%的字码可被修正
         所以很多二维码的中间都有头像之类的图片但仍然可以识别出来就是这个原因
         */
        filter.setValue("M", forKey: "inputCorrectionLevel")
        
        // 输出数据
        guard var ciimage = filter.outputImage else { return }
        
        /*
         图片放大，生成高清图片
         */
        let transform = CGAffineTransform(scaleX: 30, y: 30)
        ciimage = ciimage.applying(transform)
        
        /*
         1 右下角
         2 左下角
         3 左上角
         4 右上角
         */
        ciimage = ciimage.applyingOrientation(3)
        
        var img = UIImage(ciImage: ciimage)
        // 中间添加一张头像
        img = add(centerImg: UIImage(named: "icon")!, toOriginImg: img)
        
        imgView.image = img
    }
    
    func add(centerImg: UIImage, toOriginImg: UIImage) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(toOriginImg.size, true, 0)
        
        toOriginImg.draw(at: .zero)
        
        let w = toOriginImg.size.width / 4
        let h = toOriginImg.size.height / 4
        let x = (toOriginImg.size.width - w) * 0.5
        let y = (toOriginImg.size.height - h) * 0.5
        
        centerImg.draw(in: CGRect(x: x, y: y, width: w, height: h))
        
        let img = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        return img!
    }

}
