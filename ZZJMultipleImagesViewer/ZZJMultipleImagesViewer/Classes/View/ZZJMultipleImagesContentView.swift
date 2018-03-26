//
//  ZZJMultipleImagesContentView.swift
//  ZZJMultipleImagesViewer
//
//  Created by ZHONG ZHAOJUN on 2018/2/28.
//  Copyright © 2018年 ZHONG ZHAOJUN. All rights reserved.
//

import UIKit
import Kingfisher

enum ImageType: Int {
    case Net = 0
    case Local
}

class ZZJMultipleImagesContentView: UIView {

    ///scrollView
    fileprivate var scrollView:UIScrollView!
    
    ///imagesArray 图片数组
    fileprivate var imagesArray = [MultipleImagesModel]()
    
    ///image的数量
    fileprivate var imageCount:Int = 0
    
    ///currentIndexOfImage 当前是第几张
    fileprivate var currentIndexOfImage:Int = 0
    
    ///oldIndex 记录滚动过的位置
    fileprivate var oldIndex:Int = 0
    
    ///imageViewArray 存放imageView的数组
    fileprivate var imageViewArray = [UIImageView]()
    
    ///scrollViewArray 存放scrollView的数组
    fileprivate var scrollViewArray = [UIScrollView]()
    
    ///isMaxScale 是否放大到最大限度
    fileprivate var isMaxScale = false
    
    ///maxScale 放大的最大限度
    fileprivate var maxScale:CGFloat = 3.0
    
    ///minScale 缩小的最大限度
    fileprivate var minScale:CGFloat = 1.0
    
    ///UIActivityIndicatorView
    fileprivate lazy var indicatorView:UIActivityIndicatorView = {
        let indicatorView = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        indicatorView.activityIndicatorViewStyle = .gray
        indicatorView.activityIndicatorViewStyle = .whiteLarge
//        indicatorView.backgroundColor = UIColor.lightGray
        indicatorView.center = self.center
        return indicatorView
    }()
    
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
            //scrollView
            scrollView = UIScrollView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight))
            scrollView.backgroundColor = UIColor.black
            scrollView.isUserInteractionEnabled = true
            scrollView.isPagingEnabled = true
            scrollView.delegate = self
            scrollView.isDirectionalLockEnabled = true
            
            addSubview(scrollView)
            scrollView.contentSize = CGSize(width: screenWidth * CGFloat(imageCount), height: screenHeight)
            
            self.configArray()
        }
    }
    
    ///config imageViewArray && scrollViewArray
    fileprivate func configArray() {
        
        //imageView
        for i in 0..<imageCount {
            let bgScrollView = UIScrollView(frame: CGRect(x: screenWidth * CGFloat(i), y: 0, width: screenWidth, height: screenHeight))
            bgScrollView.delegate = self
            bgScrollView.maximumZoomScale = maxScale
            bgScrollView.minimumZoomScale = minScale
            scrollView.addSubview(bgScrollView)
            
            let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: screenWidth)) //设置默认frame
            imageView.isUserInteractionEnabled = true
            imageView.isMultipleTouchEnabled = true
            imageView.tag = i
            self.addTapGestureRecognizer(view: imageView)
            self.addSwipeGestureRecognizer(view: imageView)
            bgScrollView.addSubview(imageView)
            imageView.addSubview(indicatorView)
            
            if let imageType = imagesArray[i].imageType {
                switch imageType {
                case .Net:
                    let urlString = URL(string: imagesArray[i].url ?? "")
                    imageView.kf.setImage(with: urlString, progressBlock: { (receivedSize, totalSize) in
                        self.indicatorView.startAnimating()
                    }, completionHandler: { (image, error, cacheType, imageUrl) in
                        self.indicatorView.stopAnimating()
                        imageView.frame = self.setImageViewFrame(withImage: image) //重设frame
                    }) //网络图片
                case .Local:
                    imageView.image = imagesArray[i].image //本地图片
                    imageView.frame = self.setImageViewFrame(withImage: imageView.image) //重设frame
                }
            }
            
            //展示描述文本的View
            self.addMultipleImagesDescriptionView(withTag: i, withView: bgScrollView)
            
            //给相应的数组赋值
            imageViewArray.append(imageView)
            scrollViewArray.append(bgScrollView)
        }
    }
    
    ///设置ImageView的frame
    fileprivate func setImageViewFrame(withImage image: UIImage?) -> CGRect {
        
        guard let image = image else {
            DebugPrint(message: "image is nil")
            return CGRect(x: 0, y: 0, width: screenWidth, height: screenWidth)
        }
        
        let imageView_X = image.size.width > screenWidth ? screenWidth : image.size.width
        var imageView_Y = image.size.height > screenHeight ? screenHeight : image.size.height
        if image.size.width > screenWidth {
            //图片尺寸的宽度大于屏幕宽，则按比例取得高度
            imageView_Y = image.size.height * (screenWidth / image.size.width)
        }
        
        return CGRect(x: (screenWidth - imageView_X) / 2, y: (screenHeight - imageView_Y) / 2, width: imageView_X, height: imageView_Y)
    }
    
    ///展示描述文本的View
    fileprivate func addMultipleImagesDescriptionView(withTag tag: Int, withView view: UIView) {
        
        let multipleImagesDescriptionView = MultipleImagesDescriptionView(frame: .zero, model: imagesArray[tag])
        scrollView.addSubview(multipleImagesDescriptionView)
        
        //添加约束
        multipleImagesDescriptionView.translatesAutoresizingMaskIntoConstraints = false
        //1.左边约束
        let left:NSLayoutConstraint = NSLayoutConstraint(item: multipleImagesDescriptionView, attribute: .left, relatedBy: .equal, toItem: view, attribute: .left, multiplier: 1.0, constant: 0)
        scrollView.addConstraint(left)
        
        //2.右边约束
        let right:NSLayoutConstraint = NSLayoutConstraint(item: multipleImagesDescriptionView, attribute: .right, relatedBy: .equal, toItem: view, attribute: .right, multiplier: 1.0, constant: 0)
        scrollView.addConstraint(right)
        
        //3.下边约束
        let bottom:NSLayoutConstraint = NSLayoutConstraint(item: multipleImagesDescriptionView, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1.0, constant: 0)
        scrollView.addConstraint(bottom)
        
        //4.高度约束
        let height:NSLayoutConstraint = NSLayoutConstraint(item: multipleImagesDescriptionView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: MultipleImagesDescriptionView.getViewHeight(withModel: imagesArray[tag]))
        scrollView.addConstraint(height)
    }
    
    //MARK: - 添加手势
    ///添加单击手势
    fileprivate func addTapGestureRecognizer(view: UIView) {
        
        //单击
        let singleTap = UITapGestureRecognizer(target: self, action: #selector(tapAction))
        singleTap.numberOfTapsRequired = 1
        view.addGestureRecognizer(singleTap)
        
        //双击
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
            
            let newScale = scrollViewArray[currentIndexOfImage].zoomScale * maxScale
            let zoomRect = self.zoomRectForScale(scale: newScale, center: gesture.location(in: gesture.view))
            scrollViewArray[currentIndexOfImage].zoom(to: zoomRect, animated: true)
            
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
            self.indicatorView.stopAnimating()
            self.removeFromSuperview()
            self.scrollView.removeFromSuperview()
        }
    }
}

