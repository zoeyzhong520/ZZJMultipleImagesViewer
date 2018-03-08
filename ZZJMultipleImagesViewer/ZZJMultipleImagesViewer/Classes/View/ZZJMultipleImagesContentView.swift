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
    
    ///currentIndexOfImage 当前是第几张
    private var currentIndexOfImage:Int = 0
    
    ///imageViewArray 存放imageView的数组
    private var imageViewArray = [UIImageView]()
    
    ///scrollViewArray 存放scrollView的数组
    private var scrollViewArray = [UIScrollView]()
    
    ///UIScrollView 滚动偏移量
    private var lastContentOffset:CGPoint!
    
    ///isMaxScale 是否放大到最大限度
    private var isMaxScale = false
    
    ///maxScale 放大的最大限度
    private var maxScale:CGFloat = 2.0
    
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
        
        self.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.4)
        self.frame = CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight)
        
        if scrollView == nil {
            DebugPrint(message: "imagesArray: \(imagesArray)")
            //scrollView
            scrollView = UIScrollView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight))
            scrollView.backgroundColor = UIColor.black
            scrollView.isUserInteractionEnabled = true
            scrollView.isPagingEnabled = true
            scrollView.delegate = self
            
//            self.addSwipeGestureRecognizer(view: scrollView)
            
            addSubview(scrollView)
            scrollView.contentSize = CGSize(width: screenWidth * CGFloat(imageCount), height: screenHeight)
            
            //imageView
            for i in 0..<imageCount {
                let bgScrollView = UIScrollView(frame: CGRect(x: screenWidth * CGFloat(i), y: 0, width: screenWidth, height: screenHeight))
                bgScrollView.delegate = self
                bgScrollView.maximumZoomScale = maxScale
                bgScrollView.minimumZoomScale = 1
                scrollView.addSubview(bgScrollView)
                
                let imageView = UIImageView(frame: bgScrollView.bounds)
                imageView.contentMode = .scaleAspectFit
                imageView.image = imagesArray[i].image
                
                imageView.isUserInteractionEnabled = true
                imageView.isMultipleTouchEnabled = true
                imageView.tag = i
                self.addTapGestureRecognizer(view: imageView)
                bgScrollView.addSubview(imageView)
                
                guard let image = imageView.image else { return }
                
                if i > 0 {
                    //设置UIScrollView的滚动范围和图片的真实尺寸一致
                    bgScrollView.contentSize = CGSize(width: image.size.width, height: 0)
                }
                
                //给相应的数组赋值
                imageViewArray.append(imageView)
                scrollViewArray.append(bgScrollView)
            }
        }
    }
    
    //MARK: - 添加手势
    ///添加单击手势
    fileprivate func addTapGestureRecognizer(view: UIView) {
        let singleTap = UITapGestureRecognizer(target: self, action: #selector(tapAction))
        singleTap.numberOfTapsRequired = 1
        view.addGestureRecognizer(singleTap)
        
        let doubleTap = UITapGestureRecognizer(target: self, action: #selector(doubleTapAction))
        doubleTap.numberOfTapsRequired = 2
        view.addGestureRecognizer(doubleTap)
        
        //只有当doubleTapGesture识别失败的时候(即识别出这不是双击操作)，singleTapGesture才能开始识别
        singleTap.require(toFail: doubleTap)
    }
    
    ///添加下滑手势
    fileprivate func addSwipeGestureRecognizer(view: UIView) {
        let swipe = UISwipeGestureRecognizer(target: self, action: #selector(swipeDownAction))
        swipe.direction = .down
        view.addGestureRecognizer(swipe)
    }
    
    //MARK: - 处理手势
    @objc fileprivate func tapAction() {
        DebugPrint(message: #function)
        
        disMissView()
    }
    
    @objc fileprivate func swipeDownAction() {
        DebugPrint(message: #function)
        
        disMissView()
    }
    
    @objc fileprivate func doubleTapAction() {
        DebugPrint(message: #function)
        
        if !isMaxScale {
            isMaxScale = true
            scrollViewArray[currentIndexOfImage].setZoomScale(maxScale, animated: true)
        } else {
            isMaxScale = false
            scrollViewArray[currentIndexOfImage].setZoomScale(1.0, animated: true)
        }
    }
    
    //MARK: - 展示图片查看器
    func showInView(view: UIView?) {
        if view == nil {
            return
        }
        
        view?.addSubview(self)
        view?.addSubview(scrollView)
        
        scrollView.alpha = 0.0
        UIView.animate(withDuration: 0.3, animations: {
            self.scrollView.alpha = 1.0
        }, completion: nil)
    }
    
    //MARK: 隐藏图片查看器
    fileprivate func disMissView() {
        scrollView.alpha = 1.0
        UIView.animate(withDuration: 0.3, animations: {
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
        DebugPrint(message: #function)
        if scrollView == self.scrollView {
            lastContentOffset = scrollView.contentOffset
        }
    }
    
    func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
        DebugPrint(message: #function)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        DebugPrint(message: #function)
        
        if scrollView == self.scrollView {
            //currentIndexOfImage
            currentIndexOfImage = Int(scrollView.contentOffset.x / screenWidth)
            DebugPrint(message: "当前是第\(currentIndexOfImage+1)张图片～")
            scrollViewArray[currentIndexOfImage].setZoomScale(1.0, animated: true)
            isMaxScale = false
        }
        
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if scrollView == scrollViewArray[currentIndexOfImage] {
            
//            let offSet = scrollView.contentOffset
//            DebugPrint(message: "offSet: \(offSet)")
//            DebugPrint(message: "scrollView.contentSize: \(scrollView.contentSize)")
            
        } else if scrollView == self.scrollView {
            
            let offSet = scrollView.contentOffset
            DebugPrint(message: "offSet: \(offSet)")
            DebugPrint(message: "lastContentOffset: \(lastContentOffset)")
            
            if lastContentOffset == nil {
                return
            }
            
            if lastContentOffset.x < offSet.x {
                //向左滑动
                DebugPrint(message: "向左滑动")
                
                
            } else {
                //向右滑动
                DebugPrint(message: "向右滑动")
                
                
            }
        }
        
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        DebugPrint(message: #function)
    }
    
    //代理方法，告诉ScrollView要缩放的是哪个视图
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageViewArray[currentIndexOfImage]
    }
    
    func scrollViewDidEndZooming(_ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat) {
        if scrollView == scrollViewArray[currentIndexOfImage] {
            scrollView.setZoomScale(scale, animated: true)
        }
    }
}














