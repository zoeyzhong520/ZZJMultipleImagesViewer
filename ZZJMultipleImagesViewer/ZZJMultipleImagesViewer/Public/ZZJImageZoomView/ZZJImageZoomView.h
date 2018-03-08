//
//  ZZJImageZoomView.h
//  ZZJImageZoomView
//
//  Created by JOE on 2017/5/17.
//  Copyright © 2017年 ZZJ. All rights reserved.
//

#import <UIKit/UIKit.h>

#define screenWidth [UIScreen mainScreen].bounds.size.width
#define screenHeight [UIScreen mainScreen].bounds.size.height

@interface ZZJImageZoomView : UIView

- (instancetype)initWithFrame:(CGRect)frame andImageView:(UIImageView *)imageView;

@end
