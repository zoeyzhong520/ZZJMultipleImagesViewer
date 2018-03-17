//
//  UILabel+Util.swift
//  ReadBook
//
//  Created by JOE on 2017/7/17.
//  Copyright © 2017年 Hongyear Information Technology (Shanghai) Co.,Ltd. All rights reserved.
//

import UIKit

extension UILabel {
    
    convenience init(text:String?=nil, font:UIFont?=nil, textColor:UIColor?=nil, textAlignment:NSTextAlignment?=nil, masksToBounds:Bool?=nil, cornerRadius:CGFloat?=nil, borderColor:UIColor?=nil, borderWidth:CGFloat?=nil, adjustsFontSizeToFitWidth:Bool?=nil, numberOfLines: Int?=nil) {
        
        self.init()
        
        if let tmpText = text {
            self.text = tmpText
        }
        
        if let tmpFont = font {
            self.font = tmpFont
        }
        
        if let tmpTextColor = textColor {
            self.textColor = tmpTextColor
        }
        
        if let tmpTextAligment = textAlignment {
            self.textAlignment = tmpTextAligment
        }
        
        if let tempAdjustsFontSizeToFitWidth = adjustsFontSizeToFitWidth {
            self.adjustsFontSizeToFitWidth = tempAdjustsFontSizeToFitWidth
        }
        
        if let tempNumberOfLines = numberOfLines {
            self.numberOfLines = tempNumberOfLines
        }
        
        if let tempMasksToBounds = masksToBounds {
            self.layer.masksToBounds = tempMasksToBounds
        }
        
        if let tempCornerRadius = cornerRadius {
            self.layer.cornerRadius = tempCornerRadius
        }
        
        if let tempBorderColor = borderColor {
            self.layer.borderColor = tempBorderColor.cgColor
        }
        
        if let tempBorderWidth = borderWidth {
            self.layer.borderWidth = tempBorderWidth
        }
    }
    
    //MARK: 高度自适应
    /**
     *高度自适应
     */
    class func getHeightByWidth(title:String?, width:CGFloat?, font:UIFont?) -> CGFloat {
        
        guard let tempTitle = title else {
            return 0
        }
        
        guard let tempWidth = width else {
            return 0
        }
        
        guard let tempFont = font else {
            return 0
        }
        
        let label = UILabel(text: tempTitle, font: tempFont, textAlignment: .left)
        label.frame = CGRect(x: 0, y: 0, width: tempWidth, height: 0)
        label.numberOfLines = 0
        label.sizeToFit()
        
        let height:CGFloat = label.frame.size.height
        return height
    }
    
    //MARK: 宽度自适应
    /**
     *宽度自适应
     */
    class func getWidthWithTitle(title:String?, height:CGFloat?, font:UIFont?) -> CGFloat {
        
        guard let tempTitle = title else {
            return 0
        }
        
        guard let tempHeight = height else {
            return 0
        }
        
        guard let tempFont = font else {
            return 0
        }
        
        let label = UILabel(text: tempTitle, font: tempFont, textAlignment: .left)
        label.frame = CGRect(x: 0, y: 0, width: 0, height: tempHeight)
        label.sizeToFit()
        
        let width:CGFloat = label.frame.size.width
        return width
    }
    
    //MARK: UILabel设置不同字体属性
    /**
     *UILabel设置不同字体属性
     */
    func appendAttributedString(string: String?, targetString: String?, font: UIFont?, textColor: UIColor?) {
        
        if let tempString = string, let tempTargetString = targetString, let tempFont = font, let tempTextColor = textColor {
            
            let attributedString = NSMutableAttributedString(string: tempString)
            let attributedChildString = attributedString.string as NSString
            
            let range = NSMakeRange(attributedChildString.range(of: tempTargetString).location, attributedChildString.range(of: tempTargetString).length)
            
            attributedString.addAttributes([NSAttributedStringKey.font:tempFont, NSAttributedStringKey.foregroundColor: tempTextColor], range: range)
            self.attributedText = attributedString
            self.sizeToFit()
        }
    }
    
