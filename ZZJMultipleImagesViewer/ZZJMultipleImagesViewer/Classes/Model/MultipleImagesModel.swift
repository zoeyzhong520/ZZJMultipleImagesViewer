//
//  MultipleImagesModel.swift
//  ZZJMultipleImagesViewer
//
//  Created by ZHONG ZHAOJUN on 2018/2/28.
//  Copyright © 2018年 ZHONG ZHAOJUN. All rights reserved.
//

import UIKit

class MultipleImagesModel: NSObject {

    var image:UIImage?
    
    ///创建model的方法
    class func createModel(image: UIImage?) -> MultipleImagesModel {
        let model = MultipleImagesModel()
        model.image = image
        return model
    }
}
