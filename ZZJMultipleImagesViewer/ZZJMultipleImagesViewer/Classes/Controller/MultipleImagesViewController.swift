//
//  MultipleImagesViewController.swift
//  ZZJMultipleImagesViewer
//
//  Created by ZHONG ZHAOJUN on 2018/2/28.
//  Copyright © 2018年 ZHONG ZHAOJUN. All rights reserved.
//

import UIKit

///imgURLString
fileprivate let imgURLString = "http://seopic.699pic.com/photo/50036/2893.jpg_wh1200.jpg"

class MultipleImagesViewController: BaseViewController {
    
    ///imageURLArray
    var imageURLArray = ["http://d.5857.com/mac_161029/001.jpg", "http://d.5857.com/mac_161029/002.jpg", "http://d.5857.com/mac_161029/006.jpg", "http://d.5857.com/mac_161029/007.jpg", "http://d.5857.com/mac_161029/009.jpg", "http://d.5857.com/mac_161029/010.jpg", "http://d.5857.com/mac_161029/012.jpg"]
    
    ///descArray
    var descArray = ["3月16日下午，小米在京举办2018年首场新品发布会，正式发布千元新机红米Note 5。此次发布会有两大看点：1、千元拍照专家是如何炼成的？2、骁龙636中国首发。", "发布会一开始，林斌分享了小米手机的最新战绩：2017年Q4中国市场逆势增长57.6%，并重回全球第四。", "2017年小米质量委员会成立，全年共召开245次跨部门质量讨论会，专项改善200余项。雷军获质量之光“年度质量人物奖”。2018年小米将会继续狠抓品质与创新，做出更多高品质、可信赖的红米国民手机", "今天的主角红米Note 5号称千元机中的“水桶机”（无短板），搭载骁龙636处理器，6GB内存，内置4000mAh容量电池。", "此外，新机还主打千元拍照专家，支持AI双摄，暗光、逆光拍照更出色。此外，新机还配备了1300万像素柔光自拍镜头，支持背景虚化和人脸解锁。", "太逆天！小米手机终极目标宣布：坏了不修 直接换新", "值得一提的是，此次发布会由小米总裁林斌代替雷军主讲，一身西装十分干练。"]
    
    ///button
    var button:UIButton!
    
    ///imageView
    var imageView:UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setPage()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension MultipleImagesViewController {
    
    fileprivate func setPage() {
        self.navigationController?.navigationBar.isHidden = true
        title = "多图查看器"
        setButtons()
        setImageView()
    }
    
    ///set UIButton 设置按钮
    fileprivate func setButtons() {
        let button = UIButton(type: .system)
        button.setTitleColor(UIColor.white, for: .normal)
        button.setTitle("点击加载图片查看器", for: .normal)
        button.frame = CGRect(x: 0, y: 34, width: screenWidth, height: 48)
        button.backgroundColor = HexColor("ff99ff")
        button.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        view.addSubview(button)
        self.button = button
    }
    
    ///set UIImageView
    fileprivate func setImageView() {
        let imageView = UIImageView(frame: CGRect(x: 0, y: button.frame.maxY + 34, width: screenWidth, height: screenWidth * 0.618))
        imageView.image = UIImage(named: "1.jpg")
        imageView.contentMode = .scaleAspectFit
        view.addSubview(imageView)
        self.imageView = imageView
        
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(imgTapAction)))
    }
    
    ///buttonAction
    @objc fileprivate func buttonAction() {
        DebugPrint(message: #function)
        setZZJMultipleImagesContentView()
    }
    
    @objc fileprivate func imgTapAction() {
        let model = MultipleImagesModel.createModel(image: imageView.image, url: nil, imageType: ImageType.Local, desc: "2017年小米质量委员会成立，全年共召开245次跨部门质量讨论会，专项改善200余项。雷军获质量之光“年度质量人物奖”。2018年小米将会继续狠抓品质与创新，做出更多高品质、可信赖的红米国民手机")
        let multipleImagesView = ZZJMultipleImagesContentView(frame: .zero, imagesArray: [model])
        multipleImagesView.showInView(view: zzj_KeyWindow)
    }
    
    ///set ZZJMultipleImagesContentView
    fileprivate func setZZJMultipleImagesContentView() {
        
        var imagesArray = [MultipleImagesModel]()
        for i in 0..<6 {
            
            let model = MultipleImagesModel.createModel(image: UIImage(named: "\(i+1).jpg"), url: nil, imageType: ImageType.Local, desc: descArray[i])
            imagesArray.append(model)
        }

//        for i in 0..<imageURLArray.count {
//            let model = MultipleImagesModel.createModel(image: nil, url: imageURLArray[i], imageType: ImageType.Net, desc: descArray[i])
//            imagesArray.append(model)
//        }
        
        let multipleImagesView = ZZJMultipleImagesContentView(frame: .zero, imagesArray: imagesArray)
        multipleImagesView.showInView(view: zzj_KeyWindow)
    }
}