    //MARK: 计算UILabel的行数
    ///计算UILabel的行数
    /// - Parameters:
    ///   - str: 内容
    ///   - font: 字体
    ///   - lineSpace: 行间距
    ///   - WordSpace: 字间距
    ///   - width: 宽度
    func numberOfText(str: String, font: UIFont, lineSpace: CGFloat, WordSpace: CGFloat, width: CGFloat) -> Int {
        let paraStyle = NSMutableParagraphStyle()
        paraStyle.lineBreakMode = .byCharWrapping
        paraStyle.alignment = .left
        paraStyle.lineSpacing = lineSpace
        paraStyle.hyphenationFactor = 1.0
        paraStyle.firstLineHeadIndent = 0.0
        paraStyle.paragraphSpacingBefore = 0.0
        paraStyle.headIndent = 0.0
        paraStyle.tailIndent = 0.0
        
        //设置字间距 NSKernAttributeName:@1.5f
        var dic = [NSAttributedStringKey:Any]()
        if WordSpace == 0 {
            dic = [.font:font, .paragraphStyle:paraStyle, .kern:NSNumber.init(value: 1.5)]
        }else{
            dic = [.font:font, .paragraphStyle: paraStyle, .kern: NSNumber.init(value: Float(WordSpace))]
        }
        
        var options = NSStringDrawingOptions()
        options = [.usesLineFragmentOrigin, .usesFontLeading]
        let size = (str as NSString).boundingRect(with: CGSize(width: width, height: CGFloat(MAXFLOAT)), options: options, attributes: dic, context: nil).size
        let singleSize = (str as NSString).size(withAttributes: dic)
        return Int(ceil(size.height / singleSize.height))
    }
    
    //MARK: 计算UILabel的单行的高度
    ///计算UILabel的单行的高度
    /// - Parameters:
    ///   - str: 内容
    ///   - font: 字体
    ///   - lineSpace: 行间距
    ///   - WordSpace: 字间距
    ///   - width: 宽度
    func singleSize(str: String, font: UIFont, lineSpace: CGFloat, WordSpace: CGFloat, width: CGFloat) -> CGFloat {
        let paraStyle = NSMutableParagraphStyle()
        paraStyle.lineBreakMode = .byCharWrapping
        paraStyle.alignment = .left
        paraStyle.lineSpacing = lineSpace
        paraStyle.hyphenationFactor = 1.0
        paraStyle.firstLineHeadIndent = 0.0
        paraStyle.paragraphSpacingBefore = 0.0
        paraStyle.headIndent = 0.0
        paraStyle.tailIndent = 0.0
        
        //设置字间距 NSKernAttributeName:@1.5f
        var dic = [NSAttributedStringKey:Any]()
        if WordSpace == 0 {
            dic = [.font: font, .paragraphStyle: paraStyle, .kern: NSNumber.init(value: 1.5)]
        }else{
            dic = [.font: font, .paragraphStyle: paraStyle, .kern: NSNumber.init(value: Float(WordSpace))]
        }
        
        let singleSize = (str as NSString).size(withAttributes: dic)
        return singleSize.height
    }
    
    //MARK: 给UILabel设置行间距和字间距
    ///给UILabel设置行间距和字间距
    /// - Parameters:
    ///   - lineSpace: 行间距
    ///   - alignment: 文本对齐方式
    ///   - labelText: 内容
    ///   - font: 字体
    ///   - ZSapce: 字间距
    ///   - lineBreakMode: 文本换行方式
    func ZZJ_setLineSpace(withLineSpace lineSpace: CGFloat, withAlignment alignment: NSTextAlignment = NSTextAlignment.left, withLabelText labelText: String, withFont font: UIFont, withZSpace ZSapce: CGFloat, withLineBreakMode lineBreakMode: NSLineBreakMode = .byCharWrapping) {
        
        let paraStyle = NSMutableParagraphStyle()
        paraStyle.lineBreakMode = lineBreakMode
        paraStyle.alignment = alignment
        paraStyle.lineSpacing = lineSpace //设置行间距
        paraStyle.hyphenationFactor = 1.0
        paraStyle.firstLineHeadIndent = 0.0
        paraStyle.paragraphSpacingBefore = 0.0
        paraStyle.headIndent = 0.0
        paraStyle.tailIndent = 0.0
        
        //设置字间距 NSKernAttributeName:@1.5f
        var dic = [NSAttributedStringKey:Any]()
        if ZSapce == 0 {
            dic = [.font: font, .paragraphStyle: paraStyle, .kern: NSNumber.init(value: 1.5)]
        } else {
            dic = [.font: font, .paragraphStyle: paraStyle, .kern: NSNumber.init(value: Float(ZSapce))]
        }
        
        let attributeStr = NSAttributedString(string: labelText, attributes: dic)
        self.attributedText = attributeStr
    }
    
