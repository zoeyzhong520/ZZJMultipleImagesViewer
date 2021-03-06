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
    var url:String?
    var imageType:ImageType?
    
    var desc:String?
    
    ///创建model的方法
    class func createModel(image: UIImage?, url: String?, imageType: ImageType?, desc: String?) -> MultipleImagesModel {
        let model = MultipleImagesModel()
        model.image = image
        model.url = url
        model.imageType = imageType
        
        model.desc = desc
        return model
    }
}
