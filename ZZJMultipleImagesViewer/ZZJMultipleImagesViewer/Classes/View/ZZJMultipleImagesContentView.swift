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
    
    ///currentImageView
    private var currentImageView:UIImageView!
    
    ///currentImageViewOldFrame 图片原来的大小
    private var currentImageViewOldFrame: CGRect!
    
    ///currentImageViewLargeFrame 图片放大最大的程度
    private var currentImageViewLargeFrame: CGRect!
    
    ///oldFrameArray 保存图片原来的大小的数组
    private var oldFrameArray = [CGRect]()
    
    ///largeFrameArray 保存确定图片放大最大的程度的数组
    private var largeFrameArray = [CGRect]()
    
    ///currentIndexOfImage 当前是第几张
    private var currentIndexOfImage:Int = 0
    
    ///imageViewArray 存放imageView的数组
    private var imageViewArray = [UIImageView]()
    
    ///isUnderPinchModel 是否正在缩放
    private var isUnderPinchModel: Bool = false
    
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
                let imageView = UIImageView(frame: CGRect(x: screenWidth * CGFloat(i), y: 0, width: screenWidth, height: screenHeight))
                imageView.contentMode = .scaleAspectFit
                imageView.image = imagesArray[i].image
                
                imageView.isUserInteractionEnabled = true
                imageView.isMultipleTouchEnabled = true
                self.addPinchGestureRecognizer(view: imageView)
                imageView.tag = i
                
                scrollView.addSubview(imageView)
                
                //给相应的数组赋值
                imageViewArray.append(imageView)
                oldFrameArray.append(imageView.frame)
                /*
                 这里计算图片放大最大的程度，是因为UIImageView是放在UIScrollView上面滚动，所以横坐标的值要从当前图片的前一张的起点算起（若是第一张，就从屏幕外算起）
                 */
                let tmpLargeFrame = CGRect(x: screenWidth * CGFloat(i) - screenWidth, y: 0 - screenHeight, width: imageView.frame.size.width * CGFloat(3), height: imageView.frame.size.height * CGFloat(3))
                largeFrameArray.append(tmpLargeFrame)
            }
        }
    }
    
    //MARK: - 添加单击手势
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
    
    //MARK: 添加移动手势
    ///添加移动手势
    fileprivate func addPanGestuerRecognizer(view: UIView) {
        view.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(panAction(pan:))))
    }
    
    ///移除移动手势
    fileprivate func minusPanGestureRecognizer(view: UIView) {
        view.gestureRecognizers?.forEach({ (gesture) in
            if gesture == UIPanGestureRecognizer() {
                view.removeGestureRecognizer(gesture)
            }
        })
        
        print(view.gestureRecognizers)
    }
    
    //MARK: - 处理单击手势
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
//        print(#function)
        
        guard let view = pinch.view else { return }
        if pinch.state == .began || pinch.state == .changed {
            
            //禁止UIScrollView滚动
            scrollView.isScrollEnabled = false
            
            //设置正在缩放状态
            isUnderPinchModel = true
            
            view.transform = view.transform.scaledBy(x: pinch.scale, y: pinch.scale)
            
            currentImageView = imageViewArray[currentIndexOfImage]
            currentImageViewOldFrame = oldFrameArray[currentIndexOfImage]
            currentImageViewLargeFrame = largeFrameArray[currentIndexOfImage]
            
//            self.addPanGestuerRecognizer(view: currentImageView)
            
            if currentImageView.frame.size.width < currentImageViewOldFrame.size.width {
                currentImageView.frame = currentImageViewOldFrame
            }
            
            if currentImageView.frame.size.width > currentImageViewOldFrame.size.width * CGFloat(3) {
                currentImageView.frame = currentImageViewLargeFrame
            }
            
            if currentImageView.frame.size.width == currentImageViewOldFrame.size.width {
                //恢复UIScrollView滚动
                scrollView.isScrollEnabled = true
                
                //取消正在缩放状态
                isUnderPinchModel = false
                
                self.minusPanGestureRecognizer(view: currentImageView)
            }
            pinch.scale = 1
        }
    }
    
    //MARK: 处理移动手势
    @objc fileprivate func panAction(pan: UIPanGestureRecognizer) {
        
        guard let view = pan.view else { return }
        if pan.state == .began || pan.state == .changed {
            let translation = pan.translation(in: view.superview)
            view.center = CGPoint(x: view.center.x + translation.x, y: view.center.y + translation.y)
            pan.setTranslation(.zero, in: view.superview)
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