    //MARK: 计算UILabel的高度(带有行间距的情况)
    ///计算UILabel的高度(带有行间距的情况)
    /// - Parameters:
    ///   - text: 内容
    ///   - font: 字体
    ///   - alignment: 文本对齐方式
    ///   - width: 宽度
    ///   - lineSpace: 行间距
    ///   - ZSapce: 字间距
    ///   - lineBreakMode: 文本换行方式
    func ZZJ_getSpaceLabelHeight(withText text: String, withFont font: UIFont, withAlignment alignment: NSTextAlignment = NSTextAlignment.left, withWidth width: CGFloat, withLineSpace lineSpace: CGFloat, withZSpace ZSapce: CGFloat, withLineBreakMode lineBreakMode: NSLineBreakMode = .byCharWrapping) -> CGFloat {
        
        let paraStyle = NSMutableParagraphStyle()
        paraStyle.lineBreakMode = lineBreakMode
        paraStyle.alignment = alignment
        paraStyle.lineSpacing = lineSpace
        paraStyle.hyphenationFactor = 1.0
        paraStyle.firstLineHeadIndent = 0.0
        paraStyle.paragraphSpacingBefore = 0.0
        paraStyle.headIndent = 0.0
        paraStyle.tailIndent = 0.0
        
        //设置字间距 NSKernAttributeName:@1.5f
        var dic = [NSAttributedStringKey:Any]()
        if ZSapce == 0 {
            dic = [.font: font, .paragraphStyle: paraStyle, .kern: NSNumber.init(value: 1.5)]
        } else {
            dic = [.font: font, .paragraphStyle: paraStyle, .kern: NSNumber.init(value: Float(ZSapce))]
        }
        
        var options = NSStringDrawingOptions()
        options = [.usesLineFragmentOrigin, .usesFontLeading]
        let size = (text as NSString).boundingRect(with: CGSize(width: width, height: CGFloat(MAXFLOAT)), options: options, attributes: dic, context: nil).size
        return size.height
    }
    
    //MARK: 首行缩进 计算字符串高度
    ///首行缩进 计算字符串高度
    /// - Parameters:
    ///   - text: 内容
    ///   - font: 字体
    ///   - firstLineHeadIndent: 首行缩进宽度
    ///   - indentationNum: 要缩进几个字符
    ///   - textAlignment: 对齐方式
    ///   - fontSize: 字体大小
    ///   - width: 宽度
    ///   - lineSpace: 行间距
    ///   - ZSapce: 字间距
    func ZZJ_getIndentationLabelHeight(withText text: String, withFont font: UIFont, withfirstLineHeadIndent firstLineHeadIndent: CGFloat = 0, withStrIndentationNum indentationNum: Int = 0, withNSTextAlignment textAlignment: NSTextAlignment, withFontSize fontSize: CGFloat = 0.0, withWidth width: CGFloat, withLineSpace lineSpace: CGFloat, withZSpace ZSapce: CGFloat) -> CGFloat {
        
        let paraStyle = NSMutableParagraphStyle()
        paraStyle.lineBreakMode = .byTruncatingTail
        paraStyle.alignment = textAlignment //最后一行如果显示不全则在最后一行末尾使用...
        paraStyle.headIndent = 0.0 //行首缩进
        //参数：（字体大小17号字乘以2，34f即首行空出两个字符）
//        let emptylen = fontSize * CGFloat(indentationNum)
        paraStyle.firstLineHeadIndent = firstLineHeadIndent //首行缩进
        paraStyle.tailIndent = 0.0
        paraStyle.lineSpacing = lineSpace
        paraStyle.hyphenationFactor = 1.0
        paraStyle.paragraphSpacingBefore = 0.0
        
        var dic = [NSAttributedStringKey: Any]()
        if ZSapce == 0 {
            dic = [.font: font, .paragraphStyle: paraStyle, .kern: NSNumber.init(value: 1.5)]
        } else {
            dic = [.font: font, .paragraphStyle: paraStyle, .kern: NSNumber.init(value: Float(ZSapce))]
        }
        
        let attrText = NSAttributedString(string: text, attributes: dic)
        self.attributedText = attrText
        
        let height = self.sizeThatFits(CGSize(width: width, height: CGFloat(MAXFLOAT))).height
        return height
    }
    
