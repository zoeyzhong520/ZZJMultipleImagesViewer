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
    }
    
    ///set UIButton 设置按钮
    fileprivate func setButtons() {
        let button = UIButton(type: .system)
        button.setTitle("点击加载图片查看器", for: .normal)
        button.frame = CGRect(x: 0, y: screenHeight / 2, width: screenWidth, height: 100)
        button.backgroundColor = UIColor.gray
        button.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        view.addSubview(button)
    }
    
    ///buttonAction
    @objc fileprivate func buttonAction() {
        print(#function)
        setZZJMultipleImagesContentView()
    }
    
    ///set ZZJMultipleImagesContentView
    fileprivate func setZZJMultipleImagesContentView() {
        
        var imagesArray = [MultipleImagesModel]()
        for i in 0..<6 {
            let model = MultipleImagesModel.createModel(image: UIImage(named: "\(i+1).jpg"))
            imagesArray.append(model)
        }
        
        let multipleImagesView = ZZJMultipleImagesContentView(frame: .zero, imagesArray: imagesArray)
        multipleImagesView.showInView(view: ZZJKeyWindow)
    }
}