//MARK: - UIScrollViewDelegate
extension ZZJMultipleImagesContentView: UIScrollViewDelegate {
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        DebugPrint(message: #function)
    }
    
    func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
        DebugPrint(message: #function)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if scrollView == self.scrollView {
            DebugPrint(message: #function)
            //更新currentIndexOfImage的值
            currentIndexOfImage = Int(scrollView.contentOffset.x / screenWidth)
            DebugPrint(message: "当前是第\(currentIndexOfImage+1)张图片～")
            
            scrollViewArray[currentIndexOfImage].setZoomScale(minScale, animated: true)
        }
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        DebugPrint(message: #function)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == self.scrollView {
//            let offsetX = scrollView.contentOffset.x
//            DebugPrint(message: "offsetX: \(offsetX)")
        }
    }
    
    //代理方法，告诉ScrollView要缩放的是哪个视图
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageViewArray[currentIndexOfImage]
    }
    
    func scrollViewDidEndZooming(_ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat) {
        if scrollView == scrollViewArray[currentIndexOfImage] {
            scrollView.setZoomScale(scale, animated: true)
            if scale > minScale && scale <= maxScale {
                isMaxScale = true
            } else {
                isMaxScale = false
            }
        }
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        
        if scrollView == scrollViewArray[currentIndexOfImage] {
            
            //实现图片在缩放过程中居中
            let offsetX = scrollView.bounds.size.width > scrollView.contentSize.width ? (scrollView.bounds.size.width - scrollView.contentSize.width) / 2 : 0.0
            let offsetY = scrollView.bounds.size.height > scrollView.contentSize.height ? (scrollView.bounds.size.height - scrollView.contentSize.height) / 2 : 0.0
            imageViewArray[currentIndexOfImage].center = CGPoint(x: scrollView.contentSize.width / 2 + offsetX, y: scrollView.contentSize.height / 2 + offsetY)
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