    //MARK: UILabel文字对齐
    ///UILabel文字对齐
    func ZZJ_labelTextAlignment() {
        
        if self.text == nil {
            return
        }
        
        let attributeString = NSMutableAttributedString(string: self.text!)
        var dic = [NSAttributedStringKey: Any]()
        dic = [.font: self.font]
        let attributeSize = (attributeString.string as NSString).size(withAttributes: dic)
        let adjustedSize = CGSize(width: attributeSize.width, height: attributeSize.height)
        let size = self.frame.size
        let wordSpace = NSNumber(value: Int((size.width - adjustedSize.width) / CGFloat((attributeString.length - 1))))
        attributeString.addAttribute(NSAttributedStringKey.kern, value: wordSpace, range: NSMakeRange(0, attributeString.length - 1))
        self.attributedText = attributeString
    }
    
    //MARK: 添加图片富文本
    ///添加图片富文本
    /// - Parameters:
    ///   - lineSpace: 行间距
    ///   - labelText: 内容
    ///   - font: 字体
    ///   - ZSapce: 字间距
    ///   - img: 富文本图片
    ///   - attachBounds: 富文本图片 bounds
    ///   - insertIndex: 富文本图片插入的位置
    func ZZJ_setAttachmentWithImg(withLineSpace lineSpace: CGFloat, withLabelText labelText: String, withFont font: UIFont, withZSpace ZSapce: CGFloat, withImg img: UIImage, withAttachBounds attachBounds: CGRect, withInsertIndex insertIndex: Int) {
        
        let paraStyle = NSMutableParagraphStyle()
        paraStyle.lineBreakMode = .byCharWrapping
        paraStyle.alignment = .left
        paraStyle.lineSpacing = lineSpace //设置行间距
        paraStyle.hyphenationFactor = 1.0
        paraStyle.firstLineHeadIndent = 0.0
        paraStyle.paragraphSpacingBefore = 0.0
        paraStyle.headIndent = 0.0
        paraStyle.tailIndent = 0.0
        
        //设置字间距 NSKernAttributeName:@1.5f
        var dic = [NSAttributedStringKey:Any]()
        if ZSapce == 0 {
            dic = [.font: font, .paragraphStyle: paraStyle, .kern: NSNumber.init(value: 1.5)]
        } else {
            dic = [.font: font, .paragraphStyle: paraStyle, .kern: NSNumber.init(value: Float(ZSapce))]
        }
        
        let attributeStr = NSMutableAttributedString(string: labelText, attributes: dic)
        
        //初始化NSTextAttachment对象
        let attach = NSTextAttachment()
        //设置图片
        attach.image = img
        //设置frame
        attach.bounds = attachBounds
        
        // 创建带有图片的富文本
        let attrString = NSAttributedString(attachment: attach)
        //插入到第几个下标
        attributeStr.insert(attrString, at: 0)
        self.attributedText = attributeStr
    }
}

















