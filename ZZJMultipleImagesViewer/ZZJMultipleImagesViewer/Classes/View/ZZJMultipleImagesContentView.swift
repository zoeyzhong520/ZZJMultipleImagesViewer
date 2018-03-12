//
//  ZZJMultipleImagesContentView.swift
//  ZZJMultipleImagesViewer
//
//  Created by ZHONG ZHAOJUN on 2018/2/28.
//  Copyright © 2018年 ZHONG ZHAOJUN. All rights reserved.
//

import UIKit
import Kingfisher

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
    
    ///minScale 缩小的最大限度
    private var minScale:CGFloat = 1.0
    
    init(frame: CGRect, imagesArray:[MultipleImagesModel]) {
        super.init(frame: frame)
        self.imagesArray = imagesArray
        //imageCount
        imageCount = imagesArray.count
        currentIndexOfImage = 0
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
            scrollView.bounces = false
            scrollView.isDirectionalLockEnabled = true
            
            addSubview(scrollView)
            scrollView.contentSize = CGSize(width: screenWidth * CGFloat(imageCount), height: screenHeight)
            
            self.configArray()
        }
    }
    
    ///config imageViewArray && scrollViewArray
    fileprivate func configArray() {
        if imageCount == 1 {
            let bgScrollView = UIScrollView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight))
            bgScrollView.delegate = self
            bgScrollView.maximumZoomScale = maxScale
            bgScrollView.minimumZoomScale = minScale
            scrollView.addSubview(bgScrollView)
            
            let imageView = UIImageView(frame: bgScrollView.bounds)
            
            if imagesArray.first?.url == nil {
                imageView.image = imagesArray.first?.image //本地图片
            } else {
                let urlString = URL(string: imagesArray.first?.url == nil ? "" : (imagesArray.first?.url)!)
                let placeHolderImg = UIImage(named: "banner_defaultImg")
                imageView.kf.setImage(with: urlString)
            }
            
            imageView.contentMode = .scaleAspectFit
            imageView.isUserInteractionEnabled = true
            imageView.isMultipleTouchEnabled = true
            imageView.clipsToBounds = true
            self.addTapGestureRecognizer(view: imageView)
            self.addSwipeGestureRecognizer(view: imageView)
            bgScrollView.addSubview(imageView)
            
            //给相应的数组赋值
            imageViewArray.append(imageView)
            scrollViewArray.append(bgScrollView)
        } else {
            //imageView
            for i in 0..<imageCount {
                let bgScrollView = UIScrollView(frame: CGRect(x: screenWidth * CGFloat(i), y: 0, width: screenWidth, height: screenHeight))
                bgScrollView.delegate = self
                bgScrollView.maximumZoomScale = maxScale
                bgScrollView.minimumZoomScale = minScale
                scrollView.addSubview(bgScrollView)
                
                let imageView = UIImageView(frame: bgScrollView.bounds)
                imageView.contentMode = .scaleAspectFit
                
                if imagesArray[i].url == nil {
                    imageView.image = imagesArray[i].image //本地图片
                } else {
                    let urlString = URL(string: imagesArray[i].url == nil ? "" : imagesArray[i].url!)
                    //                    let placeHolderImg = UIImage(named: "banner_defaultImg")
                    //                    imageView.kf.setImage(with: urlString, placeholder: placeHolderImg)
                    imageView.kf.setImage(with: urlString)
                }
                
                imageView.isUserInteractionEnabled = true
                imageView.isMultipleTouchEnabled = true
                imageView.tag = i
                self.addTapGestureRecognizer(view: imageView)
                self.addSwipeGestureRecognizer(view: imageView)
                bgScrollView.addSubview(imageView)
                
                guard let image = imageView.image else { return }
                
                if i > 0 {
                    //设置UIScrollView的滚动范围和图片的真实尺寸一致
                    bgScrollView.contentSize = image.size
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
        
        let doubleTap = UITapGestureRecognizer(target: self, action: #selector(doubleTapAction(gesture:)))
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
    
    @objc fileprivate func doubleTapAction(gesture:UIGestureRecognizer) {
        DebugPrint(message: #function)
        
        if !isMaxScale {
            isMaxScale = true
            if scrollViewArray.count == 0 {
                scrollViewArray[currentIndexOfImage].setZoomScale(maxScale, animated: true)
            } else {
                let newScale = scrollViewArray[currentIndexOfImage].zoomScale * 1.5
                let zoomRect = self.zoomRectForScale(scale: newScale, center: gesture.location(in: gesture.view))
                scrollViewArray[currentIndexOfImage].zoom(to: zoomRect, animated: true)
            }
            
        } else {
            isMaxScale = false
            scrollViewArray[currentIndexOfImage].setZoomScale(minScale, animated: true)
        }
    }
    
    //MARK: - 展示图片查看器
    func showInView(view: UIView?) {
        if view == nil {
            return
        }
        
        view?.addSubview(self)
        view?.addSubview(scrollView)
        
        scrollView.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)//缩放效果
        scrollView.alpha = 0.0
        UIView.animate(withDuration: 0.4, animations: {
            self.scrollView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)//还原原始尺寸
            self.scrollView.alpha = 1.0
        }, completion: nil)
    }
    
    //MARK: 隐藏图片查看器
    fileprivate func disMissView() {
        scrollView.alpha = 1.0
        UIView.animate(withDuration: 0.4, animations: {
            self.scrollView.alpha = 0.0
            self.scrollView.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
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
            scrollViewArray[currentIndexOfImage].setZoomScale(minScale, animated: true)
            isMaxScale = false
        }
        
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if scrollView == scrollViewArray[currentIndexOfImage] {
            
            let offSet = scrollView.contentOffset
            DebugPrint(message: "offSet: \(offSet)")
            DebugPrint(message: "scrollView.contentSize: \(scrollView.contentSize)")
            let difference = offSet.y - screenHeight
            DebugPrint(message: "difference: \(difference)")
            
            
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
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        
        if scrollView == scrollViewArray[currentIndexOfImage] {
            let curImgView = imageViewArray[currentIndexOfImage]
            let offSetX = (scrollView.bounds.size.width > scrollView.contentSize.width) ? (scrollView.bounds.size.width - scrollView.contentSize.width) / 2 : 0.0
            let offSetY = (scrollView.bounds.size.height > scrollView.contentSize.height) ? (scrollView.bounds.size.height - scrollView.contentSize.height) / 2 : 0.0
            curImgView.center = CGPoint(x: scrollView.contentSize.width / 2 + offSetX, y: scrollView.contentSize.height / 2 + offSetY)
        }
    }
}

extension ZZJMultipleImagesContentView {
    
    ///zoomRectForScale
    fileprivate func zoomRectForScale(scale: CGFloat, center: CGPoint) -> CGRect {
        
        var zoomRect:CGRect = CGRect(x: 0, y: 0, width: 0, height: 0)
        let curScrollView = scrollViewArray[currentIndexOfImage]
        zoomRect.size.height = curScrollView.frame.size.height / scale
        zoomRect.size.width = curScrollView.frame.size.width / scale
        zoomRect.origin.x = center.x - (zoomRect.size.width / 2)
        zoomRect.origin.y = center.y - (zoomRect.size.height / 2)
        return zoomRect
    }
}












