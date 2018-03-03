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
    
    ///oldFrame 保存图片原来的大小
    private var oldFrame: CGRect!
    
    ///largeFrame 确定图片放大最大的程度
    private var largeFrame: CGRect!
    
    ///currentIndexOfImage 当前是第几张
    private var currentIndexOfImage:Int = 0
    
    ///imageViewArray 存放imageView的数组
    private var imageViewArray = [UIImageView]()
    
    init(frame: CGRect, imagesArray:[MultipleImagesModel]) {
        super.init(frame: frame)
        self.imagesArray = imagesArray
        //imageCount
        imageCount = imagesArray.count
//        imageCount = 1
        createView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension ZZJMultipleImagesContentView {
    
    ///createView
    fileprivate func createView() {
        
        self.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.4)
        self.frame = CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight)
        
        if scrollView == nil {
            print("imagesArray: \(imagesArray)")
            //scrollView
            scrollView = UIScrollView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight))
            scrollView.backgroundColor = UIColor.black
            scrollView.isUserInteractionEnabled = true
            scrollView.isPagingEnabled = true
            scrollView.delegate = self
            
            self.addTapGestureRecognizer(view: scrollView)
//            self.addSwipeGestureRecognizer(view: scrollView)
            
            addSubview(scrollView)
            scrollView.contentSize = CGSize(width: screenWidth * CGFloat(imageCount), height: screenHeight)
            
            //imageView
            for i in 0..<imageCount {
                imageView = UIImageView(frame: CGRect(x: screenWidth * CGFloat(i), y: 0, width: screenWidth, height: screenHeight))
                oldFrame = imageView.frame
                largeFrame = CGRect(x: -screenWidth, y: -screenHeight, width: oldFrame.size.width * CGFloat(3), height: oldFrame.size.height * CGFloat(3))
                imageView.contentMode = .scaleAspectFit
                imageView.image = imagesArray[i].image
                
                imageView.isUserInteractionEnabled = true
                self.addPinchGestureRecognizer(view: imageView)
                imageView.tag = i
                
                scrollView.addSubview(imageView)
                imageViewArray.append(imageView)
            }
        }
    }
    
    //MARK: 添加单击手势
    ///添加单击手势
    fileprivate func addTapGestureRecognizer(view: UIView) {
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapAction)))
    }
    
    //MARK: 添加下滑手势
    ///添加下滑手势
    fileprivate func addSwipeGestureRecognizer(view: UIView) {
        let swipe = UISwipeGestureRecognizer(target: self, action: #selector(swipeDownAction))
        swipe.direction = .down
        view.addGestureRecognizer(swipe)
    }
    
    //MARK: 添加缩放手势
    ///添加缩放手势
    fileprivate func addPinchGestureRecognizer(view: UIView) {
        view.addGestureRecognizer(UIPinchGestureRecognizer(target: self, action: #selector(pinchAction(pinch:))))
    }
    
    //MARK: 处理单击手势
    @objc fileprivate func tapAction() {
        print(#function)
        
        disMissView()
    }
    
    //MARK: 处理下滑手势
    @objc fileprivate func swipeDownAction() {
        print(#function)
        
        disMissView()
    }
    
    //MARK: 处理缩放手势
    @objc fileprivate func pinchAction(pinch: UIPinchGestureRecognizer) {
        print(#function)
        
        guard let view = pinch.view else { return }
        if pinch.state == .began || pinch.state == .changed {
            view.transform = view.transform.scaledBy(x: pinch.scale, y: pinch.scale)
            
            if imageView.frame.size.width < oldFrame.size.width {
                imageView.frame = oldFrame
            }
            
            if imageView.frame.size.width > oldFrame.size.width * CGFloat(3) {
                imageView.frame = largeFrame
            }
            
            pinch.scale = 1
            
        }
        
    }
    
    //MARK: 展示图片查看器
    func showInView(view: UIView?) {
        if view == nil {
            return
        }
        
        view?.addSubview(self)
        view?.addSubview(scrollView)
        
        scrollView.alpha = 0.0
        UIView.animate(withDuration: 0.5, animations: {
            self.scrollView.alpha = 1.0
        }, completion: nil)
    }
    
    //MARK: 隐藏图片查看器
    fileprivate func disMissView() {
        scrollView.alpha = 1.0
        UIView.animate(withDuration: 0.5, animations: {
            self.scrollView.alpha = 0.0
        }) { (finished) in
            self.removeFromSuperview()
            self.scrollView.removeFromSuperview()
        }
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
        
        //currentIndexOfImage
        currentIndexOfImage = Int(scrollView.contentOffset.x / screenWidth)
        print("当前是第\(currentIndexOfImage+1)张图片～")
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        print(#function)
        
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        print(#function)
    }
}














