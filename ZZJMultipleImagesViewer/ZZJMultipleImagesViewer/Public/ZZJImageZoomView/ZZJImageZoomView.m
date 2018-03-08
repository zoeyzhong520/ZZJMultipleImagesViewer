//
//  ZZJImageZoomView.m
//  ZZJImageZoomView
//
//  Created by JOE on 2017/5/17.
//  Copyright © 2017年 ZZJ. All rights reserved.
//

#import "ZZJImageZoomView.h"

static CGRect oldFrame;
@interface ZZJImageZoomView ()<UIScrollViewDelegate>

@end

@implementation ZZJImageZoomView
{
    UIScrollView *holderView;
    UIImageView *showImgView;
    BOOL isFirst;
}

- (instancetype)initWithFrame:(CGRect)frame andImageView:(UIImageView *)imageView {
    if (self == [super initWithFrame:frame]) {
        self.frame = frame;
        UIImage *image = imageView.image;
        holderView = [[UIScrollView alloc] initWithFrame:frame];
        holderView.backgroundColor = [UIColor blackColor];
        holderView.showsHorizontalScrollIndicator = NO;//设置隐藏滚动条
        holderView.showsVerticalScrollIndicator = NO;
        holderView.scrollEnabled = YES;
        holderView.directionalLockEnabled = NO;
        holderView.bounces = NO;
        holderView.delegate = self;
        holderView.autoresizesSubviews = YES;
        holderView.maximumZoomScale = 4.0;//最大缩放比例
        holderView.minimumZoomScale = 1;//最小缩放比例
        [holderView setZoomScale:0.5 animated:NO];
        
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        oldFrame = [imageView convertRect:imageView.bounds toView:window];
        [holderView setBackgroundColor:[UIColor blackColor]];
        //此时视图不会显示
        [holderView setAlpha:0];
        //将所展示的imageView重新绘制
        showImgView = [[UIImageView alloc] initWithFrame:oldFrame];
        [showImgView setImage:imageView.image];
        [showImgView setTag:0];
        [holderView addSubview:showImgView];
        
        //动画放大所展示的ImageView
        __block CGFloat x,y,width,height;
        [UIView animateWithDuration:0.4 animations:^{
            if (image.size.width > image.size.height) {
                x = 0;
                y = (screenHeight - image.size.height * screenWidth / image.size.width) * 0.5;
                //宽度为屏幕宽度
                width = screenWidth;
                //高度 根据图片宽高比设置
                height = image.size.height * screenWidth / image.size.width;
            }else{
                x = (screenWidth - image.size.width * screenHeight / image.size.height) * 0.5;
                y = 0;
                //宽度 根据图片宽高比设置
                width = image.size.width * screenHeight / image.size.height;
                //高度为屏幕高度
                height = screenHeight;
            }
            
            [showImgView setFrame:CGRectMake(x, y, width, height)];
            //将视图显示出来
            [holderView setAlpha:1];
        } completion:^(BOOL finished) {
            
        }];
        
        UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTap:)];
        [doubleTap setNumberOfTapsRequired:2];
        [holderView addGestureRecognizer:doubleTap];
        [self addSubview:holderView];
        
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTap:)];
        [doubleTap setNumberOfTapsRequired:1];
        [holderView addGestureRecognizer:singleTap];
        [doubleTap requireGestureRecognizerToFail:singleTap];
    }
    return self;
}

- (void)handleDoubleTap:(UIGestureRecognizer *)gesture {
    if (!isFirst) {
        isFirst = YES;
        CGPoint pointInView = [gesture locationInView:holderView];
        CGFloat newZoomScale = holderView.zoomScale * 4.0f;
        newZoomScale = MIN(newZoomScale, holderView.maximumZoomScale);
        
        CGSize scrollViewSize = holderView.bounds.size;
        CGFloat w = scrollViewSize.width / newZoomScale;
        CGFloat h = scrollViewSize.height / newZoomScale;
        CGFloat x = pointInView.x - (w / 2.0f);
        CGFloat y = pointInView.y - (h / 2.0f);
        CGRect rectToZoomTo = CGRectMake(x, y, w, h);
        [holderView zoomToRect:rectToZoomTo animated:YES];
    }else{
        isFirst = NO;
        CGFloat newZoomScale = holderView.zoomScale / 4.0f;
        newZoomScale = MAX(newZoomScale, holderView.minimumZoomScale);
        [holderView setZoomScale:newZoomScale animated:YES];
    }
}

- (void)singleTap:(UIGestureRecognizer *)gesture {
    [UIView animateWithDuration:0.4 animations:^{
        [showImgView setFrame:oldFrame];
        [holderView setAlpha:0];
    } completion:^(BOOL finished) {
       //完成后操作->将背景视图删掉
        [holderView removeFromSuperview];
        [self removeFromSuperview];
    }];
}

#pragma mark -- UIScrollViewDelegate
- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    CGFloat offSetX = (scrollView.bounds.size.width > scrollView.contentSize.width) ? (scrollView.bounds.size.width - scrollView.contentSize.width) * 0.5 : 0.0;
    
    CGFloat offSetY = (scrollView.bounds.size.height > scrollView.contentSize.height) ? (scrollView.bounds.size.height - scrollView.contentSize.height) * 0.5 : 0.0;
    
    showImgView.center = CGPointMake(scrollView.contentSize.width * 0.5 + offSetX, scrollView.contentSize.height * 0.5 + offSetY);
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return showImgView;
}

@end
