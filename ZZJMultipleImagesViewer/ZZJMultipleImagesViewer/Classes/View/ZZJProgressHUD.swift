//
//  ZZJProgressHUD.swift
//  ZZJMultipleImagesViewer
//
//  Created by ZHONG ZHAOJUN on 2018/3/12.
//  Copyright © 2018年 ZHONG ZHAOJUN. All rights reserved.
//

import UIKit

class ZZJProgressHUD: UIView {

    ///UIActivityIndicatorView
    fileprivate lazy var indicatorView:UIActivityIndicatorView = {
        let indicatorView = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        indicatorView.activityIndicatorViewStyle = .gray
        indicatorView.activityIndicatorViewStyle = .whiteLarge
        indicatorView.backgroundColor = UIColor.lightGray
        indicatorView.center = self.center
        indicatorView.startAnimating()
        return indicatorView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        createView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension ZZJProgressHUD {
    
    fileprivate func createView() {
        backgroundColor = UIColor.yellow
        addSubview(indicatorView)
    }
    
    ///show HUD
    func show() {
        indicatorView.startAnimating()
    }
    
    ///show HUD with duration, default is 3s
    func showWithDuration(duration: TimeInterval = 3) {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + duration) {
            DispatchQueue.global(qos: .default).async {
                self.indicatorView.stopAnimating()
            }
        }
    }
    
    ///hide HUD
    func hide() {
        indicatorView.stopAnimating()
    }
}















