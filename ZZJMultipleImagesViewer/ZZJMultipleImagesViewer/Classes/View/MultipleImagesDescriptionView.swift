//
//  MultipleImagesDescriptionView.swift
//  ZZJMultipleImagesViewer
//
//  Created by ZHONG ZHAOJUN on 2018/3/16.
//  Copyright © 2018年 ZHONG ZHAOJUN. All rights reserved.
//

import UIKit

class MultipleImagesDescriptionView: UIView {

    ///model
    var model:MultipleImagesModel?
    
    //MARK: Lazy
    
    ///label
    lazy var label:UILabel = {
        let label = UILabel(text: "", font: ZZJ_systemFontWith(14), textColor: UIColor.white, textAlignment: .center, numberOfLines: 3)
        label.backgroundColor = UIColor.red
        label.lineBreakMode = .byTruncatingTail
        return label
    }()
    
    override func draw(_ rect: CGRect) {
//        self.backgroundColor = RGBA(0, 0, 0, 0.2)
        self.backgroundColor = UIColor.white
    }

    init(frame: CGRect, model:MultipleImagesModel?) {
        super.init(frame: frame)
        self.model = model
        createView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension MultipleImagesDescriptionView {
    
    fileprivate func createView() {
        
        //label
        label.text = model?.desc
        self.addSubview(label)
        label.ZZJ_setLineSpace(withLineSpace: 12, withAlignment: .center, withLabelText: model?.desc == nil ? "" : (model?.desc)!, withFont: ZZJ_systemFontWith(14), withZSpace: 5)
        
        //添加约束
        label.translatesAutoresizingMaskIntoConstraints = false
        
        //1.上边约束
        let top:NSLayoutConstraint = NSLayoutConstraint(item: label, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1.0, constant: 16)
        self.addConstraint(top)
        
        //2.左边约束
        let left:NSLayoutConstraint = NSLayoutConstraint(item: label, attribute: .left, relatedBy: .equal, toItem: self, attribute: .left, multiplier: 1.0, constant: 16)
        self.addConstraint(left)
        
        //3.下边约束
        let bottom:NSLayoutConstraint = NSLayoutConstraint(item: label, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1.0, constant: -16)
        self.addConstraint(bottom)
        
        //4.右边约束
        let right:NSLayoutConstraint = NSLayoutConstraint(item: label, attribute: .right, relatedBy: .equal, toItem: self, attribute: .right, multiplier: 1.0, constant: -16)
        self.addConstraint(right)
    }
    
    ///获取View的高度
    class func getViewHeight(withModel model: MultipleImagesModel?) -> CGFloat {
        
        let viewHeight = UILabel().ZZJ_getSpaceLabelHeight(withText: model?.desc == nil ? "" : (model?.desc)!, withFont: ZZJ_systemFontWith(14), withAlignment: .center, withWidth: screenWidth - 14*2, withLineSpace: 12, withZSpace: 5)
        return viewHeight
    }
}




