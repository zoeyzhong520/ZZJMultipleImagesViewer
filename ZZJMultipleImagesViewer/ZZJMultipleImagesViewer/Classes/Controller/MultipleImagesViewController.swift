//
//  MultipleImagesViewController.swift
//  ZZJMultipleImagesViewer
//
//  Created by ZHONG ZHAOJUN on 2018/2/28.
//  Copyright © 2018年 ZHONG ZHAOJUN. All rights reserved.
//

import UIKit

class MultipleImagesViewController: BaseViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setPage()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension MultipleImagesViewController {
    
    fileprivate func setPage() {
        self.navigationController?.navigationBar.isHidden = true
        title = "多图查看器"
        setButtons()
        setImageView()
    }
    
    ///set UIButton 设置按钮
    fileprivate func setButtons() {
        let button = UIButton(type: .system)
        button.setTitleColor(UIColor.white, for: .normal)
        button.setTitle("点击加载图片查看器", for: .normal)
        button.frame = CGRect(x: 0, y: (screenHeight - 100) / 2, width: screenWidth, height: 100)
        button.backgroundColor = HexColor("ff99ff")
        button.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        view.addSubview(button)
    }
    
    ///set UIImageView
    fileprivate func setImageView() {
        let imageView = UIImageView(frame: CGRect(x: 0, y: (screenHeight - 100) / 2 + 130, width: screenWidth, height: screenWidth * 0.618))
        imageView.image = UIImage(named: "1.jpg")
        imageView.contentMode = .scaleAspectFit
        view.addSubview(imageView)
    }
    
    ///buttonAction
    @objc fileprivate func buttonAction() {
        DebugPrint(message: #function)
        setZZJMultipleImagesContentView()
    }
    
    ///set ZZJMultipleImagesContentView
    fileprivate func setZZJMultipleImagesContentView() {
        
        var imagesArray = [MultipleImagesModel]()
        for i in 0..<6 {
            let model = MultipleImagesModel.createModel(image: UIImage(named: "\(i+1).jpg"), url: nil)
            imagesArray.append(model)
        }
//        //http://phone.seedu.me/float_img/migu.png
//        let model = MultipleImagesModel.createModel(image: nil, url: "http://phone.seedu.me/float_img/migu.png")
//        imagesArray.append(model)
        
        let multipleImagesView = ZZJMultipleImagesContentView(frame: .zero, imagesArray: imagesArray)
        multipleImagesView.showInView(view: ZZJKeyWindow)
    }
}











