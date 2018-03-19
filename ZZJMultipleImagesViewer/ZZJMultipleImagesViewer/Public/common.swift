//
//  common.swift
//  ZZJMultipleImagesViewer
//
//  Created by ZHONG ZHAOJUN on 2018/2/28.
//  Copyright © 2018年 ZHONG ZHAOJUN. All rights reserved.
//

import UIKit

//MARK: - 屏幕宽度、高度
///屏幕宽度
let screenWidth = UIScreen.main.bounds.size.width

///屏幕高度
let screenHeight = UIScreen.main.bounds.size.height

///keyWindow
let zzj_KeyWindow = UIApplication.shared.keyWindow

///RGB
let RGB: (CGFloat, CGFloat, CGFloat) -> UIColor = { r, g, b in
    return UIColor(red: r, green: g, blue: b, alpha: 1.0)
}

///RGBA
let RGBAColor: (CGFloat, CGFloat, CGFloat, CGFloat) -> UIColor = {
    r, g, b, a in
    return UIColor(red: r, green: g, blue: b, alpha: a)
}

///colorWithHexString
let HexColor: (String) -> UIColor = {
    hexString in
    UIColor.colorWithHexString(color: hexString)
}

///colorWithHexString && Alpha
let HexColorAlpha: (String, CGFloat) -> UIColor = {
    hexString, alpha in
    UIColor.colorWithHexString(color: hexString, alpha: alpha)
}

///Debug模式下打印日志
func DebugPrint<T>(message: T, file: String = #file, funciton: String = #function, line: Int = #line) {
    #if DEBUG
        let fileName = (file as NSString).lastPathComponent
        print("\(fileName):\(line) \(funciton) | \(message)")
    #endif
}

///常规字体
let zzj_SystemFontWithSize: (CGFloat) -> UIFont = { font in
    return UIFont.systemFont(ofSize: font)
}

///加粗字体
let zzj_BoldFontWithSize: (CGFloat) -> UIFont = { font in
    return UIFont.boldSystemFont(ofSize: font)
}











