//
//  ZZJMultipleImagesContentView.swift
//  ZZJMultipleImagesViewer
//
//  Created by ZHONG ZHAOJUN on 2018/2/28.
//  Copyright © 2018年 ZHONG ZHAOJUN. All rights reserved.
//

import UIKit

class ZZJMultipleImagesContentView: UIView {

    ///scrollView
    private var scrollView:UIScrollView!
    
    ///imagesArray 图片数组
    private var imagesArray = [MultipleImagesModel]()
    
    ///image的数量
    private var imageCount:Int = 0
    
    ///imageView
    private var imageView:UIImageView!
    
    init(frame: CGRect, imagesArray:[MultipleImagesModel]) {
        super.init(frame: frame)
        self.imagesArray = imagesArray
        //imageCount
        imageCount = imagesArray.count
        createView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension ZZJMultipleImagesContentView {
    
    ///createView
    fileprivate func createView() {
        print("imagesArray: \(imagesArray)")
        //scrollView
        scrollView = UIScrollView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight))
        scrollView.backgroundColor = UIColor.black
        scrollView.isUserInteractionEnabled = true
        scrollView.isPagingEnabled = true
        scrollView.delegate = self
        scrollView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapAction)))
        addSubview(scrollView)
        scrollView.contentSize = CGSize(width: screenWidth * CGFloat(imageCount), height: screenHeight)
        
        //imageView
        for i in 0..<imageCount {
            imageView = UIImageView(frame: CGRect(x: screenWidth * CGFloat(i), y: 0, width: screenWidth, height: screenHeight))
            imageView.contentMode = .scaleAspectFit
            imageView.image = imagesArray[i].image
            scrollView.addSubview(imageView)
        }
    }
    
    //MARK: 处理单击手势
    @objc fileprivate func tapAction() {
        print(#function)
    }
}

//MARK: - UIScrollViewDelegate
extension ZZJMultipleImagesContentView: UIScrollViewDelegate {
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        print(#function)
    }
    
    func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
        print(#function)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        print(#function)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        print(#function)
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        print(#function)
    }
}














