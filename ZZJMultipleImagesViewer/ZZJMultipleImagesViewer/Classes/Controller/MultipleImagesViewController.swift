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
        setZZJMultipleImagesContentView()
    }
    
    ///set ZZJMultipleImagesContentView
    fileprivate func setZZJMultipleImagesContentView() {
        
        var imagesArray = [MultipleImagesModel]()
        for i in 0..<6 {
            let model = MultipleImagesModel.createModel(image: UIImage(named: "\(i+1).jpg"))
            imagesArray.append(model)
        }
        
        let multipleImagesView = ZZJMultipleImagesContentView(frame: self.view.bounds, imagesArray: imagesArray)
        view.addSubview(multipleImagesView)
    }
}











