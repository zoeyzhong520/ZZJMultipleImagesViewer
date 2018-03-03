//
//  UIColor+Util.swift
//  ZZJMultipleImagesViewer
//
//  Created by ZHONG ZHAOJUN on 2018/3/3.
//  Copyright © 2018年 ZHONG ZHAOJUN. All rights reserved.
//

import UIKit

extension UIColor {
    
    //MARK: UIColor拓展 -> colorWithHexString
    //color:支持@“#123456”、 @“0X123456”、 @“123456”三种格式
    ///UIColor拓展 -> colorWithHexString
    class func colorWithHexString(color: String, alpha: CGFloat = 1.0) -> UIColor
    {
        
        //删除字符串中的空格
        var cString = (color as NSString).trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).uppercased()
        
        // String should be 6 or 8 characters
        if cString.count < 6 {
            return UIColor.clear
        }
        
        // strip 0X if it appears
        //如果是0x开头的，那么截取字符串，字符串从索引为2的位置开始，一直到末尾
        if cString.hasPrefix("0X") {
            cString = (cString as NSString).substring(from: 2)
        }
        
        //如果是#开头的，那么截取字符串，字符串从索引为1的位置开始，一直到末尾
        if cString.hasPrefix("#") {
            cString = (cString as NSString).substring(from: 1)
        }
        
        if cString.count != 6 {
            return UIColor.clear
        }
        
        // Separate into r, g, b substrings
        var range = NSRange()
        range.location = 0
        range.length = 2
        //r
        let rString = (cString as NSString).substring(with: range)
        //g
        range.location = 2
        let gString = (cString as NSString).substring(with: range)
        //b
        range.location = 4
        let bString = (cString as NSString).substring(with: range)
        
        // Scan values
        var r:CUnsignedInt = 0, g:CUnsignedInt = 0, b:CUnsignedInt = 0
        
        Scanner(string: rString).scanHexInt32(&r)
        Scanner(string: gString).scanHexInt32(&g)
        Scanner(string: bString).scanHexInt32(&b)
        
        return UIColor(red: CGFloat(r) / 255.0, green: CGFloat(g) / 255.0, blue: CGFloat(b) / 255.0, alpha: alpha)
    }
}




















